// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MoodEntriesTable extends MoodEntries
    with TableInfo<$MoodEntriesTable, MoodEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
    'mood',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, occurredAt, mood, note, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MoodEntriesTable createAlias(String alias) {
    return $MoodEntriesTable(attachedDatabase, alias);
  }
}

class MoodEntry extends DataClass implements Insertable<MoodEntry> {
  final String id;

  /// When the feeling happened. May be backdated by the user.
  final DateTime occurredAt;
  final int mood;

  /// Short plain-text note. NOT markdown — the markdown surface is
  /// [JournalEntries]. Keeping them separate avoids mixing a quick tag-along
  /// note with a full journal document.
  final String? note;
  final DateTime createdAt;
  const MoodEntry({
    required this.id,
    required this.occurredAt,
    required this.mood,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['mood'] = Variable<int>(mood);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MoodEntriesCompanion toCompanion(bool nullToAbsent) {
    return MoodEntriesCompanion(
      id: Value(id),
      occurredAt: Value(occurredAt),
      mood: Value(mood),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory MoodEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodEntry(
      id: serializer.fromJson<String>(json['id']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      mood: serializer.fromJson<int>(json['mood']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'mood': serializer.toJson<int>(mood),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MoodEntry copyWith({
    String? id,
    DateTime? occurredAt,
    int? mood,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => MoodEntry(
    id: id ?? this.id,
    occurredAt: occurredAt ?? this.occurredAt,
    mood: mood ?? this.mood,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  MoodEntry copyWithCompanion(MoodEntriesCompanion data) {
    return MoodEntry(
      id: data.id.present ? data.id.value : this.id,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      mood: data.mood.present ? data.mood.value : this.mood,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntry(')
          ..write('id: $id, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('mood: $mood, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, occurredAt, mood, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodEntry &&
          other.id == this.id &&
          other.occurredAt == this.occurredAt &&
          other.mood == this.mood &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class MoodEntriesCompanion extends UpdateCompanion<MoodEntry> {
  final Value<String> id;
  final Value<DateTime> occurredAt;
  final Value<int> mood;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MoodEntriesCompanion({
    this.id = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.mood = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoodEntriesCompanion.insert({
    required String id,
    required DateTime occurredAt,
    required int mood,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       occurredAt = Value(occurredAt),
       mood = Value(mood);
  static Insertable<MoodEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? occurredAt,
    Expression<int>? mood,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (mood != null) 'mood': mood,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoodEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? occurredAt,
    Value<int>? mood,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MoodEntriesCompanion(
      id: id ?? this.id,
      occurredAt: occurredAt ?? this.occurredAt,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntriesCompanion(')
          ..write('id: $id, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('mood: $mood, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoodEntryEmotionsTable extends MoodEntryEmotions
    with TableInfo<$MoodEntryEmotionsTable, MoodEntryEmotion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodEntryEmotionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _moodEntryIdMeta = const VerificationMeta(
    'moodEntryId',
  );
  @override
  late final GeneratedColumn<String> moodEntryId = GeneratedColumn<String>(
    'mood_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mood_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _emotionKeyMeta = const VerificationMeta(
    'emotionKey',
  );
  @override
  late final GeneratedColumn<String> emotionKey = GeneratedColumn<String>(
    'emotion_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<int> intensity = GeneratedColumn<int>(
    'intensity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [moodEntryId, emotionKey, intensity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_entry_emotions';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodEntryEmotion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('mood_entry_id')) {
      context.handle(
        _moodEntryIdMeta,
        moodEntryId.isAcceptableOrUnknown(
          data['mood_entry_id']!,
          _moodEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_moodEntryIdMeta);
    }
    if (data.containsKey('emotion_key')) {
      context.handle(
        _emotionKeyMeta,
        emotionKey.isAcceptableOrUnknown(data['emotion_key']!, _emotionKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_emotionKeyMeta);
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    } else if (isInserting) {
      context.missing(_intensityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {moodEntryId, emotionKey};
  @override
  MoodEntryEmotion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodEntryEmotion(
      moodEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood_entry_id'],
      )!,
      emotionKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emotion_key'],
      )!,
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity'],
      )!,
    );
  }

  @override
  $MoodEntryEmotionsTable createAlias(String alias) {
    return $MoodEntryEmotionsTable(attachedDatabase, alias);
  }
}

class MoodEntryEmotion extends DataClass
    implements Insertable<MoodEntryEmotion> {
  final String moodEntryId;
  final String emotionKey;

  /// 1..5. Validated in the domain layer (see [MoodEntries.mood]).
  final int intensity;
  const MoodEntryEmotion({
    required this.moodEntryId,
    required this.emotionKey,
    required this.intensity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['mood_entry_id'] = Variable<String>(moodEntryId);
    map['emotion_key'] = Variable<String>(emotionKey);
    map['intensity'] = Variable<int>(intensity);
    return map;
  }

  MoodEntryEmotionsCompanion toCompanion(bool nullToAbsent) {
    return MoodEntryEmotionsCompanion(
      moodEntryId: Value(moodEntryId),
      emotionKey: Value(emotionKey),
      intensity: Value(intensity),
    );
  }

  factory MoodEntryEmotion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodEntryEmotion(
      moodEntryId: serializer.fromJson<String>(json['moodEntryId']),
      emotionKey: serializer.fromJson<String>(json['emotionKey']),
      intensity: serializer.fromJson<int>(json['intensity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'moodEntryId': serializer.toJson<String>(moodEntryId),
      'emotionKey': serializer.toJson<String>(emotionKey),
      'intensity': serializer.toJson<int>(intensity),
    };
  }

  MoodEntryEmotion copyWith({
    String? moodEntryId,
    String? emotionKey,
    int? intensity,
  }) => MoodEntryEmotion(
    moodEntryId: moodEntryId ?? this.moodEntryId,
    emotionKey: emotionKey ?? this.emotionKey,
    intensity: intensity ?? this.intensity,
  );
  MoodEntryEmotion copyWithCompanion(MoodEntryEmotionsCompanion data) {
    return MoodEntryEmotion(
      moodEntryId: data.moodEntryId.present
          ? data.moodEntryId.value
          : this.moodEntryId,
      emotionKey: data.emotionKey.present
          ? data.emotionKey.value
          : this.emotionKey,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntryEmotion(')
          ..write('moodEntryId: $moodEntryId, ')
          ..write('emotionKey: $emotionKey, ')
          ..write('intensity: $intensity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(moodEntryId, emotionKey, intensity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodEntryEmotion &&
          other.moodEntryId == this.moodEntryId &&
          other.emotionKey == this.emotionKey &&
          other.intensity == this.intensity);
}

class MoodEntryEmotionsCompanion extends UpdateCompanion<MoodEntryEmotion> {
  final Value<String> moodEntryId;
  final Value<String> emotionKey;
  final Value<int> intensity;
  final Value<int> rowid;
  const MoodEntryEmotionsCompanion({
    this.moodEntryId = const Value.absent(),
    this.emotionKey = const Value.absent(),
    this.intensity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoodEntryEmotionsCompanion.insert({
    required String moodEntryId,
    required String emotionKey,
    required int intensity,
    this.rowid = const Value.absent(),
  }) : moodEntryId = Value(moodEntryId),
       emotionKey = Value(emotionKey),
       intensity = Value(intensity);
  static Insertable<MoodEntryEmotion> custom({
    Expression<String>? moodEntryId,
    Expression<String>? emotionKey,
    Expression<int>? intensity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (moodEntryId != null) 'mood_entry_id': moodEntryId,
      if (emotionKey != null) 'emotion_key': emotionKey,
      if (intensity != null) 'intensity': intensity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoodEntryEmotionsCompanion copyWith({
    Value<String>? moodEntryId,
    Value<String>? emotionKey,
    Value<int>? intensity,
    Value<int>? rowid,
  }) {
    return MoodEntryEmotionsCompanion(
      moodEntryId: moodEntryId ?? this.moodEntryId,
      emotionKey: emotionKey ?? this.emotionKey,
      intensity: intensity ?? this.intensity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (moodEntryId.present) {
      map['mood_entry_id'] = Variable<String>(moodEntryId.value);
    }
    if (emotionKey.present) {
      map['emotion_key'] = Variable<String>(emotionKey.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(intensity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntryEmotionsCompanion(')
          ..write('moodEntryId: $moodEntryId, ')
          ..write('emotionKey: $emotionKey, ')
          ..write('intensity: $intensity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryDateMeta = const VerificationMeta(
    'entryDate',
  );
  @override
  late final GeneratedColumn<DateTime> entryDate = GeneratedColumn<DateTime>(
    'entry_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyMarkdownMeta = const VerificationMeta(
    'bodyMarkdown',
  );
  @override
  late final GeneratedColumn<String> bodyMarkdown = GeneratedColumn<String>(
    'body_markdown',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<JournalSection, int> section =
      GeneratedColumn<int>(
        'section',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: Constant(JournalSection.oneLiner.index),
      ).withConverter<JournalSection>($JournalEntriesTable.$convertersection);
  static const VerificationMeta _isMonthlyReviewMeta = const VerificationMeta(
    'isMonthlyReview',
  );
  @override
  late final GeneratedColumn<bool> isMonthlyReview = GeneratedColumn<bool>(
    'is_monthly_review',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_monthly_review" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entryDate,
    createdAt,
    updatedAt,
    title,
    bodyMarkdown,
    section,
    isMonthlyReview,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entry_date')) {
      context.handle(
        _entryDateMeta,
        entryDate.isAcceptableOrUnknown(data['entry_date']!, _entryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_entryDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('body_markdown')) {
      context.handle(
        _bodyMarkdownMeta,
        bodyMarkdown.isAcceptableOrUnknown(
          data['body_markdown']!,
          _bodyMarkdownMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bodyMarkdownMeta);
    }
    if (data.containsKey('is_monthly_review')) {
      context.handle(
        _isMonthlyReviewMeta,
        isMonthlyReview.isAcceptableOrUnknown(
          data['is_monthly_review']!,
          _isMonthlyReviewMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      bodyMarkdown: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_markdown'],
      )!,
      section: $JournalEntriesTable.$convertersection.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}section'],
        )!,
      ),
      isMonthlyReview: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_monthly_review'],
      )!,
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<JournalSection, int, int> $convertersection =
      const EnumIndexConverter<JournalSection>(JournalSection.values);
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  final String id;

  /// The day this entry belongs to (stored at local midnight). Separate from
  /// [createdAt] so an entry written after midnight can still be filed under
  /// the previous day for the daily export.
  final DateTime entryDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? title;
  final String bodyMarkdown;

  /// Which notebook this entry belongs to.
  final JournalSection section;

  /// True for the monthly-review entry of the "Diario" section (its
  /// [entryDate] is the first day of the month it reviews).
  final bool isMonthlyReview;
  const JournalEntry({
    required this.id,
    required this.entryDate,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    required this.bodyMarkdown,
    required this.section,
    required this.isMonthlyReview,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entry_date'] = Variable<DateTime>(entryDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['body_markdown'] = Variable<String>(bodyMarkdown);
    {
      map['section'] = Variable<int>(
        $JournalEntriesTable.$convertersection.toSql(section),
      );
    }
    map['is_monthly_review'] = Variable<bool>(isMonthlyReview);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      entryDate: Value(entryDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      bodyMarkdown: Value(bodyMarkdown),
      section: Value(section),
      isMonthlyReview: Value(isMonthlyReview),
    );
  }

  factory JournalEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<String>(json['id']),
      entryDate: serializer.fromJson<DateTime>(json['entryDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      title: serializer.fromJson<String?>(json['title']),
      bodyMarkdown: serializer.fromJson<String>(json['bodyMarkdown']),
      section: $JournalEntriesTable.$convertersection.fromJson(
        serializer.fromJson<int>(json['section']),
      ),
      isMonthlyReview: serializer.fromJson<bool>(json['isMonthlyReview']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entryDate': serializer.toJson<DateTime>(entryDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'title': serializer.toJson<String?>(title),
      'bodyMarkdown': serializer.toJson<String>(bodyMarkdown),
      'section': serializer.toJson<int>(
        $JournalEntriesTable.$convertersection.toJson(section),
      ),
      'isMonthlyReview': serializer.toJson<bool>(isMonthlyReview),
    };
  }

  JournalEntry copyWith({
    String? id,
    DateTime? entryDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> title = const Value.absent(),
    String? bodyMarkdown,
    JournalSection? section,
    bool? isMonthlyReview,
  }) => JournalEntry(
    id: id ?? this.id,
    entryDate: entryDate ?? this.entryDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    title: title.present ? title.value : this.title,
    bodyMarkdown: bodyMarkdown ?? this.bodyMarkdown,
    section: section ?? this.section,
    isMonthlyReview: isMonthlyReview ?? this.isMonthlyReview,
  );
  JournalEntry copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntry(
      id: data.id.present ? data.id.value : this.id,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      title: data.title.present ? data.title.value : this.title,
      bodyMarkdown: data.bodyMarkdown.present
          ? data.bodyMarkdown.value
          : this.bodyMarkdown,
      section: data.section.present ? data.section.value : this.section,
      isMonthlyReview: data.isMonthlyReview.present
          ? data.isMonthlyReview.value
          : this.isMonthlyReview,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('entryDate: $entryDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title, ')
          ..write('bodyMarkdown: $bodyMarkdown, ')
          ..write('section: $section, ')
          ..write('isMonthlyReview: $isMonthlyReview')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entryDate,
    createdAt,
    updatedAt,
    title,
    bodyMarkdown,
    section,
    isMonthlyReview,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.entryDate == this.entryDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.title == this.title &&
          other.bodyMarkdown == this.bodyMarkdown &&
          other.section == this.section &&
          other.isMonthlyReview == this.isMonthlyReview);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<String> id;
  final Value<DateTime> entryDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> title;
  final Value<String> bodyMarkdown;
  final Value<JournalSection> section;
  final Value<bool> isMonthlyReview;
  final Value<int> rowid;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.entryDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.bodyMarkdown = const Value.absent(),
    this.section = const Value.absent(),
    this.isMonthlyReview = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    required String id,
    required DateTime entryDate,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.title = const Value.absent(),
    required String bodyMarkdown,
    this.section = const Value.absent(),
    this.isMonthlyReview = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entryDate = Value(entryDate),
       bodyMarkdown = Value(bodyMarkdown);
  static Insertable<JournalEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? entryDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? title,
    Expression<String>? bodyMarkdown,
    Expression<int>? section,
    Expression<bool>? isMonthlyReview,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryDate != null) 'entry_date': entryDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (title != null) 'title': title,
      if (bodyMarkdown != null) 'body_markdown': bodyMarkdown,
      if (section != null) 'section': section,
      if (isMonthlyReview != null) 'is_monthly_review': isMonthlyReview,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? entryDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? title,
    Value<String>? bodyMarkdown,
    Value<JournalSection>? section,
    Value<bool>? isMonthlyReview,
    Value<int>? rowid,
  }) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      entryDate: entryDate ?? this.entryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      bodyMarkdown: bodyMarkdown ?? this.bodyMarkdown,
      section: section ?? this.section,
      isMonthlyReview: isMonthlyReview ?? this.isMonthlyReview,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<DateTime>(entryDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (bodyMarkdown.present) {
      map['body_markdown'] = Variable<String>(bodyMarkdown.value);
    }
    if (section.present) {
      map['section'] = Variable<int>(
        $JournalEntriesTable.$convertersection.toSql(section.value),
      );
    }
    if (isMonthlyReview.present) {
      map['is_monthly_review'] = Variable<bool>(isMonthlyReview.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('entryDate: $entryDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title, ')
          ..write('bodyMarkdown: $bodyMarkdown, ')
          ..write('section: $section, ')
          ..write('isMonthlyReview: $isMonthlyReview, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalEntryEmotionsTable extends JournalEntryEmotions
    with TableInfo<$JournalEntryEmotionsTable, JournalEntryEmotion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntryEmotionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _journalEntryIdMeta = const VerificationMeta(
    'journalEntryId',
  );
  @override
  late final GeneratedColumn<String> journalEntryId = GeneratedColumn<String>(
    'journal_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journal_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _emotionKeyMeta = const VerificationMeta(
    'emotionKey',
  );
  @override
  late final GeneratedColumn<String> emotionKey = GeneratedColumn<String>(
    'emotion_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<int> intensity = GeneratedColumn<int>(
    'intensity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [journalEntryId, emotionKey, intensity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entry_emotions';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntryEmotion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('journal_entry_id')) {
      context.handle(
        _journalEntryIdMeta,
        journalEntryId.isAcceptableOrUnknown(
          data['journal_entry_id']!,
          _journalEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_journalEntryIdMeta);
    }
    if (data.containsKey('emotion_key')) {
      context.handle(
        _emotionKeyMeta,
        emotionKey.isAcceptableOrUnknown(data['emotion_key']!, _emotionKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_emotionKeyMeta);
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    } else if (isInserting) {
      context.missing(_intensityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {journalEntryId, emotionKey};
  @override
  JournalEntryEmotion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntryEmotion(
      journalEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}journal_entry_id'],
      )!,
      emotionKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emotion_key'],
      )!,
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity'],
      )!,
    );
  }

  @override
  $JournalEntryEmotionsTable createAlias(String alias) {
    return $JournalEntryEmotionsTable(attachedDatabase, alias);
  }
}

class JournalEntryEmotion extends DataClass
    implements Insertable<JournalEntryEmotion> {
  final String journalEntryId;
  final String emotionKey;

  /// 1..5. Validated in the domain layer.
  final int intensity;
  const JournalEntryEmotion({
    required this.journalEntryId,
    required this.emotionKey,
    required this.intensity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['journal_entry_id'] = Variable<String>(journalEntryId);
    map['emotion_key'] = Variable<String>(emotionKey);
    map['intensity'] = Variable<int>(intensity);
    return map;
  }

  JournalEntryEmotionsCompanion toCompanion(bool nullToAbsent) {
    return JournalEntryEmotionsCompanion(
      journalEntryId: Value(journalEntryId),
      emotionKey: Value(emotionKey),
      intensity: Value(intensity),
    );
  }

  factory JournalEntryEmotion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntryEmotion(
      journalEntryId: serializer.fromJson<String>(json['journalEntryId']),
      emotionKey: serializer.fromJson<String>(json['emotionKey']),
      intensity: serializer.fromJson<int>(json['intensity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'journalEntryId': serializer.toJson<String>(journalEntryId),
      'emotionKey': serializer.toJson<String>(emotionKey),
      'intensity': serializer.toJson<int>(intensity),
    };
  }

  JournalEntryEmotion copyWith({
    String? journalEntryId,
    String? emotionKey,
    int? intensity,
  }) => JournalEntryEmotion(
    journalEntryId: journalEntryId ?? this.journalEntryId,
    emotionKey: emotionKey ?? this.emotionKey,
    intensity: intensity ?? this.intensity,
  );
  JournalEntryEmotion copyWithCompanion(JournalEntryEmotionsCompanion data) {
    return JournalEntryEmotion(
      journalEntryId: data.journalEntryId.present
          ? data.journalEntryId.value
          : this.journalEntryId,
      emotionKey: data.emotionKey.present
          ? data.emotionKey.value
          : this.emotionKey,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryEmotion(')
          ..write('journalEntryId: $journalEntryId, ')
          ..write('emotionKey: $emotionKey, ')
          ..write('intensity: $intensity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(journalEntryId, emotionKey, intensity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntryEmotion &&
          other.journalEntryId == this.journalEntryId &&
          other.emotionKey == this.emotionKey &&
          other.intensity == this.intensity);
}

class JournalEntryEmotionsCompanion
    extends UpdateCompanion<JournalEntryEmotion> {
  final Value<String> journalEntryId;
  final Value<String> emotionKey;
  final Value<int> intensity;
  final Value<int> rowid;
  const JournalEntryEmotionsCompanion({
    this.journalEntryId = const Value.absent(),
    this.emotionKey = const Value.absent(),
    this.intensity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalEntryEmotionsCompanion.insert({
    required String journalEntryId,
    required String emotionKey,
    required int intensity,
    this.rowid = const Value.absent(),
  }) : journalEntryId = Value(journalEntryId),
       emotionKey = Value(emotionKey),
       intensity = Value(intensity);
  static Insertable<JournalEntryEmotion> custom({
    Expression<String>? journalEntryId,
    Expression<String>? emotionKey,
    Expression<int>? intensity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (journalEntryId != null) 'journal_entry_id': journalEntryId,
      if (emotionKey != null) 'emotion_key': emotionKey,
      if (intensity != null) 'intensity': intensity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalEntryEmotionsCompanion copyWith({
    Value<String>? journalEntryId,
    Value<String>? emotionKey,
    Value<int>? intensity,
    Value<int>? rowid,
  }) {
    return JournalEntryEmotionsCompanion(
      journalEntryId: journalEntryId ?? this.journalEntryId,
      emotionKey: emotionKey ?? this.emotionKey,
      intensity: intensity ?? this.intensity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (journalEntryId.present) {
      map['journal_entry_id'] = Variable<String>(journalEntryId.value);
    }
    if (emotionKey.present) {
      map['emotion_key'] = Variable<String>(emotionKey.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(intensity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryEmotionsCompanion(')
          ..write('journalEntryId: $journalEntryId, ')
          ..write('emotionKey: $emotionKey, ')
          ..write('intensity: $intensity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMarkdownMeta =
      const VerificationMeta('descriptionMarkdown');
  @override
  late final GeneratedColumn<String> descriptionMarkdown =
      GeneratedColumn<String>(
        'description_markdown',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TaskStatus>($TasksTable.$converterstatus);
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _closingNoteMeta = const VerificationMeta(
    'closingNote',
  );
  @override
  late final GeneratedColumn<String> closingNote = GeneratedColumn<String>(
    'closing_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    title,
    descriptionMarkdown,
    dueDate,
    status,
    completedAt,
    closingNote,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description_markdown')) {
      context.handle(
        _descriptionMarkdownMeta,
        descriptionMarkdown.isAcceptableOrUnknown(
          data['description_markdown']!,
          _descriptionMarkdownMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('closing_note')) {
      context.handle(
        _closingNoteMeta,
        closingNote.isAcceptableOrUnknown(
          data['closing_note']!,
          _closingNoteMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      descriptionMarkdown: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_markdown'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      status: $TasksTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      closingNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}closing_note'],
      ),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskStatus, int, int> $converterstatus =
      const EnumIndexConverter<TaskStatus>(TaskStatus.values);
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final DateTime createdAt;
  final String title;
  final String? descriptionMarkdown;
  final DateTime? dueDate;
  final TaskStatus status;
  final DateTime? completedAt;

  /// How the task went — filled in when the user closes it.
  final String? closingNote;
  const Task({
    required this.id,
    required this.createdAt,
    required this.title,
    this.descriptionMarkdown,
    this.dueDate,
    required this.status,
    this.completedAt,
    this.closingNote,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || descriptionMarkdown != null) {
      map['description_markdown'] = Variable<String>(descriptionMarkdown);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    {
      map['status'] = Variable<int>($TasksTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || closingNote != null) {
      map['closing_note'] = Variable<String>(closingNote);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      title: Value(title),
      descriptionMarkdown: descriptionMarkdown == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionMarkdown),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      status: Value(status),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      closingNote: closingNote == null && nullToAbsent
          ? const Value.absent()
          : Value(closingNote),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      title: serializer.fromJson<String>(json['title']),
      descriptionMarkdown: serializer.fromJson<String?>(
        json['descriptionMarkdown'],
      ),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      status: $TasksTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      closingNote: serializer.fromJson<String?>(json['closingNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'title': serializer.toJson<String>(title),
      'descriptionMarkdown': serializer.toJson<String?>(descriptionMarkdown),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'status': serializer.toJson<int>(
        $TasksTable.$converterstatus.toJson(status),
      ),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'closingNote': serializer.toJson<String?>(closingNote),
    };
  }

  Task copyWith({
    String? id,
    DateTime? createdAt,
    String? title,
    Value<String?> descriptionMarkdown = const Value.absent(),
    Value<DateTime?> dueDate = const Value.absent(),
    TaskStatus? status,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<String?> closingNote = const Value.absent(),
  }) => Task(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    title: title ?? this.title,
    descriptionMarkdown: descriptionMarkdown.present
        ? descriptionMarkdown.value
        : this.descriptionMarkdown,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    status: status ?? this.status,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    closingNote: closingNote.present ? closingNote.value : this.closingNote,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      title: data.title.present ? data.title.value : this.title,
      descriptionMarkdown: data.descriptionMarkdown.present
          ? data.descriptionMarkdown.value
          : this.descriptionMarkdown,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      status: data.status.present ? data.status.value : this.status,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      closingNote: data.closingNote.present
          ? data.closingNote.value
          : this.closingNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('title: $title, ')
          ..write('descriptionMarkdown: $descriptionMarkdown, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('closingNote: $closingNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    title,
    descriptionMarkdown,
    dueDate,
    status,
    completedAt,
    closingNote,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.title == this.title &&
          other.descriptionMarkdown == this.descriptionMarkdown &&
          other.dueDate == this.dueDate &&
          other.status == this.status &&
          other.completedAt == this.completedAt &&
          other.closingNote == this.closingNote);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<String> title;
  final Value<String?> descriptionMarkdown;
  final Value<DateTime?> dueDate;
  final Value<TaskStatus> status;
  final Value<DateTime?> completedAt;
  final Value<String?> closingNote;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.title = const Value.absent(),
    this.descriptionMarkdown = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.closingNote = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    required String title,
    this.descriptionMarkdown = const Value.absent(),
    this.dueDate = const Value.absent(),
    required TaskStatus status,
    this.completedAt = const Value.absent(),
    this.closingNote = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       status = Value(status);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? title,
    Expression<String>? descriptionMarkdown,
    Expression<DateTime>? dueDate,
    Expression<int>? status,
    Expression<DateTime>? completedAt,
    Expression<String>? closingNote,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (title != null) 'title': title,
      if (descriptionMarkdown != null)
        'description_markdown': descriptionMarkdown,
      if (dueDate != null) 'due_date': dueDate,
      if (status != null) 'status': status,
      if (completedAt != null) 'completed_at': completedAt,
      if (closingNote != null) 'closing_note': closingNote,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<String>? title,
    Value<String?>? descriptionMarkdown,
    Value<DateTime?>? dueDate,
    Value<TaskStatus>? status,
    Value<DateTime?>? completedAt,
    Value<String?>? closingNote,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      descriptionMarkdown: descriptionMarkdown ?? this.descriptionMarkdown,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      closingNote: closingNote ?? this.closingNote,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (descriptionMarkdown.present) {
      map['description_markdown'] = Variable<String>(descriptionMarkdown.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $TasksTable.$converterstatus.toSql(status.value),
      );
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (closingNote.present) {
      map['closing_note'] = Variable<String>(closingNote.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('title: $title, ')
          ..write('descriptionMarkdown: $descriptionMarkdown, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('closingNote: $closingNote, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final String id;
  final String name;
  const Tag({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(id: Value(id), name: Value(name));
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Tag copyWith({String? id, String? name}) =>
      Tag(id: id ?? this.id, name: name ?? this.name);
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag && other.id == this.id && other.name == this.name);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Tag> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoodEntryTagsTable extends MoodEntryTags
    with TableInfo<$MoodEntryTagsTable, MoodEntryTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodEntryTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _moodEntryIdMeta = const VerificationMeta(
    'moodEntryId',
  );
  @override
  late final GeneratedColumn<String> moodEntryId = GeneratedColumn<String>(
    'mood_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mood_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [moodEntryId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_entry_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodEntryTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('mood_entry_id')) {
      context.handle(
        _moodEntryIdMeta,
        moodEntryId.isAcceptableOrUnknown(
          data['mood_entry_id']!,
          _moodEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_moodEntryIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {moodEntryId, tagId};
  @override
  MoodEntryTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodEntryTag(
      moodEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood_entry_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $MoodEntryTagsTable createAlias(String alias) {
    return $MoodEntryTagsTable(attachedDatabase, alias);
  }
}

class MoodEntryTag extends DataClass implements Insertable<MoodEntryTag> {
  final String moodEntryId;
  final String tagId;
  const MoodEntryTag({required this.moodEntryId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['mood_entry_id'] = Variable<String>(moodEntryId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  MoodEntryTagsCompanion toCompanion(bool nullToAbsent) {
    return MoodEntryTagsCompanion(
      moodEntryId: Value(moodEntryId),
      tagId: Value(tagId),
    );
  }

  factory MoodEntryTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodEntryTag(
      moodEntryId: serializer.fromJson<String>(json['moodEntryId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'moodEntryId': serializer.toJson<String>(moodEntryId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  MoodEntryTag copyWith({String? moodEntryId, String? tagId}) => MoodEntryTag(
    moodEntryId: moodEntryId ?? this.moodEntryId,
    tagId: tagId ?? this.tagId,
  );
  MoodEntryTag copyWithCompanion(MoodEntryTagsCompanion data) {
    return MoodEntryTag(
      moodEntryId: data.moodEntryId.present
          ? data.moodEntryId.value
          : this.moodEntryId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntryTag(')
          ..write('moodEntryId: $moodEntryId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(moodEntryId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodEntryTag &&
          other.moodEntryId == this.moodEntryId &&
          other.tagId == this.tagId);
}

class MoodEntryTagsCompanion extends UpdateCompanion<MoodEntryTag> {
  final Value<String> moodEntryId;
  final Value<String> tagId;
  final Value<int> rowid;
  const MoodEntryTagsCompanion({
    this.moodEntryId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoodEntryTagsCompanion.insert({
    required String moodEntryId,
    required String tagId,
    this.rowid = const Value.absent(),
  }) : moodEntryId = Value(moodEntryId),
       tagId = Value(tagId);
  static Insertable<MoodEntryTag> custom({
    Expression<String>? moodEntryId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (moodEntryId != null) 'mood_entry_id': moodEntryId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoodEntryTagsCompanion copyWith({
    Value<String>? moodEntryId,
    Value<String>? tagId,
    Value<int>? rowid,
  }) {
    return MoodEntryTagsCompanion(
      moodEntryId: moodEntryId ?? this.moodEntryId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (moodEntryId.present) {
      map['mood_entry_id'] = Variable<String>(moodEntryId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntryTagsCompanion(')
          ..write('moodEntryId: $moodEntryId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalEntryTagsTable extends JournalEntryTags
    with TableInfo<$JournalEntryTagsTable, JournalEntryTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntryTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _journalEntryIdMeta = const VerificationMeta(
    'journalEntryId',
  );
  @override
  late final GeneratedColumn<String> journalEntryId = GeneratedColumn<String>(
    'journal_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journal_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [journalEntryId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entry_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntryTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('journal_entry_id')) {
      context.handle(
        _journalEntryIdMeta,
        journalEntryId.isAcceptableOrUnknown(
          data['journal_entry_id']!,
          _journalEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_journalEntryIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {journalEntryId, tagId};
  @override
  JournalEntryTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntryTag(
      journalEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}journal_entry_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $JournalEntryTagsTable createAlias(String alias) {
    return $JournalEntryTagsTable(attachedDatabase, alias);
  }
}

class JournalEntryTag extends DataClass implements Insertable<JournalEntryTag> {
  final String journalEntryId;
  final String tagId;
  const JournalEntryTag({required this.journalEntryId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['journal_entry_id'] = Variable<String>(journalEntryId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  JournalEntryTagsCompanion toCompanion(bool nullToAbsent) {
    return JournalEntryTagsCompanion(
      journalEntryId: Value(journalEntryId),
      tagId: Value(tagId),
    );
  }

  factory JournalEntryTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntryTag(
      journalEntryId: serializer.fromJson<String>(json['journalEntryId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'journalEntryId': serializer.toJson<String>(journalEntryId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  JournalEntryTag copyWith({String? journalEntryId, String? tagId}) =>
      JournalEntryTag(
        journalEntryId: journalEntryId ?? this.journalEntryId,
        tagId: tagId ?? this.tagId,
      );
  JournalEntryTag copyWithCompanion(JournalEntryTagsCompanion data) {
    return JournalEntryTag(
      journalEntryId: data.journalEntryId.present
          ? data.journalEntryId.value
          : this.journalEntryId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryTag(')
          ..write('journalEntryId: $journalEntryId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(journalEntryId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntryTag &&
          other.journalEntryId == this.journalEntryId &&
          other.tagId == this.tagId);
}

class JournalEntryTagsCompanion extends UpdateCompanion<JournalEntryTag> {
  final Value<String> journalEntryId;
  final Value<String> tagId;
  final Value<int> rowid;
  const JournalEntryTagsCompanion({
    this.journalEntryId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalEntryTagsCompanion.insert({
    required String journalEntryId,
    required String tagId,
    this.rowid = const Value.absent(),
  }) : journalEntryId = Value(journalEntryId),
       tagId = Value(tagId);
  static Insertable<JournalEntryTag> custom({
    Expression<String>? journalEntryId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (journalEntryId != null) 'journal_entry_id': journalEntryId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalEntryTagsCompanion copyWith({
    Value<String>? journalEntryId,
    Value<String>? tagId,
    Value<int>? rowid,
  }) {
    return JournalEntryTagsCompanion(
      journalEntryId: journalEntryId ?? this.journalEntryId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (journalEntryId.present) {
      map['journal_entry_id'] = Variable<String>(journalEntryId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryTagsCompanion(')
          ..write('journalEntryId: $journalEntryId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledForMeta = const VerificationMeta(
    'scheduledFor',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledFor = GeneratedColumn<DateTime>(
    'scheduled_for',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _agendaMarkdownMeta = const VerificationMeta(
    'agendaMarkdown',
  );
  @override
  late final GeneratedColumn<String> agendaMarkdown = GeneratedColumn<String>(
    'agenda_markdown',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMarkdownMeta = const VerificationMeta(
    'notesMarkdown',
  );
  @override
  late final GeneratedColumn<String> notesMarkdown = GeneratedColumn<String>(
    'notes_markdown',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _takeawaysMarkdownMeta = const VerificationMeta(
    'takeawaysMarkdown',
  );
  @override
  late final GeneratedColumn<String> takeawaysMarkdown =
      GeneratedColumn<String>(
        'takeaways_markdown',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scheduledFor,
    createdAt,
    agendaMarkdown,
    notesMarkdown,
    takeawaysMarkdown,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('scheduled_for')) {
      context.handle(
        _scheduledForMeta,
        scheduledFor.isAcceptableOrUnknown(
          data['scheduled_for']!,
          _scheduledForMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledForMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('agenda_markdown')) {
      context.handle(
        _agendaMarkdownMeta,
        agendaMarkdown.isAcceptableOrUnknown(
          data['agenda_markdown']!,
          _agendaMarkdownMeta,
        ),
      );
    }
    if (data.containsKey('notes_markdown')) {
      context.handle(
        _notesMarkdownMeta,
        notesMarkdown.isAcceptableOrUnknown(
          data['notes_markdown']!,
          _notesMarkdownMeta,
        ),
      );
    }
    if (data.containsKey('takeaways_markdown')) {
      context.handle(
        _takeawaysMarkdownMeta,
        takeawaysMarkdown.isAcceptableOrUnknown(
          data['takeaways_markdown']!,
          _takeawaysMarkdownMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      scheduledFor: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_for'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      agendaMarkdown: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}agenda_markdown'],
      ),
      notesMarkdown: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes_markdown'],
      ),
      takeawaysMarkdown: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}takeaways_markdown'],
      ),
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final String id;

  /// When the session takes (or took) place.
  final DateTime scheduledFor;
  final DateTime createdAt;
  final String? agendaMarkdown;
  final String? notesMarkdown;
  final String? takeawaysMarkdown;
  const Session({
    required this.id,
    required this.scheduledFor,
    required this.createdAt,
    this.agendaMarkdown,
    this.notesMarkdown,
    this.takeawaysMarkdown,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['scheduled_for'] = Variable<DateTime>(scheduledFor);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || agendaMarkdown != null) {
      map['agenda_markdown'] = Variable<String>(agendaMarkdown);
    }
    if (!nullToAbsent || notesMarkdown != null) {
      map['notes_markdown'] = Variable<String>(notesMarkdown);
    }
    if (!nullToAbsent || takeawaysMarkdown != null) {
      map['takeaways_markdown'] = Variable<String>(takeawaysMarkdown);
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      scheduledFor: Value(scheduledFor),
      createdAt: Value(createdAt),
      agendaMarkdown: agendaMarkdown == null && nullToAbsent
          ? const Value.absent()
          : Value(agendaMarkdown),
      notesMarkdown: notesMarkdown == null && nullToAbsent
          ? const Value.absent()
          : Value(notesMarkdown),
      takeawaysMarkdown: takeawaysMarkdown == null && nullToAbsent
          ? const Value.absent()
          : Value(takeawaysMarkdown),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<String>(json['id']),
      scheduledFor: serializer.fromJson<DateTime>(json['scheduledFor']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      agendaMarkdown: serializer.fromJson<String?>(json['agendaMarkdown']),
      notesMarkdown: serializer.fromJson<String?>(json['notesMarkdown']),
      takeawaysMarkdown: serializer.fromJson<String?>(
        json['takeawaysMarkdown'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'scheduledFor': serializer.toJson<DateTime>(scheduledFor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'agendaMarkdown': serializer.toJson<String?>(agendaMarkdown),
      'notesMarkdown': serializer.toJson<String?>(notesMarkdown),
      'takeawaysMarkdown': serializer.toJson<String?>(takeawaysMarkdown),
    };
  }

  Session copyWith({
    String? id,
    DateTime? scheduledFor,
    DateTime? createdAt,
    Value<String?> agendaMarkdown = const Value.absent(),
    Value<String?> notesMarkdown = const Value.absent(),
    Value<String?> takeawaysMarkdown = const Value.absent(),
  }) => Session(
    id: id ?? this.id,
    scheduledFor: scheduledFor ?? this.scheduledFor,
    createdAt: createdAt ?? this.createdAt,
    agendaMarkdown: agendaMarkdown.present
        ? agendaMarkdown.value
        : this.agendaMarkdown,
    notesMarkdown: notesMarkdown.present
        ? notesMarkdown.value
        : this.notesMarkdown,
    takeawaysMarkdown: takeawaysMarkdown.present
        ? takeawaysMarkdown.value
        : this.takeawaysMarkdown,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      scheduledFor: data.scheduledFor.present
          ? data.scheduledFor.value
          : this.scheduledFor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      agendaMarkdown: data.agendaMarkdown.present
          ? data.agendaMarkdown.value
          : this.agendaMarkdown,
      notesMarkdown: data.notesMarkdown.present
          ? data.notesMarkdown.value
          : this.notesMarkdown,
      takeawaysMarkdown: data.takeawaysMarkdown.present
          ? data.takeawaysMarkdown.value
          : this.takeawaysMarkdown,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('createdAt: $createdAt, ')
          ..write('agendaMarkdown: $agendaMarkdown, ')
          ..write('notesMarkdown: $notesMarkdown, ')
          ..write('takeawaysMarkdown: $takeawaysMarkdown')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    scheduledFor,
    createdAt,
    agendaMarkdown,
    notesMarkdown,
    takeawaysMarkdown,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.scheduledFor == this.scheduledFor &&
          other.createdAt == this.createdAt &&
          other.agendaMarkdown == this.agendaMarkdown &&
          other.notesMarkdown == this.notesMarkdown &&
          other.takeawaysMarkdown == this.takeawaysMarkdown);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<String> id;
  final Value<DateTime> scheduledFor;
  final Value<DateTime> createdAt;
  final Value<String?> agendaMarkdown;
  final Value<String?> notesMarkdown;
  final Value<String?> takeawaysMarkdown;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.scheduledFor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.agendaMarkdown = const Value.absent(),
    this.notesMarkdown = const Value.absent(),
    this.takeawaysMarkdown = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required DateTime scheduledFor,
    this.createdAt = const Value.absent(),
    this.agendaMarkdown = const Value.absent(),
    this.notesMarkdown = const Value.absent(),
    this.takeawaysMarkdown = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       scheduledFor = Value(scheduledFor);
  static Insertable<Session> custom({
    Expression<String>? id,
    Expression<DateTime>? scheduledFor,
    Expression<DateTime>? createdAt,
    Expression<String>? agendaMarkdown,
    Expression<String>? notesMarkdown,
    Expression<String>? takeawaysMarkdown,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scheduledFor != null) 'scheduled_for': scheduledFor,
      if (createdAt != null) 'created_at': createdAt,
      if (agendaMarkdown != null) 'agenda_markdown': agendaMarkdown,
      if (notesMarkdown != null) 'notes_markdown': notesMarkdown,
      if (takeawaysMarkdown != null) 'takeaways_markdown': takeawaysMarkdown,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? scheduledFor,
    Value<DateTime>? createdAt,
    Value<String?>? agendaMarkdown,
    Value<String?>? notesMarkdown,
    Value<String?>? takeawaysMarkdown,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      createdAt: createdAt ?? this.createdAt,
      agendaMarkdown: agendaMarkdown ?? this.agendaMarkdown,
      notesMarkdown: notesMarkdown ?? this.notesMarkdown,
      takeawaysMarkdown: takeawaysMarkdown ?? this.takeawaysMarkdown,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (scheduledFor.present) {
      map['scheduled_for'] = Variable<DateTime>(scheduledFor.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (agendaMarkdown.present) {
      map['agenda_markdown'] = Variable<String>(agendaMarkdown.value);
    }
    if (notesMarkdown.present) {
      map['notes_markdown'] = Variable<String>(notesMarkdown.value);
    }
    if (takeawaysMarkdown.present) {
      map['takeaways_markdown'] = Variable<String>(takeawaysMarkdown.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('createdAt: $createdAt, ')
          ..write('agendaMarkdown: $agendaMarkdown, ')
          ..write('notesMarkdown: $notesMarkdown, ')
          ..write('takeawaysMarkdown: $takeawaysMarkdown, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionLinksTable extends SessionLinks
    with TableInfo<$SessionLinksTable, SessionLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LinkTargetType, int> targetType =
      GeneratedColumn<int>(
        'target_type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LinkTargetType>($SessionLinksTable.$convertertargetType);
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
    'target_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [sessionId, targetType, targetId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId, targetType, targetId};
  @override
  SessionLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionLink(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      targetType: $SessionLinksTable.$convertertargetType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}target_type'],
        )!,
      ),
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_id'],
      )!,
    );
  }

  @override
  $SessionLinksTable createAlias(String alias) {
    return $SessionLinksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LinkTargetType, int, int> $convertertargetType =
      const EnumIndexConverter<LinkTargetType>(LinkTargetType.values);
}

class SessionLink extends DataClass implements Insertable<SessionLink> {
  final String sessionId;
  final LinkTargetType targetType;
  final String targetId;
  const SessionLink({
    required this.sessionId,
    required this.targetType,
    required this.targetId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    {
      map['target_type'] = Variable<int>(
        $SessionLinksTable.$convertertargetType.toSql(targetType),
      );
    }
    map['target_id'] = Variable<String>(targetId);
    return map;
  }

  SessionLinksCompanion toCompanion(bool nullToAbsent) {
    return SessionLinksCompanion(
      sessionId: Value(sessionId),
      targetType: Value(targetType),
      targetId: Value(targetId),
    );
  }

  factory SessionLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionLink(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      targetType: $SessionLinksTable.$convertertargetType.fromJson(
        serializer.fromJson<int>(json['targetType']),
      ),
      targetId: serializer.fromJson<String>(json['targetId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'targetType': serializer.toJson<int>(
        $SessionLinksTable.$convertertargetType.toJson(targetType),
      ),
      'targetId': serializer.toJson<String>(targetId),
    };
  }

  SessionLink copyWith({
    String? sessionId,
    LinkTargetType? targetType,
    String? targetId,
  }) => SessionLink(
    sessionId: sessionId ?? this.sessionId,
    targetType: targetType ?? this.targetType,
    targetId: targetId ?? this.targetId,
  );
  SessionLink copyWithCompanion(SessionLinksCompanion data) {
    return SessionLink(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      targetType: data.targetType.present
          ? data.targetType.value
          : this.targetType,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionLink(')
          ..write('sessionId: $sessionId, ')
          ..write('targetType: $targetType, ')
          ..write('targetId: $targetId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sessionId, targetType, targetId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionLink &&
          other.sessionId == this.sessionId &&
          other.targetType == this.targetType &&
          other.targetId == this.targetId);
}

class SessionLinksCompanion extends UpdateCompanion<SessionLink> {
  final Value<String> sessionId;
  final Value<LinkTargetType> targetType;
  final Value<String> targetId;
  final Value<int> rowid;
  const SessionLinksCompanion({
    this.sessionId = const Value.absent(),
    this.targetType = const Value.absent(),
    this.targetId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionLinksCompanion.insert({
    required String sessionId,
    required LinkTargetType targetType,
    required String targetId,
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       targetType = Value(targetType),
       targetId = Value(targetId);
  static Insertable<SessionLink> custom({
    Expression<String>? sessionId,
    Expression<int>? targetType,
    Expression<String>? targetId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (targetType != null) 'target_type': targetType,
      if (targetId != null) 'target_id': targetId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionLinksCompanion copyWith({
    Value<String>? sessionId,
    Value<LinkTargetType>? targetType,
    Value<String>? targetId,
    Value<int>? rowid,
  }) {
    return SessionLinksCompanion(
      sessionId: sessionId ?? this.sessionId,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<int>(
        $SessionLinksTable.$convertertargetType.toSql(targetType.value),
      );
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionLinksCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('targetType: $targetType, ')
          ..write('targetId: $targetId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ThoughtRecordsTable extends ThoughtRecords
    with TableInfo<$ThoughtRecordsTable, ThoughtRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThoughtRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _situationMeta = const VerificationMeta(
    'situation',
  );
  @override
  late final GeneratedColumn<String> situation = GeneratedColumn<String>(
    'situation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _automaticThoughtMeta = const VerificationMeta(
    'automaticThought',
  );
  @override
  late final GeneratedColumn<String> automaticThought = GeneratedColumn<String>(
    'automatic_thought',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _beliefBeforeMeta = const VerificationMeta(
    'beliefBefore',
  );
  @override
  late final GeneratedColumn<int> beliefBefore = GeneratedColumn<int>(
    'belief_before',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emotionLabelMeta = const VerificationMeta(
    'emotionLabel',
  );
  @override
  late final GeneratedColumn<String> emotionLabel = GeneratedColumn<String>(
    'emotion_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emotionIntensityBeforeMeta =
      const VerificationMeta('emotionIntensityBefore');
  @override
  late final GeneratedColumn<int> emotionIntensityBefore = GeneratedColumn<int>(
    'emotion_intensity_before',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _alternativeThoughtMeta =
      const VerificationMeta('alternativeThought');
  @override
  late final GeneratedColumn<String> alternativeThought =
      GeneratedColumn<String>(
        'alternative_thought',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _beliefAfterMeta = const VerificationMeta(
    'beliefAfter',
  );
  @override
  late final GeneratedColumn<int> beliefAfter = GeneratedColumn<int>(
    'belief_after',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emotionIntensityAfterMeta =
      const VerificationMeta('emotionIntensityAfter');
  @override
  late final GeneratedColumn<int> emotionIntensityAfter = GeneratedColumn<int>(
    'emotion_intensity_after',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    occurredAt,
    createdAt,
    situation,
    automaticThought,
    beliefBefore,
    emotionLabel,
    emotionIntensityBefore,
    alternativeThought,
    beliefAfter,
    emotionIntensityAfter,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'thought_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ThoughtRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('situation')) {
      context.handle(
        _situationMeta,
        situation.isAcceptableOrUnknown(data['situation']!, _situationMeta),
      );
    } else if (isInserting) {
      context.missing(_situationMeta);
    }
    if (data.containsKey('automatic_thought')) {
      context.handle(
        _automaticThoughtMeta,
        automaticThought.isAcceptableOrUnknown(
          data['automatic_thought']!,
          _automaticThoughtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_automaticThoughtMeta);
    }
    if (data.containsKey('belief_before')) {
      context.handle(
        _beliefBeforeMeta,
        beliefBefore.isAcceptableOrUnknown(
          data['belief_before']!,
          _beliefBeforeMeta,
        ),
      );
    }
    if (data.containsKey('emotion_label')) {
      context.handle(
        _emotionLabelMeta,
        emotionLabel.isAcceptableOrUnknown(
          data['emotion_label']!,
          _emotionLabelMeta,
        ),
      );
    }
    if (data.containsKey('emotion_intensity_before')) {
      context.handle(
        _emotionIntensityBeforeMeta,
        emotionIntensityBefore.isAcceptableOrUnknown(
          data['emotion_intensity_before']!,
          _emotionIntensityBeforeMeta,
        ),
      );
    }
    if (data.containsKey('alternative_thought')) {
      context.handle(
        _alternativeThoughtMeta,
        alternativeThought.isAcceptableOrUnknown(
          data['alternative_thought']!,
          _alternativeThoughtMeta,
        ),
      );
    }
    if (data.containsKey('belief_after')) {
      context.handle(
        _beliefAfterMeta,
        beliefAfter.isAcceptableOrUnknown(
          data['belief_after']!,
          _beliefAfterMeta,
        ),
      );
    }
    if (data.containsKey('emotion_intensity_after')) {
      context.handle(
        _emotionIntensityAfterMeta,
        emotionIntensityAfter.isAcceptableOrUnknown(
          data['emotion_intensity_after']!,
          _emotionIntensityAfterMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ThoughtRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ThoughtRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      situation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}situation'],
      )!,
      automaticThought: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}automatic_thought'],
      )!,
      beliefBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}belief_before'],
      ),
      emotionLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emotion_label'],
      ),
      emotionIntensityBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}emotion_intensity_before'],
      ),
      alternativeThought: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alternative_thought'],
      ),
      beliefAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}belief_after'],
      ),
      emotionIntensityAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}emotion_intensity_after'],
      ),
    );
  }

  @override
  $ThoughtRecordsTable createAlias(String alias) {
    return $ThoughtRecordsTable(attachedDatabase, alias);
  }
}

class ThoughtRecord extends DataClass implements Insertable<ThoughtRecord> {
  final String id;

  /// When the situation happened. May be backdated.
  final DateTime occurredAt;
  final DateTime createdAt;
  final String situation;
  final String automaticThought;

  /// 0..100 — how much the automatic thought was believed at the time.
  final int? beliefBefore;
  final String? emotionLabel;

  /// 0..10.
  final int? emotionIntensityBefore;
  final String? alternativeThought;

  /// 0..100 — belief in the automatic thought after the reframe.
  final int? beliefAfter;

  /// 0..10.
  final int? emotionIntensityAfter;
  const ThoughtRecord({
    required this.id,
    required this.occurredAt,
    required this.createdAt,
    required this.situation,
    required this.automaticThought,
    this.beliefBefore,
    this.emotionLabel,
    this.emotionIntensityBefore,
    this.alternativeThought,
    this.beliefAfter,
    this.emotionIntensityAfter,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['situation'] = Variable<String>(situation);
    map['automatic_thought'] = Variable<String>(automaticThought);
    if (!nullToAbsent || beliefBefore != null) {
      map['belief_before'] = Variable<int>(beliefBefore);
    }
    if (!nullToAbsent || emotionLabel != null) {
      map['emotion_label'] = Variable<String>(emotionLabel);
    }
    if (!nullToAbsent || emotionIntensityBefore != null) {
      map['emotion_intensity_before'] = Variable<int>(emotionIntensityBefore);
    }
    if (!nullToAbsent || alternativeThought != null) {
      map['alternative_thought'] = Variable<String>(alternativeThought);
    }
    if (!nullToAbsent || beliefAfter != null) {
      map['belief_after'] = Variable<int>(beliefAfter);
    }
    if (!nullToAbsent || emotionIntensityAfter != null) {
      map['emotion_intensity_after'] = Variable<int>(emotionIntensityAfter);
    }
    return map;
  }

  ThoughtRecordsCompanion toCompanion(bool nullToAbsent) {
    return ThoughtRecordsCompanion(
      id: Value(id),
      occurredAt: Value(occurredAt),
      createdAt: Value(createdAt),
      situation: Value(situation),
      automaticThought: Value(automaticThought),
      beliefBefore: beliefBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(beliefBefore),
      emotionLabel: emotionLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(emotionLabel),
      emotionIntensityBefore: emotionIntensityBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(emotionIntensityBefore),
      alternativeThought: alternativeThought == null && nullToAbsent
          ? const Value.absent()
          : Value(alternativeThought),
      beliefAfter: beliefAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(beliefAfter),
      emotionIntensityAfter: emotionIntensityAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(emotionIntensityAfter),
    );
  }

  factory ThoughtRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ThoughtRecord(
      id: serializer.fromJson<String>(json['id']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      situation: serializer.fromJson<String>(json['situation']),
      automaticThought: serializer.fromJson<String>(json['automaticThought']),
      beliefBefore: serializer.fromJson<int?>(json['beliefBefore']),
      emotionLabel: serializer.fromJson<String?>(json['emotionLabel']),
      emotionIntensityBefore: serializer.fromJson<int?>(
        json['emotionIntensityBefore'],
      ),
      alternativeThought: serializer.fromJson<String?>(
        json['alternativeThought'],
      ),
      beliefAfter: serializer.fromJson<int?>(json['beliefAfter']),
      emotionIntensityAfter: serializer.fromJson<int?>(
        json['emotionIntensityAfter'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'situation': serializer.toJson<String>(situation),
      'automaticThought': serializer.toJson<String>(automaticThought),
      'beliefBefore': serializer.toJson<int?>(beliefBefore),
      'emotionLabel': serializer.toJson<String?>(emotionLabel),
      'emotionIntensityBefore': serializer.toJson<int?>(emotionIntensityBefore),
      'alternativeThought': serializer.toJson<String?>(alternativeThought),
      'beliefAfter': serializer.toJson<int?>(beliefAfter),
      'emotionIntensityAfter': serializer.toJson<int?>(emotionIntensityAfter),
    };
  }

  ThoughtRecord copyWith({
    String? id,
    DateTime? occurredAt,
    DateTime? createdAt,
    String? situation,
    String? automaticThought,
    Value<int?> beliefBefore = const Value.absent(),
    Value<String?> emotionLabel = const Value.absent(),
    Value<int?> emotionIntensityBefore = const Value.absent(),
    Value<String?> alternativeThought = const Value.absent(),
    Value<int?> beliefAfter = const Value.absent(),
    Value<int?> emotionIntensityAfter = const Value.absent(),
  }) => ThoughtRecord(
    id: id ?? this.id,
    occurredAt: occurredAt ?? this.occurredAt,
    createdAt: createdAt ?? this.createdAt,
    situation: situation ?? this.situation,
    automaticThought: automaticThought ?? this.automaticThought,
    beliefBefore: beliefBefore.present ? beliefBefore.value : this.beliefBefore,
    emotionLabel: emotionLabel.present ? emotionLabel.value : this.emotionLabel,
    emotionIntensityBefore: emotionIntensityBefore.present
        ? emotionIntensityBefore.value
        : this.emotionIntensityBefore,
    alternativeThought: alternativeThought.present
        ? alternativeThought.value
        : this.alternativeThought,
    beliefAfter: beliefAfter.present ? beliefAfter.value : this.beliefAfter,
    emotionIntensityAfter: emotionIntensityAfter.present
        ? emotionIntensityAfter.value
        : this.emotionIntensityAfter,
  );
  ThoughtRecord copyWithCompanion(ThoughtRecordsCompanion data) {
    return ThoughtRecord(
      id: data.id.present ? data.id.value : this.id,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      situation: data.situation.present ? data.situation.value : this.situation,
      automaticThought: data.automaticThought.present
          ? data.automaticThought.value
          : this.automaticThought,
      beliefBefore: data.beliefBefore.present
          ? data.beliefBefore.value
          : this.beliefBefore,
      emotionLabel: data.emotionLabel.present
          ? data.emotionLabel.value
          : this.emotionLabel,
      emotionIntensityBefore: data.emotionIntensityBefore.present
          ? data.emotionIntensityBefore.value
          : this.emotionIntensityBefore,
      alternativeThought: data.alternativeThought.present
          ? data.alternativeThought.value
          : this.alternativeThought,
      beliefAfter: data.beliefAfter.present
          ? data.beliefAfter.value
          : this.beliefAfter,
      emotionIntensityAfter: data.emotionIntensityAfter.present
          ? data.emotionIntensityAfter.value
          : this.emotionIntensityAfter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ThoughtRecord(')
          ..write('id: $id, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('situation: $situation, ')
          ..write('automaticThought: $automaticThought, ')
          ..write('beliefBefore: $beliefBefore, ')
          ..write('emotionLabel: $emotionLabel, ')
          ..write('emotionIntensityBefore: $emotionIntensityBefore, ')
          ..write('alternativeThought: $alternativeThought, ')
          ..write('beliefAfter: $beliefAfter, ')
          ..write('emotionIntensityAfter: $emotionIntensityAfter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    occurredAt,
    createdAt,
    situation,
    automaticThought,
    beliefBefore,
    emotionLabel,
    emotionIntensityBefore,
    alternativeThought,
    beliefAfter,
    emotionIntensityAfter,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThoughtRecord &&
          other.id == this.id &&
          other.occurredAt == this.occurredAt &&
          other.createdAt == this.createdAt &&
          other.situation == this.situation &&
          other.automaticThought == this.automaticThought &&
          other.beliefBefore == this.beliefBefore &&
          other.emotionLabel == this.emotionLabel &&
          other.emotionIntensityBefore == this.emotionIntensityBefore &&
          other.alternativeThought == this.alternativeThought &&
          other.beliefAfter == this.beliefAfter &&
          other.emotionIntensityAfter == this.emotionIntensityAfter);
}

class ThoughtRecordsCompanion extends UpdateCompanion<ThoughtRecord> {
  final Value<String> id;
  final Value<DateTime> occurredAt;
  final Value<DateTime> createdAt;
  final Value<String> situation;
  final Value<String> automaticThought;
  final Value<int?> beliefBefore;
  final Value<String?> emotionLabel;
  final Value<int?> emotionIntensityBefore;
  final Value<String?> alternativeThought;
  final Value<int?> beliefAfter;
  final Value<int?> emotionIntensityAfter;
  final Value<int> rowid;
  const ThoughtRecordsCompanion({
    this.id = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.situation = const Value.absent(),
    this.automaticThought = const Value.absent(),
    this.beliefBefore = const Value.absent(),
    this.emotionLabel = const Value.absent(),
    this.emotionIntensityBefore = const Value.absent(),
    this.alternativeThought = const Value.absent(),
    this.beliefAfter = const Value.absent(),
    this.emotionIntensityAfter = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ThoughtRecordsCompanion.insert({
    required String id,
    required DateTime occurredAt,
    this.createdAt = const Value.absent(),
    required String situation,
    required String automaticThought,
    this.beliefBefore = const Value.absent(),
    this.emotionLabel = const Value.absent(),
    this.emotionIntensityBefore = const Value.absent(),
    this.alternativeThought = const Value.absent(),
    this.beliefAfter = const Value.absent(),
    this.emotionIntensityAfter = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       occurredAt = Value(occurredAt),
       situation = Value(situation),
       automaticThought = Value(automaticThought);
  static Insertable<ThoughtRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? createdAt,
    Expression<String>? situation,
    Expression<String>? automaticThought,
    Expression<int>? beliefBefore,
    Expression<String>? emotionLabel,
    Expression<int>? emotionIntensityBefore,
    Expression<String>? alternativeThought,
    Expression<int>? beliefAfter,
    Expression<int>? emotionIntensityAfter,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (createdAt != null) 'created_at': createdAt,
      if (situation != null) 'situation': situation,
      if (automaticThought != null) 'automatic_thought': automaticThought,
      if (beliefBefore != null) 'belief_before': beliefBefore,
      if (emotionLabel != null) 'emotion_label': emotionLabel,
      if (emotionIntensityBefore != null)
        'emotion_intensity_before': emotionIntensityBefore,
      if (alternativeThought != null) 'alternative_thought': alternativeThought,
      if (beliefAfter != null) 'belief_after': beliefAfter,
      if (emotionIntensityAfter != null)
        'emotion_intensity_after': emotionIntensityAfter,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ThoughtRecordsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? occurredAt,
    Value<DateTime>? createdAt,
    Value<String>? situation,
    Value<String>? automaticThought,
    Value<int?>? beliefBefore,
    Value<String?>? emotionLabel,
    Value<int?>? emotionIntensityBefore,
    Value<String?>? alternativeThought,
    Value<int?>? beliefAfter,
    Value<int?>? emotionIntensityAfter,
    Value<int>? rowid,
  }) {
    return ThoughtRecordsCompanion(
      id: id ?? this.id,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
      situation: situation ?? this.situation,
      automaticThought: automaticThought ?? this.automaticThought,
      beliefBefore: beliefBefore ?? this.beliefBefore,
      emotionLabel: emotionLabel ?? this.emotionLabel,
      emotionIntensityBefore:
          emotionIntensityBefore ?? this.emotionIntensityBefore,
      alternativeThought: alternativeThought ?? this.alternativeThought,
      beliefAfter: beliefAfter ?? this.beliefAfter,
      emotionIntensityAfter:
          emotionIntensityAfter ?? this.emotionIntensityAfter,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (situation.present) {
      map['situation'] = Variable<String>(situation.value);
    }
    if (automaticThought.present) {
      map['automatic_thought'] = Variable<String>(automaticThought.value);
    }
    if (beliefBefore.present) {
      map['belief_before'] = Variable<int>(beliefBefore.value);
    }
    if (emotionLabel.present) {
      map['emotion_label'] = Variable<String>(emotionLabel.value);
    }
    if (emotionIntensityBefore.present) {
      map['emotion_intensity_before'] = Variable<int>(
        emotionIntensityBefore.value,
      );
    }
    if (alternativeThought.present) {
      map['alternative_thought'] = Variable<String>(alternativeThought.value);
    }
    if (beliefAfter.present) {
      map['belief_after'] = Variable<int>(beliefAfter.value);
    }
    if (emotionIntensityAfter.present) {
      map['emotion_intensity_after'] = Variable<int>(
        emotionIntensityAfter.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThoughtRecordsCompanion(')
          ..write('id: $id, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('situation: $situation, ')
          ..write('automaticThought: $automaticThought, ')
          ..write('beliefBefore: $beliefBefore, ')
          ..write('emotionLabel: $emotionLabel, ')
          ..write('emotionIntensityBefore: $emotionIntensityBefore, ')
          ..write('alternativeThought: $alternativeThought, ')
          ..write('beliefAfter: $beliefAfter, ')
          ..write('emotionIntensityAfter: $emotionIntensityAfter, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ThoughtRecordDistortionsTable extends ThoughtRecordDistortions
    with TableInfo<$ThoughtRecordDistortionsTable, ThoughtRecordDistortion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThoughtRecordDistortionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES thought_records (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CognitiveDistortion, int>
  distortion =
      GeneratedColumn<int>(
        'distortion',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<CognitiveDistortion>(
        $ThoughtRecordDistortionsTable.$converterdistortion,
      );
  @override
  List<GeneratedColumn> get $columns => [recordId, distortion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'thought_record_distortions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ThoughtRecordDistortion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recordId, distortion};
  @override
  ThoughtRecordDistortion map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ThoughtRecordDistortion(
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      distortion: $ThoughtRecordDistortionsTable.$converterdistortion.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}distortion'],
        )!,
      ),
    );
  }

  @override
  $ThoughtRecordDistortionsTable createAlias(String alias) {
    return $ThoughtRecordDistortionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CognitiveDistortion, int, int>
  $converterdistortion = const EnumIndexConverter<CognitiveDistortion>(
    CognitiveDistortion.values,
  );
}

class ThoughtRecordDistortion extends DataClass
    implements Insertable<ThoughtRecordDistortion> {
  final String recordId;
  final CognitiveDistortion distortion;
  const ThoughtRecordDistortion({
    required this.recordId,
    required this.distortion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['record_id'] = Variable<String>(recordId);
    {
      map['distortion'] = Variable<int>(
        $ThoughtRecordDistortionsTable.$converterdistortion.toSql(distortion),
      );
    }
    return map;
  }

  ThoughtRecordDistortionsCompanion toCompanion(bool nullToAbsent) {
    return ThoughtRecordDistortionsCompanion(
      recordId: Value(recordId),
      distortion: Value(distortion),
    );
  }

  factory ThoughtRecordDistortion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ThoughtRecordDistortion(
      recordId: serializer.fromJson<String>(json['recordId']),
      distortion: $ThoughtRecordDistortionsTable.$converterdistortion.fromJson(
        serializer.fromJson<int>(json['distortion']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recordId': serializer.toJson<String>(recordId),
      'distortion': serializer.toJson<int>(
        $ThoughtRecordDistortionsTable.$converterdistortion.toJson(distortion),
      ),
    };
  }

  ThoughtRecordDistortion copyWith({
    String? recordId,
    CognitiveDistortion? distortion,
  }) => ThoughtRecordDistortion(
    recordId: recordId ?? this.recordId,
    distortion: distortion ?? this.distortion,
  );
  ThoughtRecordDistortion copyWithCompanion(
    ThoughtRecordDistortionsCompanion data,
  ) {
    return ThoughtRecordDistortion(
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      distortion: data.distortion.present
          ? data.distortion.value
          : this.distortion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ThoughtRecordDistortion(')
          ..write('recordId: $recordId, ')
          ..write('distortion: $distortion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(recordId, distortion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThoughtRecordDistortion &&
          other.recordId == this.recordId &&
          other.distortion == this.distortion);
}

class ThoughtRecordDistortionsCompanion
    extends UpdateCompanion<ThoughtRecordDistortion> {
  final Value<String> recordId;
  final Value<CognitiveDistortion> distortion;
  final Value<int> rowid;
  const ThoughtRecordDistortionsCompanion({
    this.recordId = const Value.absent(),
    this.distortion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ThoughtRecordDistortionsCompanion.insert({
    required String recordId,
    required CognitiveDistortion distortion,
    this.rowid = const Value.absent(),
  }) : recordId = Value(recordId),
       distortion = Value(distortion);
  static Insertable<ThoughtRecordDistortion> custom({
    Expression<String>? recordId,
    Expression<int>? distortion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recordId != null) 'record_id': recordId,
      if (distortion != null) 'distortion': distortion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ThoughtRecordDistortionsCompanion copyWith({
    Value<String>? recordId,
    Value<CognitiveDistortion>? distortion,
    Value<int>? rowid,
  }) {
    return ThoughtRecordDistortionsCompanion(
      recordId: recordId ?? this.recordId,
      distortion: distortion ?? this.distortion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (distortion.present) {
      map['distortion'] = Variable<int>(
        $ThoughtRecordDistortionsTable.$converterdistortion.toSql(
          distortion.value,
        ),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThoughtRecordDistortionsCompanion(')
          ..write('recordId: $recordId, ')
          ..write('distortion: $distortion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, Medication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<String> dose = GeneratedColumn<String>(
    'dose',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduleNoteMeta = const VerificationMeta(
    'scheduleNote',
  );
  @override
  late final GeneratedColumn<String> scheduleNote = GeneratedColumn<String>(
    'schedule_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    dose,
    scheduleNote,
    active,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Medication> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dose')) {
      context.handle(
        _doseMeta,
        dose.isAcceptableOrUnknown(data['dose']!, _doseMeta),
      );
    }
    if (data.containsKey('schedule_note')) {
      context.handle(
        _scheduleNoteMeta,
        scheduleNote.isAcceptableOrUnknown(
          data['schedule_note']!,
          _scheduleNoteMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medication(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dose'],
      ),
      scheduleNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_note'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class Medication extends DataClass implements Insertable<Medication> {
  final String id;
  final String name;
  final String? dose;

  /// Free-text schedule reminder, e.g. "morning + night".
  final String? scheduleNote;
  final bool active;
  final DateTime createdAt;
  const Medication({
    required this.id,
    required this.name,
    this.dose,
    this.scheduleNote,
    required this.active,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || dose != null) {
      map['dose'] = Variable<String>(dose);
    }
    if (!nullToAbsent || scheduleNote != null) {
      map['schedule_note'] = Variable<String>(scheduleNote);
    }
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      name: Value(name),
      dose: dose == null && nullToAbsent ? const Value.absent() : Value(dose),
      scheduleNote: scheduleNote == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleNote),
      active: Value(active),
      createdAt: Value(createdAt),
    );
  }

  factory Medication.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medication(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dose: serializer.fromJson<String?>(json['dose']),
      scheduleNote: serializer.fromJson<String?>(json['scheduleNote']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'dose': serializer.toJson<String?>(dose),
      'scheduleNote': serializer.toJson<String?>(scheduleNote),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Medication copyWith({
    String? id,
    String? name,
    Value<String?> dose = const Value.absent(),
    Value<String?> scheduleNote = const Value.absent(),
    bool? active,
    DateTime? createdAt,
  }) => Medication(
    id: id ?? this.id,
    name: name ?? this.name,
    dose: dose.present ? dose.value : this.dose,
    scheduleNote: scheduleNote.present ? scheduleNote.value : this.scheduleNote,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
  );
  Medication copyWithCompanion(MedicationsCompanion data) {
    return Medication(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dose: data.dose.present ? data.dose.value : this.dose,
      scheduleNote: data.scheduleNote.present
          ? data.scheduleNote.value
          : this.scheduleNote,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medication(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dose: $dose, ')
          ..write('scheduleNote: $scheduleNote, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, dose, scheduleNote, active, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medication &&
          other.id == this.id &&
          other.name == this.name &&
          other.dose == this.dose &&
          other.scheduleNote == this.scheduleNote &&
          other.active == this.active &&
          other.createdAt == this.createdAt);
}

class MedicationsCompanion extends UpdateCompanion<Medication> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> dose;
  final Value<String?> scheduleNote;
  final Value<bool> active;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dose = const Value.absent(),
    this.scheduleNote = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationsCompanion.insert({
    required String id,
    required String name,
    this.dose = const Value.absent(),
    this.scheduleNote = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Medication> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? dose,
    Expression<String>? scheduleNote,
    Expression<bool>? active,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dose != null) 'dose': dose,
      if (scheduleNote != null) 'schedule_note': scheduleNote,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? dose,
    Value<String?>? scheduleNote,
    Value<bool>? active,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MedicationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      scheduleNote: scheduleNote ?? this.scheduleNote,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dose.present) {
      map['dose'] = Variable<String>(dose.value);
    }
    if (scheduleNote.present) {
      map['schedule_note'] = Variable<String>(scheduleNote.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dose: $dose, ')
          ..write('scheduleNote: $scheduleNote, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationLogsTable extends MedicationLogs
    with TableInfo<$MedicationLogsTable, MedicationLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, medicationId, takenAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medication_id'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
    );
  }

  @override
  $MedicationLogsTable createAlias(String alias) {
    return $MedicationLogsTable(attachedDatabase, alias);
  }
}

class MedicationLog extends DataClass implements Insertable<MedicationLog> {
  final String id;
  final String medicationId;
  final DateTime takenAt;
  const MedicationLog({
    required this.id,
    required this.medicationId,
    required this.takenAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['taken_at'] = Variable<DateTime>(takenAt);
    return map;
  }

  MedicationLogsCompanion toCompanion(bool nullToAbsent) {
    return MedicationLogsCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      takenAt: Value(takenAt),
    );
  }

  factory MedicationLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationLog(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'takenAt': serializer.toJson<DateTime>(takenAt),
    };
  }

  MedicationLog copyWith({
    String? id,
    String? medicationId,
    DateTime? takenAt,
  }) => MedicationLog(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    takenAt: takenAt ?? this.takenAt,
  );
  MedicationLog copyWithCompanion(MedicationLogsCompanion data) {
    return MedicationLog(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationLog(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('takenAt: $takenAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, medicationId, takenAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationLog &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.takenAt == this.takenAt);
}

class MedicationLogsCompanion extends UpdateCompanion<MedicationLog> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<DateTime> takenAt;
  final Value<int> rowid;
  const MedicationLogsCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationLogsCompanion.insert({
    required String id,
    required String medicationId,
    required DateTime takenAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicationId = Value(medicationId),
       takenAt = Value(takenAt);
  static Insertable<MedicationLog> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<DateTime>? takenAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (takenAt != null) 'taken_at': takenAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationId,
    Value<DateTime>? takenAt,
    Value<int>? rowid,
  }) {
    return MedicationLogsCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      takenAt: takenAt ?? this.takenAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationLogsCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('takenAt: $takenAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MoodEntriesTable moodEntries = $MoodEntriesTable(this);
  late final $MoodEntryEmotionsTable moodEntryEmotions =
      $MoodEntryEmotionsTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $JournalEntryEmotionsTable journalEntryEmotions =
      $JournalEntryEmotionsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $MoodEntryTagsTable moodEntryTags = $MoodEntryTagsTable(this);
  late final $JournalEntryTagsTable journalEntryTags = $JournalEntryTagsTable(
    this,
  );
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $SessionLinksTable sessionLinks = $SessionLinksTable(this);
  late final $ThoughtRecordsTable thoughtRecords = $ThoughtRecordsTable(this);
  late final $ThoughtRecordDistortionsTable thoughtRecordDistortions =
      $ThoughtRecordDistortionsTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $MedicationLogsTable medicationLogs = $MedicationLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    moodEntries,
    moodEntryEmotions,
    journalEntries,
    journalEntryEmotions,
    tasks,
    tags,
    moodEntryTags,
    journalEntryTags,
    appSettings,
    sessions,
    sessionLinks,
    thoughtRecords,
    thoughtRecordDistortions,
    medications,
    medicationLogs,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'mood_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('mood_entry_emotions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'journal_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('journal_entry_emotions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'mood_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('mood_entry_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('mood_entry_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'journal_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('journal_entry_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('journal_entry_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('session_links', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'thought_records',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('thought_record_distortions', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('medication_logs', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$MoodEntriesTableCreateCompanionBuilder =
    MoodEntriesCompanion Function({
      required String id,
      required DateTime occurredAt,
      required int mood,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$MoodEntriesTableUpdateCompanionBuilder =
    MoodEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> occurredAt,
      Value<int> mood,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$MoodEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $MoodEntriesTable, MoodEntry> {
  $$MoodEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MoodEntryEmotionsTable, List<MoodEntryEmotion>>
  _moodEntryEmotionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.moodEntryEmotions,
        aliasName: 'mood_entries__id__mood_entry_emotions__mood_entry_id',
      );

  $$MoodEntryEmotionsTableProcessedTableManager get moodEntryEmotionsRefs {
    final manager = $$MoodEntryEmotionsTableTableManager(
      $_db,
      $_db.moodEntryEmotions,
    ).filter((f) => f.moodEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _moodEntryEmotionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MoodEntryTagsTable, List<MoodEntryTag>>
  _moodEntryTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.moodEntryTags,
    aliasName: 'mood_entries__id__mood_entry_tags__mood_entry_id',
  );

  $$MoodEntryTagsTableProcessedTableManager get moodEntryTagsRefs {
    final manager = $$MoodEntryTagsTableTableManager(
      $_db,
      $_db.moodEntryTags,
    ).filter((f) => f.moodEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_moodEntryTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MoodEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> moodEntryEmotionsRefs(
    Expression<bool> Function($$MoodEntryEmotionsTableFilterComposer f) f,
  ) {
    final $$MoodEntryEmotionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moodEntryEmotions,
      getReferencedColumn: (t) => t.moodEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntryEmotionsTableFilterComposer(
            $db: $db,
            $table: $db.moodEntryEmotions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> moodEntryTagsRefs(
    Expression<bool> Function($$MoodEntryTagsTableFilterComposer f) f,
  ) {
    final $$MoodEntryTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moodEntryTags,
      getReferencedColumn: (t) => t.moodEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntryTagsTableFilterComposer(
            $db: $db,
            $table: $db.moodEntryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MoodEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoodEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> moodEntryEmotionsRefs<T extends Object>(
    Expression<T> Function($$MoodEntryEmotionsTableAnnotationComposer a) f,
  ) {
    final $$MoodEntryEmotionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.moodEntryEmotions,
          getReferencedColumn: (t) => t.moodEntryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MoodEntryEmotionsTableAnnotationComposer(
                $db: $db,
                $table: $db.moodEntryEmotions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> moodEntryTagsRefs<T extends Object>(
    Expression<T> Function($$MoodEntryTagsTableAnnotationComposer a) f,
  ) {
    final $$MoodEntryTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moodEntryTags,
      getReferencedColumn: (t) => t.moodEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntryTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.moodEntryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MoodEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodEntriesTable,
          MoodEntry,
          $$MoodEntriesTableFilterComposer,
          $$MoodEntriesTableOrderingComposer,
          $$MoodEntriesTableAnnotationComposer,
          $$MoodEntriesTableCreateCompanionBuilder,
          $$MoodEntriesTableUpdateCompanionBuilder,
          (MoodEntry, $$MoodEntriesTableReferences),
          MoodEntry,
          PrefetchHooks Function({
            bool moodEntryEmotionsRefs,
            bool moodEntryTagsRefs,
          })
        > {
  $$MoodEntriesTableTableManager(_$AppDatabase db, $MoodEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<int> mood = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoodEntriesCompanion(
                id: id,
                occurredAt: occurredAt,
                mood: mood,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime occurredAt,
                required int mood,
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoodEntriesCompanion.insert(
                id: id,
                occurredAt: occurredAt,
                mood: mood,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MoodEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({moodEntryEmotionsRefs = false, moodEntryTagsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (moodEntryEmotionsRefs) db.moodEntryEmotions,
                    if (moodEntryTagsRefs) db.moodEntryTags,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (moodEntryEmotionsRefs)
                        await $_getPrefetchedData<
                          MoodEntry,
                          $MoodEntriesTable,
                          MoodEntryEmotion
                        >(
                          currentTable: table,
                          referencedTable: $$MoodEntriesTableReferences
                              ._moodEntryEmotionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MoodEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).moodEntryEmotionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.moodEntryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (moodEntryTagsRefs)
                        await $_getPrefetchedData<
                          MoodEntry,
                          $MoodEntriesTable,
                          MoodEntryTag
                        >(
                          currentTable: table,
                          referencedTable: $$MoodEntriesTableReferences
                              ._moodEntryTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MoodEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).moodEntryTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.moodEntryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MoodEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodEntriesTable,
      MoodEntry,
      $$MoodEntriesTableFilterComposer,
      $$MoodEntriesTableOrderingComposer,
      $$MoodEntriesTableAnnotationComposer,
      $$MoodEntriesTableCreateCompanionBuilder,
      $$MoodEntriesTableUpdateCompanionBuilder,
      (MoodEntry, $$MoodEntriesTableReferences),
      MoodEntry,
      PrefetchHooks Function({
        bool moodEntryEmotionsRefs,
        bool moodEntryTagsRefs,
      })
    >;
typedef $$MoodEntryEmotionsTableCreateCompanionBuilder =
    MoodEntryEmotionsCompanion Function({
      required String moodEntryId,
      required String emotionKey,
      required int intensity,
      Value<int> rowid,
    });
typedef $$MoodEntryEmotionsTableUpdateCompanionBuilder =
    MoodEntryEmotionsCompanion Function({
      Value<String> moodEntryId,
      Value<String> emotionKey,
      Value<int> intensity,
      Value<int> rowid,
    });

final class $$MoodEntryEmotionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MoodEntryEmotionsTable,
          MoodEntryEmotion
        > {
  $$MoodEntryEmotionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MoodEntriesTable _moodEntryIdTable(_$AppDatabase db) => db.moodEntries
      .createAlias('mood_entry_emotions__mood_entry_id__mood_entries__id');

  $$MoodEntriesTableProcessedTableManager get moodEntryId {
    final $_column = $_itemColumn<String>('mood_entry_id')!;

    final manager = $$MoodEntriesTableTableManager(
      $_db,
      $_db.moodEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_moodEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MoodEntryEmotionsTableFilterComposer
    extends Composer<_$AppDatabase, $MoodEntryEmotionsTable> {
  $$MoodEntryEmotionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get emotionKey => $composableBuilder(
    column: $table.emotionKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  $$MoodEntriesTableFilterComposer get moodEntryId {
    final $$MoodEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.moodEntryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableFilterComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodEntryEmotionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodEntryEmotionsTable> {
  $$MoodEntryEmotionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get emotionKey => $composableBuilder(
    column: $table.emotionKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  $$MoodEntriesTableOrderingComposer get moodEntryId {
    final $$MoodEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.moodEntryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodEntryEmotionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodEntryEmotionsTable> {
  $$MoodEntryEmotionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get emotionKey => $composableBuilder(
    column: $table.emotionKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  $$MoodEntriesTableAnnotationComposer get moodEntryId {
    final $$MoodEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.moodEntryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodEntryEmotionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodEntryEmotionsTable,
          MoodEntryEmotion,
          $$MoodEntryEmotionsTableFilterComposer,
          $$MoodEntryEmotionsTableOrderingComposer,
          $$MoodEntryEmotionsTableAnnotationComposer,
          $$MoodEntryEmotionsTableCreateCompanionBuilder,
          $$MoodEntryEmotionsTableUpdateCompanionBuilder,
          (MoodEntryEmotion, $$MoodEntryEmotionsTableReferences),
          MoodEntryEmotion,
          PrefetchHooks Function({bool moodEntryId})
        > {
  $$MoodEntryEmotionsTableTableManager(
    _$AppDatabase db,
    $MoodEntryEmotionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodEntryEmotionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodEntryEmotionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodEntryEmotionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> moodEntryId = const Value.absent(),
                Value<String> emotionKey = const Value.absent(),
                Value<int> intensity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoodEntryEmotionsCompanion(
                moodEntryId: moodEntryId,
                emotionKey: emotionKey,
                intensity: intensity,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String moodEntryId,
                required String emotionKey,
                required int intensity,
                Value<int> rowid = const Value.absent(),
              }) => MoodEntryEmotionsCompanion.insert(
                moodEntryId: moodEntryId,
                emotionKey: emotionKey,
                intensity: intensity,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MoodEntryEmotionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({moodEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (moodEntryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.moodEntryId,
                        referencedTable: $$MoodEntryEmotionsTableReferences
                            ._moodEntryIdTable(db),
                        referencedColumn: $$MoodEntryEmotionsTableReferences
                            ._moodEntryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MoodEntryEmotionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodEntryEmotionsTable,
      MoodEntryEmotion,
      $$MoodEntryEmotionsTableFilterComposer,
      $$MoodEntryEmotionsTableOrderingComposer,
      $$MoodEntryEmotionsTableAnnotationComposer,
      $$MoodEntryEmotionsTableCreateCompanionBuilder,
      $$MoodEntryEmotionsTableUpdateCompanionBuilder,
      (MoodEntryEmotion, $$MoodEntryEmotionsTableReferences),
      MoodEntryEmotion,
      PrefetchHooks Function({bool moodEntryId})
    >;
typedef $$JournalEntriesTableCreateCompanionBuilder =
    JournalEntriesCompanion Function({
      required String id,
      required DateTime entryDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> title,
      required String bodyMarkdown,
      Value<JournalSection> section,
      Value<bool> isMonthlyReview,
      Value<int> rowid,
    });
typedef $$JournalEntriesTableUpdateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> entryDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> title,
      Value<String> bodyMarkdown,
      Value<JournalSection> section,
      Value<bool> isMonthlyReview,
      Value<int> rowid,
    });

final class $$JournalEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry> {
  $$JournalEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $JournalEntryEmotionsTable,
    List<JournalEntryEmotion>
  >
  _journalEntryEmotionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.journalEntryEmotions,
        aliasName:
            'journal_entries__id__journal_entry_emotions__journal_entry_id',
      );

  $$JournalEntryEmotionsTableProcessedTableManager
  get journalEntryEmotionsRefs {
    final manager = $$JournalEntryEmotionsTableTableManager(
      $_db,
      $_db.journalEntryEmotions,
    ).filter((f) => f.journalEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _journalEntryEmotionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$JournalEntryTagsTable, List<JournalEntryTag>>
  _journalEntryTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.journalEntryTags,
    aliasName: 'journal_entries__id__journal_entry_tags__journal_entry_id',
  );

  $$JournalEntryTagsTableProcessedTableManager get journalEntryTagsRefs {
    final manager = $$JournalEntryTagsTableTableManager(
      $_db,
      $_db.journalEntryTags,
    ).filter((f) => f.journalEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _journalEntryTagsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$JournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyMarkdown => $composableBuilder(
    column: $table.bodyMarkdown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<JournalSection, JournalSection, int>
  get section => $composableBuilder(
    column: $table.section,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isMonthlyReview => $composableBuilder(
    column: $table.isMonthlyReview,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> journalEntryEmotionsRefs(
    Expression<bool> Function($$JournalEntryEmotionsTableFilterComposer f) f,
  ) {
    final $$JournalEntryEmotionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntryEmotions,
      getReferencedColumn: (t) => t.journalEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntryEmotionsTableFilterComposer(
            $db: $db,
            $table: $db.journalEntryEmotions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> journalEntryTagsRefs(
    Expression<bool> Function($$JournalEntryTagsTableFilterComposer f) f,
  ) {
    final $$JournalEntryTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntryTags,
      getReferencedColumn: (t) => t.journalEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntryTagsTableFilterComposer(
            $db: $db,
            $table: $db.journalEntryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyMarkdown => $composableBuilder(
    column: $table.bodyMarkdown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get section => $composableBuilder(
    column: $table.section,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMonthlyReview => $composableBuilder(
    column: $table.isMonthlyReview,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get entryDate =>
      $composableBuilder(column: $table.entryDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get bodyMarkdown => $composableBuilder(
    column: $table.bodyMarkdown,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<JournalSection, int> get section =>
      $composableBuilder(column: $table.section, builder: (column) => column);

  GeneratedColumn<bool> get isMonthlyReview => $composableBuilder(
    column: $table.isMonthlyReview,
    builder: (column) => column,
  );

  Expression<T> journalEntryEmotionsRefs<T extends Object>(
    Expression<T> Function($$JournalEntryEmotionsTableAnnotationComposer a) f,
  ) {
    final $$JournalEntryEmotionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.journalEntryEmotions,
          getReferencedColumn: (t) => t.journalEntryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$JournalEntryEmotionsTableAnnotationComposer(
                $db: $db,
                $table: $db.journalEntryEmotions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> journalEntryTagsRefs<T extends Object>(
    Expression<T> Function($$JournalEntryTagsTableAnnotationComposer a) f,
  ) {
    final $$JournalEntryTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntryTags,
      getReferencedColumn: (t) => t.journalEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntryTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$JournalEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalEntriesTable,
          JournalEntry,
          $$JournalEntriesTableFilterComposer,
          $$JournalEntriesTableOrderingComposer,
          $$JournalEntriesTableAnnotationComposer,
          $$JournalEntriesTableCreateCompanionBuilder,
          $$JournalEntriesTableUpdateCompanionBuilder,
          (JournalEntry, $$JournalEntriesTableReferences),
          JournalEntry,
          PrefetchHooks Function({
            bool journalEntryEmotionsRefs,
            bool journalEntryTagsRefs,
          })
        > {
  $$JournalEntriesTableTableManager(
    _$AppDatabase db,
    $JournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> entryDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String> bodyMarkdown = const Value.absent(),
                Value<JournalSection> section = const Value.absent(),
                Value<bool> isMonthlyReview = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalEntriesCompanion(
                id: id,
                entryDate: entryDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                title: title,
                bodyMarkdown: bodyMarkdown,
                section: section,
                isMonthlyReview: isMonthlyReview,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime entryDate,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> title = const Value.absent(),
                required String bodyMarkdown,
                Value<JournalSection> section = const Value.absent(),
                Value<bool> isMonthlyReview = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalEntriesCompanion.insert(
                id: id,
                entryDate: entryDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                title: title,
                bodyMarkdown: bodyMarkdown,
                section: section,
                isMonthlyReview: isMonthlyReview,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JournalEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                journalEntryEmotionsRefs = false,
                journalEntryTagsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (journalEntryEmotionsRefs) db.journalEntryEmotions,
                    if (journalEntryTagsRefs) db.journalEntryTags,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (journalEntryEmotionsRefs)
                        await $_getPrefetchedData<
                          JournalEntry,
                          $JournalEntriesTable,
                          JournalEntryEmotion
                        >(
                          currentTable: table,
                          referencedTable: $$JournalEntriesTableReferences
                              ._journalEntryEmotionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JournalEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).journalEntryEmotionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.journalEntryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (journalEntryTagsRefs)
                        await $_getPrefetchedData<
                          JournalEntry,
                          $JournalEntriesTable,
                          JournalEntryTag
                        >(
                          currentTable: table,
                          referencedTable: $$JournalEntriesTableReferences
                              ._journalEntryTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JournalEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).journalEntryTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.journalEntryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$JournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalEntriesTable,
      JournalEntry,
      $$JournalEntriesTableFilterComposer,
      $$JournalEntriesTableOrderingComposer,
      $$JournalEntriesTableAnnotationComposer,
      $$JournalEntriesTableCreateCompanionBuilder,
      $$JournalEntriesTableUpdateCompanionBuilder,
      (JournalEntry, $$JournalEntriesTableReferences),
      JournalEntry,
      PrefetchHooks Function({
        bool journalEntryEmotionsRefs,
        bool journalEntryTagsRefs,
      })
    >;
typedef $$JournalEntryEmotionsTableCreateCompanionBuilder =
    JournalEntryEmotionsCompanion Function({
      required String journalEntryId,
      required String emotionKey,
      required int intensity,
      Value<int> rowid,
    });
typedef $$JournalEntryEmotionsTableUpdateCompanionBuilder =
    JournalEntryEmotionsCompanion Function({
      Value<String> journalEntryId,
      Value<String> emotionKey,
      Value<int> intensity,
      Value<int> rowid,
    });

final class $$JournalEntryEmotionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $JournalEntryEmotionsTable,
          JournalEntryEmotion
        > {
  $$JournalEntryEmotionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JournalEntriesTable _journalEntryIdTable(_$AppDatabase db) =>
      db.journalEntries.createAlias(
        'journal_entry_emotions__journal_entry_id__journal_entries__id',
      );

  $$JournalEntriesTableProcessedTableManager get journalEntryId {
    final $_column = $_itemColumn<String>('journal_entry_id')!;

    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_journalEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$JournalEntryEmotionsTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntryEmotionsTable> {
  $$JournalEntryEmotionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get emotionKey => $composableBuilder(
    column: $table.emotionKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  $$JournalEntriesTableFilterComposer get journalEntryId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journalEntryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntryEmotionsTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntryEmotionsTable> {
  $$JournalEntryEmotionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get emotionKey => $composableBuilder(
    column: $table.emotionKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  $$JournalEntriesTableOrderingComposer get journalEntryId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journalEntryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntryEmotionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntryEmotionsTable> {
  $$JournalEntryEmotionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get emotionKey => $composableBuilder(
    column: $table.emotionKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  $$JournalEntriesTableAnnotationComposer get journalEntryId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journalEntryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntryEmotionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalEntryEmotionsTable,
          JournalEntryEmotion,
          $$JournalEntryEmotionsTableFilterComposer,
          $$JournalEntryEmotionsTableOrderingComposer,
          $$JournalEntryEmotionsTableAnnotationComposer,
          $$JournalEntryEmotionsTableCreateCompanionBuilder,
          $$JournalEntryEmotionsTableUpdateCompanionBuilder,
          (JournalEntryEmotion, $$JournalEntryEmotionsTableReferences),
          JournalEntryEmotion,
          PrefetchHooks Function({bool journalEntryId})
        > {
  $$JournalEntryEmotionsTableTableManager(
    _$AppDatabase db,
    $JournalEntryEmotionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntryEmotionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntryEmotionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$JournalEntryEmotionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> journalEntryId = const Value.absent(),
                Value<String> emotionKey = const Value.absent(),
                Value<int> intensity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalEntryEmotionsCompanion(
                journalEntryId: journalEntryId,
                emotionKey: emotionKey,
                intensity: intensity,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String journalEntryId,
                required String emotionKey,
                required int intensity,
                Value<int> rowid = const Value.absent(),
              }) => JournalEntryEmotionsCompanion.insert(
                journalEntryId: journalEntryId,
                emotionKey: emotionKey,
                intensity: intensity,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JournalEntryEmotionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({journalEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (journalEntryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.journalEntryId,
                        referencedTable: $$JournalEntryEmotionsTableReferences
                            ._journalEntryIdTable(db),
                        referencedColumn: $$JournalEntryEmotionsTableReferences
                            ._journalEntryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$JournalEntryEmotionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalEntryEmotionsTable,
      JournalEntryEmotion,
      $$JournalEntryEmotionsTableFilterComposer,
      $$JournalEntryEmotionsTableOrderingComposer,
      $$JournalEntryEmotionsTableAnnotationComposer,
      $$JournalEntryEmotionsTableCreateCompanionBuilder,
      $$JournalEntryEmotionsTableUpdateCompanionBuilder,
      (JournalEntryEmotion, $$JournalEntryEmotionsTableReferences),
      JournalEntryEmotion,
      PrefetchHooks Function({bool journalEntryId})
    >;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  required String title,
  Value<String?> descriptionMarkdown,
  Value<DateTime?> dueDate,
  required TaskStatus status,
  Value<DateTime?> completedAt,
  Value<String?> closingNote,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<String> title,
  Value<String?> descriptionMarkdown,
  Value<DateTime?> dueDate,
  Value<TaskStatus> status,
  Value<DateTime?> completedAt,
  Value<String?> closingNote,
  Value<int> rowid,
});

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionMarkdown => $composableBuilder(
    column: $table.descriptionMarkdown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskStatus, TaskStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get closingNote => $composableBuilder(
    column: $table.closingNote,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionMarkdown => $composableBuilder(
    column: $table.descriptionMarkdown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get closingNote => $composableBuilder(
    column: $table.closingNote,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get descriptionMarkdown => $composableBuilder(
    column: $table.descriptionMarkdown,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get closingNote => $composableBuilder(
    column: $table.closingNote,
    builder: (column) => column,
  );
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
          Task,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> descriptionMarkdown = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<TaskStatus> status = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> closingNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                createdAt: createdAt,
                title: title,
                descriptionMarkdown: descriptionMarkdown,
                dueDate: dueDate,
                status: status,
                completedAt: completedAt,
                closingNote: closingNote,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                required String title,
                Value<String?> descriptionMarkdown = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                required TaskStatus status,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> closingNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                createdAt: createdAt,
                title: title,
                descriptionMarkdown: descriptionMarkdown,
                dueDate: dueDate,
                status: status,
                completedAt: completedAt,
                closingNote: closingNote,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
      Task,
      PrefetchHooks Function()
    >;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  required String id,
  required String name,
  Value<int> rowid,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> rowid,
});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MoodEntryTagsTable, List<MoodEntryTag>>
  _moodEntryTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.moodEntryTags,
    aliasName: 'tags__id__mood_entry_tags__tag_id',
  );

  $$MoodEntryTagsTableProcessedTableManager get moodEntryTagsRefs {
    final manager = $$MoodEntryTagsTableTableManager(
      $_db,
      $_db.moodEntryTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_moodEntryTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$JournalEntryTagsTable, List<JournalEntryTag>>
  _journalEntryTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.journalEntryTags,
    aliasName: 'tags__id__journal_entry_tags__tag_id',
  );

  $$JournalEntryTagsTableProcessedTableManager get journalEntryTagsRefs {
    final manager = $$JournalEntryTagsTableTableManager(
      $_db,
      $_db.journalEntryTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _journalEntryTagsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> moodEntryTagsRefs(
    Expression<bool> Function($$MoodEntryTagsTableFilterComposer f) f,
  ) {
    final $$MoodEntryTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moodEntryTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntryTagsTableFilterComposer(
            $db: $db,
            $table: $db.moodEntryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> journalEntryTagsRefs(
    Expression<bool> Function($$JournalEntryTagsTableFilterComposer f) f,
  ) {
    final $$JournalEntryTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntryTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntryTagsTableFilterComposer(
            $db: $db,
            $table: $db.journalEntryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> moodEntryTagsRefs<T extends Object>(
    Expression<T> Function($$MoodEntryTagsTableAnnotationComposer a) f,
  ) {
    final $$MoodEntryTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moodEntryTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntryTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.moodEntryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> journalEntryTagsRefs<T extends Object>(
    Expression<T> Function($$JournalEntryTagsTableAnnotationComposer a) f,
  ) {
    final $$JournalEntryTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntryTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntryTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({
            bool moodEntryTagsRefs,
            bool journalEntryTagsRefs,
          })
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => TagsCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int> rowid = const Value.absent(),
          }) => TagsCompanion.insert(id: id, name: name, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TagsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({moodEntryTagsRefs = false, journalEntryTagsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (moodEntryTagsRefs) db.moodEntryTags,
                    if (journalEntryTagsRefs) db.journalEntryTags,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (moodEntryTagsRefs)
                        await $_getPrefetchedData<
                          Tag,
                          $TagsTable,
                          MoodEntryTag
                        >(
                          currentTable: table,
                          referencedTable: $$TagsTableReferences
                              ._moodEntryTagsRefsTable(db),
                          managerFromTypedResult: (p0) => $$TagsTableReferences(
                            db,
                            table,
                            p0,
                          ).moodEntryTagsRefs,
                          referencedItemsForCurrentItem: (
                            item,
                            referencedItems,
                          ) => referencedItems.where((e) => e.tagId == item.id),
                          typedResults: items,
                        ),
                      if (journalEntryTagsRefs)
                        await $_getPrefetchedData<
                          Tag,
                          $TagsTable,
                          JournalEntryTag
                        >(
                          currentTable: table,
                          referencedTable: $$TagsTableReferences
                              ._journalEntryTagsRefsTable(db),
                          managerFromTypedResult: (p0) => $$TagsTableReferences(
                            db,
                            table,
                            p0,
                          ).journalEntryTagsRefs,
                          referencedItemsForCurrentItem: (
                            item,
                            referencedItems,
                          ) => referencedItems.where((e) => e.tagId == item.id),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({
        bool moodEntryTagsRefs,
        bool journalEntryTagsRefs,
      })
    >;
typedef $$MoodEntryTagsTableCreateCompanionBuilder =
    MoodEntryTagsCompanion Function({
      required String moodEntryId,
      required String tagId,
      Value<int> rowid,
    });
typedef $$MoodEntryTagsTableUpdateCompanionBuilder =
    MoodEntryTagsCompanion Function({
      Value<String> moodEntryId,
      Value<String> tagId,
      Value<int> rowid,
    });

final class $$MoodEntryTagsTableReferences
    extends BaseReferences<_$AppDatabase, $MoodEntryTagsTable, MoodEntryTag> {
  $$MoodEntryTagsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MoodEntriesTable _moodEntryIdTable(_$AppDatabase db) => db.moodEntries
      .createAlias('mood_entry_tags__mood_entry_id__mood_entries__id');

  $$MoodEntriesTableProcessedTableManager get moodEntryId {
    final $_column = $_itemColumn<String>('mood_entry_id')!;

    final manager = $$MoodEntriesTableTableManager(
      $_db,
      $_db.moodEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_moodEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('mood_entry_tags__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MoodEntryTagsTableFilterComposer
    extends Composer<_$AppDatabase, $MoodEntryTagsTable> {
  $$MoodEntryTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MoodEntriesTableFilterComposer get moodEntryId {
    final $$MoodEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.moodEntryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableFilterComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodEntryTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodEntryTagsTable> {
  $$MoodEntryTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MoodEntriesTableOrderingComposer get moodEntryId {
    final $$MoodEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.moodEntryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodEntryTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodEntryTagsTable> {
  $$MoodEntryTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MoodEntriesTableAnnotationComposer get moodEntryId {
    final $$MoodEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.moodEntryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodEntryTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodEntryTagsTable,
          MoodEntryTag,
          $$MoodEntryTagsTableFilterComposer,
          $$MoodEntryTagsTableOrderingComposer,
          $$MoodEntryTagsTableAnnotationComposer,
          $$MoodEntryTagsTableCreateCompanionBuilder,
          $$MoodEntryTagsTableUpdateCompanionBuilder,
          (MoodEntryTag, $$MoodEntryTagsTableReferences),
          MoodEntryTag,
          PrefetchHooks Function({bool moodEntryId, bool tagId})
        > {
  $$MoodEntryTagsTableTableManager(_$AppDatabase db, $MoodEntryTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodEntryTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodEntryTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodEntryTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> moodEntryId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoodEntryTagsCompanion(
                moodEntryId: moodEntryId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String moodEntryId,
                required String tagId,
                Value<int> rowid = const Value.absent(),
              }) => MoodEntryTagsCompanion.insert(
                moodEntryId: moodEntryId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MoodEntryTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({moodEntryId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (moodEntryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.moodEntryId,
                        referencedTable: $$MoodEntryTagsTableReferences
                            ._moodEntryIdTable(db),
                        referencedColumn: $$MoodEntryTagsTableReferences
                            ._moodEntryIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (tagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tagId,
                        referencedTable: $$MoodEntryTagsTableReferences
                            ._tagIdTable(db),
                        referencedColumn: $$MoodEntryTagsTableReferences
                            ._tagIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MoodEntryTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodEntryTagsTable,
      MoodEntryTag,
      $$MoodEntryTagsTableFilterComposer,
      $$MoodEntryTagsTableOrderingComposer,
      $$MoodEntryTagsTableAnnotationComposer,
      $$MoodEntryTagsTableCreateCompanionBuilder,
      $$MoodEntryTagsTableUpdateCompanionBuilder,
      (MoodEntryTag, $$MoodEntryTagsTableReferences),
      MoodEntryTag,
      PrefetchHooks Function({bool moodEntryId, bool tagId})
    >;
typedef $$JournalEntryTagsTableCreateCompanionBuilder =
    JournalEntryTagsCompanion Function({
      required String journalEntryId,
      required String tagId,
      Value<int> rowid,
    });
typedef $$JournalEntryTagsTableUpdateCompanionBuilder =
    JournalEntryTagsCompanion Function({
      Value<String> journalEntryId,
      Value<String> tagId,
      Value<int> rowid,
    });

final class $$JournalEntryTagsTableReferences
    extends
        BaseReferences<_$AppDatabase, $JournalEntryTagsTable, JournalEntryTag> {
  $$JournalEntryTagsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JournalEntriesTable _journalEntryIdTable(_$AppDatabase db) => db
      .journalEntries
      .createAlias('journal_entry_tags__journal_entry_id__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager get journalEntryId {
    final $_column = $_itemColumn<String>('journal_entry_id')!;

    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_journalEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('journal_entry_tags__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$JournalEntryTagsTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntryTagsTable> {
  $$JournalEntryTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$JournalEntriesTableFilterComposer get journalEntryId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journalEntryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntryTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntryTagsTable> {
  $$JournalEntryTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$JournalEntriesTableOrderingComposer get journalEntryId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journalEntryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntryTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntryTagsTable> {
  $$JournalEntryTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$JournalEntriesTableAnnotationComposer get journalEntryId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journalEntryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntryTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalEntryTagsTable,
          JournalEntryTag,
          $$JournalEntryTagsTableFilterComposer,
          $$JournalEntryTagsTableOrderingComposer,
          $$JournalEntryTagsTableAnnotationComposer,
          $$JournalEntryTagsTableCreateCompanionBuilder,
          $$JournalEntryTagsTableUpdateCompanionBuilder,
          (JournalEntryTag, $$JournalEntryTagsTableReferences),
          JournalEntryTag,
          PrefetchHooks Function({bool journalEntryId, bool tagId})
        > {
  $$JournalEntryTagsTableTableManager(
    _$AppDatabase db,
    $JournalEntryTagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntryTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntryTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntryTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> journalEntryId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalEntryTagsCompanion(
                journalEntryId: journalEntryId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String journalEntryId,
                required String tagId,
                Value<int> rowid = const Value.absent(),
              }) => JournalEntryTagsCompanion.insert(
                journalEntryId: journalEntryId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JournalEntryTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({journalEntryId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (journalEntryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.journalEntryId,
                        referencedTable: $$JournalEntryTagsTableReferences
                            ._journalEntryIdTable(db),
                        referencedColumn: $$JournalEntryTagsTableReferences
                            ._journalEntryIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (tagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tagId,
                        referencedTable: $$JournalEntryTagsTableReferences
                            ._tagIdTable(db),
                        referencedColumn: $$JournalEntryTagsTableReferences
                            ._tagIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$JournalEntryTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalEntryTagsTable,
      JournalEntryTag,
      $$JournalEntryTagsTableFilterComposer,
      $$JournalEntryTagsTableOrderingComposer,
      $$JournalEntryTagsTableAnnotationComposer,
      $$JournalEntryTagsTableCreateCompanionBuilder,
      $$JournalEntryTagsTableUpdateCompanionBuilder,
      (JournalEntryTag, $$JournalEntryTagsTableReferences),
      JournalEntryTag,
      PrefetchHooks Function({bool journalEntryId, bool tagId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  required String id,
  required DateTime scheduledFor,
  Value<DateTime> createdAt,
  Value<String?> agendaMarkdown,
  Value<String?> notesMarkdown,
  Value<String?> takeawaysMarkdown,
  Value<int> rowid,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<String> id,
  Value<DateTime> scheduledFor,
  Value<DateTime> createdAt,
  Value<String?> agendaMarkdown,
  Value<String?> notesMarkdown,
  Value<String?> takeawaysMarkdown,
  Value<int> rowid,
});

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionLinksTable, List<SessionLink>>
  _sessionLinksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionLinks,
    aliasName: 'sessions__id__session_links__session_id',
  );

  $$SessionLinksTableProcessedTableManager get sessionLinksRefs {
    final manager = $$SessionLinksTableTableManager(
      $_db,
      $_db.sessionLinks,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionLinksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get agendaMarkdown => $composableBuilder(
    column: $table.agendaMarkdown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notesMarkdown => $composableBuilder(
    column: $table.notesMarkdown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get takeawaysMarkdown => $composableBuilder(
    column: $table.takeawaysMarkdown,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sessionLinksRefs(
    Expression<bool> Function($$SessionLinksTableFilterComposer f) f,
  ) {
    final $$SessionLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionLinks,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionLinksTableFilterComposer(
            $db: $db,
            $table: $db.sessionLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get agendaMarkdown => $composableBuilder(
    column: $table.agendaMarkdown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notesMarkdown => $composableBuilder(
    column: $table.notesMarkdown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get takeawaysMarkdown => $composableBuilder(
    column: $table.takeawaysMarkdown,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get agendaMarkdown => $composableBuilder(
    column: $table.agendaMarkdown,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notesMarkdown => $composableBuilder(
    column: $table.notesMarkdown,
    builder: (column) => column,
  );

  GeneratedColumn<String> get takeawaysMarkdown => $composableBuilder(
    column: $table.takeawaysMarkdown,
    builder: (column) => column,
  );

  Expression<T> sessionLinksRefs<T extends Object>(
    Expression<T> Function($$SessionLinksTableAnnotationComposer a) f,
  ) {
    final $$SessionLinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionLinks,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionLinksTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({bool sessionLinksRefs})
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> scheduledFor = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> agendaMarkdown = const Value.absent(),
                Value<String?> notesMarkdown = const Value.absent(),
                Value<String?> takeawaysMarkdown = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                scheduledFor: scheduledFor,
                createdAt: createdAt,
                agendaMarkdown: agendaMarkdown,
                notesMarkdown: notesMarkdown,
                takeawaysMarkdown: takeawaysMarkdown,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime scheduledFor,
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> agendaMarkdown = const Value.absent(),
                Value<String?> notesMarkdown = const Value.absent(),
                Value<String?> takeawaysMarkdown = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                scheduledFor: scheduledFor,
                createdAt: createdAt,
                agendaMarkdown: agendaMarkdown,
                notesMarkdown: notesMarkdown,
                takeawaysMarkdown: takeawaysMarkdown,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionLinksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sessionLinksRefs) db.sessionLinks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionLinksRefs)
                    await $_getPrefetchedData<
                      Session,
                      $SessionsTable,
                      SessionLink
                    >(
                      currentTable: table,
                      referencedTable: $$SessionsTableReferences
                          ._sessionLinksRefsTable(db),
                      managerFromTypedResult: (p0) => $$SessionsTableReferences(
                        db,
                        table,
                        p0,
                      ).sessionLinksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({bool sessionLinksRefs})
    >;
typedef $$SessionLinksTableCreateCompanionBuilder =
    SessionLinksCompanion Function({
      required String sessionId,
      required LinkTargetType targetType,
      required String targetId,
      Value<int> rowid,
    });
typedef $$SessionLinksTableUpdateCompanionBuilder =
    SessionLinksCompanion Function({
      Value<String> sessionId,
      Value<LinkTargetType> targetType,
      Value<String> targetId,
      Value<int> rowid,
    });

final class $$SessionLinksTableReferences
    extends BaseReferences<_$AppDatabase, $SessionLinksTable, SessionLink> {
  $$SessionLinksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('session_links__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessionLinksTableFilterComposer
    extends Composer<_$AppDatabase, $SessionLinksTable> {
  $$SessionLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<LinkTargetType, LinkTargetType, int>
  get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionLinksTable> {
  $$SessionLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionLinksTable> {
  $$SessionLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<LinkTargetType, int> get targetType =>
      $composableBuilder(
        column: $table.targetType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionLinksTable,
          SessionLink,
          $$SessionLinksTableFilterComposer,
          $$SessionLinksTableOrderingComposer,
          $$SessionLinksTableAnnotationComposer,
          $$SessionLinksTableCreateCompanionBuilder,
          $$SessionLinksTableUpdateCompanionBuilder,
          (SessionLink, $$SessionLinksTableReferences),
          SessionLink,
          PrefetchHooks Function({bool sessionId})
        > {
  $$SessionLinksTableTableManager(_$AppDatabase db, $SessionLinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<LinkTargetType> targetType = const Value.absent(),
                Value<String> targetId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionLinksCompanion(
                sessionId: sessionId,
                targetType: targetType,
                targetId: targetId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required LinkTargetType targetType,
                required String targetId,
                Value<int> rowid = const Value.absent(),
              }) => SessionLinksCompanion.insert(
                sessionId: sessionId,
                targetType: targetType,
                targetId: targetId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionLinksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$SessionLinksTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$SessionLinksTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SessionLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionLinksTable,
      SessionLink,
      $$SessionLinksTableFilterComposer,
      $$SessionLinksTableOrderingComposer,
      $$SessionLinksTableAnnotationComposer,
      $$SessionLinksTableCreateCompanionBuilder,
      $$SessionLinksTableUpdateCompanionBuilder,
      (SessionLink, $$SessionLinksTableReferences),
      SessionLink,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$ThoughtRecordsTableCreateCompanionBuilder =
    ThoughtRecordsCompanion Function({
      required String id,
      required DateTime occurredAt,
      Value<DateTime> createdAt,
      required String situation,
      required String automaticThought,
      Value<int?> beliefBefore,
      Value<String?> emotionLabel,
      Value<int?> emotionIntensityBefore,
      Value<String?> alternativeThought,
      Value<int?> beliefAfter,
      Value<int?> emotionIntensityAfter,
      Value<int> rowid,
    });
typedef $$ThoughtRecordsTableUpdateCompanionBuilder =
    ThoughtRecordsCompanion Function({
      Value<String> id,
      Value<DateTime> occurredAt,
      Value<DateTime> createdAt,
      Value<String> situation,
      Value<String> automaticThought,
      Value<int?> beliefBefore,
      Value<String?> emotionLabel,
      Value<int?> emotionIntensityBefore,
      Value<String?> alternativeThought,
      Value<int?> beliefAfter,
      Value<int?> emotionIntensityAfter,
      Value<int> rowid,
    });

final class $$ThoughtRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $ThoughtRecordsTable, ThoughtRecord> {
  $$ThoughtRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $ThoughtRecordDistortionsTable,
    List<ThoughtRecordDistortion>
  >
  _thoughtRecordDistortionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.thoughtRecordDistortions,
        aliasName: 'thought_records__id__thought_record_distortions__record_id',
      );

  $$ThoughtRecordDistortionsTableProcessedTableManager
  get thoughtRecordDistortionsRefs {
    final manager = $$ThoughtRecordDistortionsTableTableManager(
      $_db,
      $_db.thoughtRecordDistortions,
    ).filter((f) => f.recordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _thoughtRecordDistortionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ThoughtRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ThoughtRecordsTable> {
  $$ThoughtRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get situation => $composableBuilder(
    column: $table.situation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get automaticThought => $composableBuilder(
    column: $table.automaticThought,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get beliefBefore => $composableBuilder(
    column: $table.beliefBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emotionLabel => $composableBuilder(
    column: $table.emotionLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get emotionIntensityBefore => $composableBuilder(
    column: $table.emotionIntensityBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alternativeThought => $composableBuilder(
    column: $table.alternativeThought,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get beliefAfter => $composableBuilder(
    column: $table.beliefAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get emotionIntensityAfter => $composableBuilder(
    column: $table.emotionIntensityAfter,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> thoughtRecordDistortionsRefs(
    Expression<bool> Function($$ThoughtRecordDistortionsTableFilterComposer f)
    f,
  ) {
    final $$ThoughtRecordDistortionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.thoughtRecordDistortions,
          getReferencedColumn: (t) => t.recordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ThoughtRecordDistortionsTableFilterComposer(
                $db: $db,
                $table: $db.thoughtRecordDistortions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ThoughtRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ThoughtRecordsTable> {
  $$ThoughtRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get situation => $composableBuilder(
    column: $table.situation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get automaticThought => $composableBuilder(
    column: $table.automaticThought,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get beliefBefore => $composableBuilder(
    column: $table.beliefBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emotionLabel => $composableBuilder(
    column: $table.emotionLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get emotionIntensityBefore => $composableBuilder(
    column: $table.emotionIntensityBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alternativeThought => $composableBuilder(
    column: $table.alternativeThought,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get beliefAfter => $composableBuilder(
    column: $table.beliefAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get emotionIntensityAfter => $composableBuilder(
    column: $table.emotionIntensityAfter,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ThoughtRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ThoughtRecordsTable> {
  $$ThoughtRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get situation =>
      $composableBuilder(column: $table.situation, builder: (column) => column);

  GeneratedColumn<String> get automaticThought => $composableBuilder(
    column: $table.automaticThought,
    builder: (column) => column,
  );

  GeneratedColumn<int> get beliefBefore => $composableBuilder(
    column: $table.beliefBefore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emotionLabel => $composableBuilder(
    column: $table.emotionLabel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get emotionIntensityBefore => $composableBuilder(
    column: $table.emotionIntensityBefore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get alternativeThought => $composableBuilder(
    column: $table.alternativeThought,
    builder: (column) => column,
  );

  GeneratedColumn<int> get beliefAfter => $composableBuilder(
    column: $table.beliefAfter,
    builder: (column) => column,
  );

  GeneratedColumn<int> get emotionIntensityAfter => $composableBuilder(
    column: $table.emotionIntensityAfter,
    builder: (column) => column,
  );

  Expression<T> thoughtRecordDistortionsRefs<T extends Object>(
    Expression<T> Function($$ThoughtRecordDistortionsTableAnnotationComposer a)
    f,
  ) {
    final $$ThoughtRecordDistortionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.thoughtRecordDistortions,
          getReferencedColumn: (t) => t.recordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ThoughtRecordDistortionsTableAnnotationComposer(
                $db: $db,
                $table: $db.thoughtRecordDistortions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ThoughtRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ThoughtRecordsTable,
          ThoughtRecord,
          $$ThoughtRecordsTableFilterComposer,
          $$ThoughtRecordsTableOrderingComposer,
          $$ThoughtRecordsTableAnnotationComposer,
          $$ThoughtRecordsTableCreateCompanionBuilder,
          $$ThoughtRecordsTableUpdateCompanionBuilder,
          (ThoughtRecord, $$ThoughtRecordsTableReferences),
          ThoughtRecord,
          PrefetchHooks Function({bool thoughtRecordDistortionsRefs})
        > {
  $$ThoughtRecordsTableTableManager(
    _$AppDatabase db,
    $ThoughtRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThoughtRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ThoughtRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ThoughtRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> situation = const Value.absent(),
                Value<String> automaticThought = const Value.absent(),
                Value<int?> beliefBefore = const Value.absent(),
                Value<String?> emotionLabel = const Value.absent(),
                Value<int?> emotionIntensityBefore = const Value.absent(),
                Value<String?> alternativeThought = const Value.absent(),
                Value<int?> beliefAfter = const Value.absent(),
                Value<int?> emotionIntensityAfter = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ThoughtRecordsCompanion(
                id: id,
                occurredAt: occurredAt,
                createdAt: createdAt,
                situation: situation,
                automaticThought: automaticThought,
                beliefBefore: beliefBefore,
                emotionLabel: emotionLabel,
                emotionIntensityBefore: emotionIntensityBefore,
                alternativeThought: alternativeThought,
                beliefAfter: beliefAfter,
                emotionIntensityAfter: emotionIntensityAfter,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime occurredAt,
                Value<DateTime> createdAt = const Value.absent(),
                required String situation,
                required String automaticThought,
                Value<int?> beliefBefore = const Value.absent(),
                Value<String?> emotionLabel = const Value.absent(),
                Value<int?> emotionIntensityBefore = const Value.absent(),
                Value<String?> alternativeThought = const Value.absent(),
                Value<int?> beliefAfter = const Value.absent(),
                Value<int?> emotionIntensityAfter = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ThoughtRecordsCompanion.insert(
                id: id,
                occurredAt: occurredAt,
                createdAt: createdAt,
                situation: situation,
                automaticThought: automaticThought,
                beliefBefore: beliefBefore,
                emotionLabel: emotionLabel,
                emotionIntensityBefore: emotionIntensityBefore,
                alternativeThought: alternativeThought,
                beliefAfter: beliefAfter,
                emotionIntensityAfter: emotionIntensityAfter,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ThoughtRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({thoughtRecordDistortionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (thoughtRecordDistortionsRefs) db.thoughtRecordDistortions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (thoughtRecordDistortionsRefs)
                    await $_getPrefetchedData<
                      ThoughtRecord,
                      $ThoughtRecordsTable,
                      ThoughtRecordDistortion
                    >(
                      currentTable: table,
                      referencedTable: $$ThoughtRecordsTableReferences
                          ._thoughtRecordDistortionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ThoughtRecordsTableReferences(
                            db,
                            table,
                            p0,
                          ).thoughtRecordDistortionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.recordId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ThoughtRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ThoughtRecordsTable,
      ThoughtRecord,
      $$ThoughtRecordsTableFilterComposer,
      $$ThoughtRecordsTableOrderingComposer,
      $$ThoughtRecordsTableAnnotationComposer,
      $$ThoughtRecordsTableCreateCompanionBuilder,
      $$ThoughtRecordsTableUpdateCompanionBuilder,
      (ThoughtRecord, $$ThoughtRecordsTableReferences),
      ThoughtRecord,
      PrefetchHooks Function({bool thoughtRecordDistortionsRefs})
    >;
typedef $$ThoughtRecordDistortionsTableCreateCompanionBuilder =
    ThoughtRecordDistortionsCompanion Function({
      required String recordId,
      required CognitiveDistortion distortion,
      Value<int> rowid,
    });
typedef $$ThoughtRecordDistortionsTableUpdateCompanionBuilder =
    ThoughtRecordDistortionsCompanion Function({
      Value<String> recordId,
      Value<CognitiveDistortion> distortion,
      Value<int> rowid,
    });

final class $$ThoughtRecordDistortionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ThoughtRecordDistortionsTable,
          ThoughtRecordDistortion
        > {
  $$ThoughtRecordDistortionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ThoughtRecordsTable _recordIdTable(_$AppDatabase db) =>
      db.thoughtRecords.createAlias(
        'thought_record_distortions__record_id__thought_records__id',
      );

  $$ThoughtRecordsTableProcessedTableManager get recordId {
    final $_column = $_itemColumn<String>('record_id')!;

    final manager = $$ThoughtRecordsTableTableManager(
      $_db,
      $_db.thoughtRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ThoughtRecordDistortionsTableFilterComposer
    extends Composer<_$AppDatabase, $ThoughtRecordDistortionsTable> {
  $$ThoughtRecordDistortionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<CognitiveDistortion, CognitiveDistortion, int>
  get distortion => $composableBuilder(
    column: $table.distortion,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$ThoughtRecordsTableFilterComposer get recordId {
    final $$ThoughtRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.thoughtRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ThoughtRecordsTableFilterComposer(
            $db: $db,
            $table: $db.thoughtRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ThoughtRecordDistortionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ThoughtRecordDistortionsTable> {
  $$ThoughtRecordDistortionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get distortion => $composableBuilder(
    column: $table.distortion,
    builder: (column) => ColumnOrderings(column),
  );

  $$ThoughtRecordsTableOrderingComposer get recordId {
    final $$ThoughtRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.thoughtRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ThoughtRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.thoughtRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ThoughtRecordDistortionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ThoughtRecordDistortionsTable> {
  $$ThoughtRecordDistortionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<CognitiveDistortion, int> get distortion =>
      $composableBuilder(
        column: $table.distortion,
        builder: (column) => column,
      );

  $$ThoughtRecordsTableAnnotationComposer get recordId {
    final $$ThoughtRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.thoughtRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ThoughtRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.thoughtRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ThoughtRecordDistortionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ThoughtRecordDistortionsTable,
          ThoughtRecordDistortion,
          $$ThoughtRecordDistortionsTableFilterComposer,
          $$ThoughtRecordDistortionsTableOrderingComposer,
          $$ThoughtRecordDistortionsTableAnnotationComposer,
          $$ThoughtRecordDistortionsTableCreateCompanionBuilder,
          $$ThoughtRecordDistortionsTableUpdateCompanionBuilder,
          (ThoughtRecordDistortion, $$ThoughtRecordDistortionsTableReferences),
          ThoughtRecordDistortion,
          PrefetchHooks Function({bool recordId})
        > {
  $$ThoughtRecordDistortionsTableTableManager(
    _$AppDatabase db,
    $ThoughtRecordDistortionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThoughtRecordDistortionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ThoughtRecordDistortionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ThoughtRecordDistortionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> recordId = const Value.absent(),
                Value<CognitiveDistortion> distortion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ThoughtRecordDistortionsCompanion(
                recordId: recordId,
                distortion: distortion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String recordId,
                required CognitiveDistortion distortion,
                Value<int> rowid = const Value.absent(),
              }) => ThoughtRecordDistortionsCompanion.insert(
                recordId: recordId,
                distortion: distortion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ThoughtRecordDistortionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recordId,
                        referencedTable:
                            $$ThoughtRecordDistortionsTableReferences
                                ._recordIdTable(db),
                        referencedColumn:
                            $$ThoughtRecordDistortionsTableReferences
                                ._recordIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ThoughtRecordDistortionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ThoughtRecordDistortionsTable,
      ThoughtRecordDistortion,
      $$ThoughtRecordDistortionsTableFilterComposer,
      $$ThoughtRecordDistortionsTableOrderingComposer,
      $$ThoughtRecordDistortionsTableAnnotationComposer,
      $$ThoughtRecordDistortionsTableCreateCompanionBuilder,
      $$ThoughtRecordDistortionsTableUpdateCompanionBuilder,
      (ThoughtRecordDistortion, $$ThoughtRecordDistortionsTableReferences),
      ThoughtRecordDistortion,
      PrefetchHooks Function({bool recordId})
    >;
typedef $$MedicationsTableCreateCompanionBuilder =
    MedicationsCompanion Function({
      required String id,
      required String name,
      Value<String?> dose,
      Value<String?> scheduleNote,
      Value<bool> active,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$MedicationsTableUpdateCompanionBuilder =
    MedicationsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> dose,
      Value<String?> scheduleNote,
      Value<bool> active,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$MedicationsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationsTable, Medication> {
  $$MedicationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MedicationLogsTable, List<MedicationLog>>
  _medicationLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medicationLogs,
    aliasName: 'medications__id__medication_logs__medication_id',
  );

  $$MedicationLogsTableProcessedTableManager get medicationLogsRefs {
    final manager = $$MedicationLogsTableTableManager(
      $_db,
      $_db.medicationLogs,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicationLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduleNote => $composableBuilder(
    column: $table.scheduleNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> medicationLogsRefs(
    Expression<bool> Function($$MedicationLogsTableFilterComposer f) f,
  ) {
    final $$MedicationLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationLogs,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationLogsTableFilterComposer(
            $db: $db,
            $table: $db.medicationLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleNote => $composableBuilder(
    column: $table.scheduleNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumn<String> get scheduleNote => $composableBuilder(
    column: $table.scheduleNote,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> medicationLogsRefs<T extends Object>(
    Expression<T> Function($$MedicationLogsTableAnnotationComposer a) f,
  ) {
    final $$MedicationLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationLogs,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicationLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationsTable,
          Medication,
          $$MedicationsTableFilterComposer,
          $$MedicationsTableOrderingComposer,
          $$MedicationsTableAnnotationComposer,
          $$MedicationsTableCreateCompanionBuilder,
          $$MedicationsTableUpdateCompanionBuilder,
          (Medication, $$MedicationsTableReferences),
          Medication,
          PrefetchHooks Function({bool medicationLogsRefs})
        > {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> dose = const Value.absent(),
                Value<String?> scheduleNote = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion(
                id: id,
                name: name,
                dose: dose,
                scheduleNote: scheduleNote,
                active: active,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> dose = const Value.absent(),
                Value<String?> scheduleNote = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion.insert(
                id: id,
                name: name,
                dose: dose,
                scheduleNote: scheduleNote,
                active: active,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (medicationLogsRefs) db.medicationLogs,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medicationLogsRefs)
                    await $_getPrefetchedData<
                      Medication,
                      $MedicationsTable,
                      MedicationLog
                    >(
                      currentTable: table,
                      referencedTable: $$MedicationsTableReferences
                          ._medicationLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MedicationsTableReferences(
                            db,
                            table,
                            p0,
                          ).medicationLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.medicationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MedicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationsTable,
      Medication,
      $$MedicationsTableFilterComposer,
      $$MedicationsTableOrderingComposer,
      $$MedicationsTableAnnotationComposer,
      $$MedicationsTableCreateCompanionBuilder,
      $$MedicationsTableUpdateCompanionBuilder,
      (Medication, $$MedicationsTableReferences),
      Medication,
      PrefetchHooks Function({bool medicationLogsRefs})
    >;
typedef $$MedicationLogsTableCreateCompanionBuilder =
    MedicationLogsCompanion Function({
      required String id,
      required String medicationId,
      required DateTime takenAt,
      Value<int> rowid,
    });
typedef $$MedicationLogsTableUpdateCompanionBuilder =
    MedicationLogsCompanion Function({
      Value<String> id,
      Value<String> medicationId,
      Value<DateTime> takenAt,
      Value<int> rowid,
    });

final class $$MedicationLogsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationLogsTable, MedicationLog> {
  $$MedicationLogsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) => db
      .medications
      .createAlias('medication_logs__medication_id__medications__id');

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicationLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationLogsTable> {
  $$MedicationLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationLogsTable> {
  $$MedicationLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationLogsTable> {
  $$MedicationLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationLogsTable,
          MedicationLog,
          $$MedicationLogsTableFilterComposer,
          $$MedicationLogsTableOrderingComposer,
          $$MedicationLogsTableAnnotationComposer,
          $$MedicationLogsTableCreateCompanionBuilder,
          $$MedicationLogsTableUpdateCompanionBuilder,
          (MedicationLog, $$MedicationLogsTableReferences),
          MedicationLog,
          PrefetchHooks Function({bool medicationId})
        > {
  $$MedicationLogsTableTableManager(
    _$AppDatabase db,
    $MedicationLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationLogsCompanion(
                id: id,
                medicationId: medicationId,
                takenAt: takenAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicationId,
                required DateTime takenAt,
                Value<int> rowid = const Value.absent(),
              }) => MedicationLogsCompanion.insert(
                id: id,
                medicationId: medicationId,
                takenAt: takenAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicationLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.medicationId,
                        referencedTable: $$MedicationLogsTableReferences
                            ._medicationIdTable(db),
                        referencedColumn: $$MedicationLogsTableReferences
                            ._medicationIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MedicationLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationLogsTable,
      MedicationLog,
      $$MedicationLogsTableFilterComposer,
      $$MedicationLogsTableOrderingComposer,
      $$MedicationLogsTableAnnotationComposer,
      $$MedicationLogsTableCreateCompanionBuilder,
      $$MedicationLogsTableUpdateCompanionBuilder,
      (MedicationLog, $$MedicationLogsTableReferences),
      MedicationLog,
      PrefetchHooks Function({bool medicationId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MoodEntriesTableTableManager get moodEntries =>
      $$MoodEntriesTableTableManager(_db, _db.moodEntries);
  $$MoodEntryEmotionsTableTableManager get moodEntryEmotions =>
      $$MoodEntryEmotionsTableTableManager(_db, _db.moodEntryEmotions);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
  $$JournalEntryEmotionsTableTableManager get journalEntryEmotions =>
      $$JournalEntryEmotionsTableTableManager(_db, _db.journalEntryEmotions);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$MoodEntryTagsTableTableManager get moodEntryTags =>
      $$MoodEntryTagsTableTableManager(_db, _db.moodEntryTags);
  $$JournalEntryTagsTableTableManager get journalEntryTags =>
      $$JournalEntryTagsTableTableManager(_db, _db.journalEntryTags);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$SessionLinksTableTableManager get sessionLinks =>
      $$SessionLinksTableTableManager(_db, _db.sessionLinks);
  $$ThoughtRecordsTableTableManager get thoughtRecords =>
      $$ThoughtRecordsTableTableManager(_db, _db.thoughtRecords);
  $$ThoughtRecordDistortionsTableTableManager get thoughtRecordDistortions =>
      $$ThoughtRecordDistortionsTableTableManager(
        _db,
        _db.thoughtRecordDistortions,
      );
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$MedicationLogsTableTableManager get medicationLogs =>
      $$MedicationLogsTableTableManager(_db, _db.medicationLogs);
}
