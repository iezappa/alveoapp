import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Starts the app over from a clean provider container.
typedef RestartApp = Future<void> Function();

/// Builds a ready container: database opened, preferences loaded.
typedef AppBootstrap = Future<ProviderContainer> Function(RestartApp restart);

/// Starts the app over from a clean provider tree.
///
/// Wiping or replacing the whole store leaves every provider holding state
/// read from a store that no longer exists — cached rows, preferences read at
/// startup, a connection that failed to open. Invalidating each one by hand
/// is a list that goes stale the day a feature is added; throwing the whole
/// container away cannot.
final restartAppProvider = Provider<RestartApp>(
  (ref) => throw UnimplementedError(
    'restartAppProvider must be overridden by AppRestartHost',
  ),
);

/// Owns the app's [ProviderContainer], so it can replace it.
class AppRestartHost extends StatefulWidget {
  const AppRestartHost({
    super.key,
    required this.bootstrap,
    required this.child,
    this.beforeDispose,
  });

  final AppBootstrap bootstrap;
  final Widget child;

  /// Runs on the old container before it is disposed — closing the database,
  /// so the next one does not open the same store while it is still held.
  final Future<void> Function(ProviderContainer container)? beforeDispose;

  @override
  State<AppRestartHost> createState() => _AppRestartHostState();
}

class _AppRestartHostState extends State<AppRestartHost> {
  ProviderContainer? _container;
  Key _generation = UniqueKey();

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final container = await widget.bootstrap(_restart);
    if (!mounted) {
      container.dispose();
      return;
    }
    setState(() {
      _container = container;
      _generation = UniqueKey();
    });
  }

  Future<void> _restart() async {
    final old = _container;
    if (old == null) return;

    // Take the app off screen first, so no widget reads the old container
    // while it is being torn down.
    setState(() => _container = null);
    await WidgetsBinding.instance.endOfFrame;

    await widget.beforeDispose?.call(old);
    old.dispose();
    await _start();
  }

  @override
  void dispose() {
    _container?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final container = _container;
    if (container == null) return const SizedBox.shrink();
    return UncontrolledProviderScope(
      key: _generation,
      container: container,
      child: widget.child,
    );
  }
}
