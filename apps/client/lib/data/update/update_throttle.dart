/// Settings key holding when the last update check ran (ISO-8601).
const lastUpdateCheckSettingKey = 'update.last_check_at';

/// GitHub allows 60 unauthenticated requests per hour per IP, and an update
/// is not news that cannot wait: six hours between checks.
const updateCheckInterval = Duration(hours: 6);

bool shouldCheckForUpdate({
  required DateTime? lastCheck,
  required DateTime now,
}) => lastCheck == null || now.difference(lastCheck) >= updateCheckInterval;
