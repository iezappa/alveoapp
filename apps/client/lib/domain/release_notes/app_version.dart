/// A released version, `major.minor.patch`. Compared numerically: as strings
/// `1.10.0` would sort before `1.9.0`.
class AppVersion implements Comparable<AppVersion> {
  const AppVersion(this.major, this.minor, this.patch);

  final int major, minor, patch;

  /// Accepts `1.2.3`, `v1.2.3` and `1.2.3+45` (the build is ignored).
  static AppVersion? tryParse(String? raw) {
    if (raw == null) return null;
    final m = RegExp(r'^v?(\d+)\.(\d+)\.(\d+)(\+\d+)?$').firstMatch(raw.trim());
    if (m == null) return null;
    return AppVersion(int.parse(m[1]!), int.parse(m[2]!), int.parse(m[3]!));
  }

  @override
  int compareTo(AppVersion o) => major != o.major
      ? major.compareTo(o.major)
      : minor != o.minor
      ? minor.compareTo(o.minor)
      : patch.compareTo(o.patch);

  bool operator >(AppVersion o) => compareTo(o) > 0;
  bool operator <(AppVersion o) => compareTo(o) < 0;

  @override
  bool operator ==(Object other) =>
      other is AppVersion && compareTo(other) == 0;

  @override
  int get hashCode => Object.hash(major, minor, patch);

  @override
  String toString() => '$major.$minor.$patch';
}
