import 'package:alveo/app/app_restart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final _generationProvider = Provider<int>((ref) => -1);

class _ShowGeneration extends ConsumerWidget {
  const _ShowGeneration();

  @override
  Widget build(BuildContext context, WidgetRef ref) => Directionality(
    textDirection: TextDirection.ltr,
    child: GestureDetector(
      onTap: () => ref.read(restartAppProvider)(),
      child: Text('generation ${ref.watch(_generationProvider)}'),
    ),
  );
}

void main() {
  testWidgets('builds a fresh container on restart and disposes the old one', (
    tester,
  ) async {
    var built = 0;
    final disposed = <int>[];

    await tester.pumpWidget(
      AppRestartHost(
        bootstrap: (restart) async {
          final generation = built++;
          return ProviderContainer(
            overrides: [
              _generationProvider.overrideWithValue(generation),
              restartAppProvider.overrideWithValue(restart),
            ],
          );
        },
        beforeDispose: (container) async =>
            disposed.add(container.read(_generationProvider)),
        child: const _ShowGeneration(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('generation 0'), findsOneWidget);

    await tester.tap(find.text('generation 0'));
    await tester.pumpAndSettle();

    expect(find.text('generation 1'), findsOneWidget);
    expect(disposed, [0]);
  });
}
