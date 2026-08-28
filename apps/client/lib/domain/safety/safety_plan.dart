import 'dart:convert';

/// Who a safety-plan contact is.
///
/// Stored by name in JSON. Unknown values decode to [support].
enum SafetyContactKind { support, professional }

class SafetyContact {
  const SafetyContact({
    required this.name,
    required this.phone,
    this.kind = SafetyContactKind.support,
  });

  final String name;
  final String phone;
  final SafetyContactKind kind;

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'kind': kind.name,
  };

  factory SafetyContact.fromJson(Map<String, dynamic> json) => SafetyContact(
    name: (json['name'] as String?) ?? '',
    phone: (json['phone'] as String?) ?? '',
    kind: SafetyContactKind.values.firstWhere(
      (k) => k.name == json['kind'],
      orElse: () => SafetyContactKind.support,
    ),
  );
}

/// A personal crisis plan: warning signs, coping strategies, distractions,
/// people to reach, and how to keep the environment safe.
class SafetyPlan {
  const SafetyPlan({
    this.warningSigns = '',
    this.copingStrategies = '',
    this.distractions = '',
    this.environmentSafety = '',
    this.contacts = const [],
  });

  final String warningSigns;
  final String copingStrategies;
  final String distractions;
  final String environmentSafety;
  final List<SafetyContact> contacts;

  bool get isEmpty =>
      warningSigns.trim().isEmpty &&
      copingStrategies.trim().isEmpty &&
      distractions.trim().isEmpty &&
      environmentSafety.trim().isEmpty &&
      contacts.isEmpty;

  SafetyPlan copyWith({
    String? warningSigns,
    String? copingStrategies,
    String? distractions,
    String? environmentSafety,
    List<SafetyContact>? contacts,
  }) => SafetyPlan(
    warningSigns: warningSigns ?? this.warningSigns,
    copingStrategies: copingStrategies ?? this.copingStrategies,
    distractions: distractions ?? this.distractions,
    environmentSafety: environmentSafety ?? this.environmentSafety,
    contacts: contacts ?? this.contacts,
  );

  Map<String, dynamic> toJson() => {
    'warningSigns': warningSigns,
    'copingStrategies': copingStrategies,
    'distractions': distractions,
    'environmentSafety': environmentSafety,
    'contacts': [for (final c in contacts) c.toJson()],
  };

  factory SafetyPlan.fromJson(Map<String, dynamic> json) => SafetyPlan(
    warningSigns: (json['warningSigns'] as String?) ?? '',
    copingStrategies: (json['copingStrategies'] as String?) ?? '',
    distractions: (json['distractions'] as String?) ?? '',
    environmentSafety: (json['environmentSafety'] as String?) ?? '',
    contacts: [
      for (final c in (json['contacts'] as List?) ?? const [])
        SafetyContact.fromJson((c as Map).cast<String, dynamic>()),
    ],
  );

  String encode() => jsonEncode(toJson());

  static SafetyPlan decode(String? source) {
    if (source == null || source.isEmpty) return const SafetyPlan();
    try {
      return SafetyPlan.fromJson(
        (jsonDecode(source) as Map).cast<String, dynamic>(),
      );
    } catch (_) {
      return const SafetyPlan();
    }
  }
}
