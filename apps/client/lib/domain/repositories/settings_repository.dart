/// Device-local key/value settings (language, theme, the PIN hash, flags).
abstract interface class SettingsRepository {
  Future<String?> get(String key);
  Future<void> set(String key, String value);
  Future<void> remove(String key);
}
