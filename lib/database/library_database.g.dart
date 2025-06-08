// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_database.dart';

// ignore_for_file: type=lint
class $SessionsTable extends Sessions
    with TableInfo<$SessionsTable, UserSessionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _libraryNameMeta = const VerificationMeta(
    'libraryName',
  );
  @override
  late final GeneratedColumn<String> libraryName = GeneratedColumn<String>(
    'library_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sheetIdMeta = const VerificationMeta(
    'sheetId',
  );
  @override
  late final GeneratedColumn<String> sheetId = GeneratedColumn<String>(
    'sheet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _driveFolderIdMeta = const VerificationMeta(
    'driveFolderId',
  );
  @override
  late final GeneratedColumn<String> driveFolderId = GeneratedColumn<String>(
    'drive_folder_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAdminMeta = const VerificationMeta(
    'isAdmin',
  );
  @override
  late final GeneratedColumn<bool> isAdmin = GeneratedColumn<bool>(
    'is_admin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_admin" IN (0, 1))',
    ),
    defaultValue: Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    libraryName,
    userId,
    sheetId,
    driveFolderId,
    isAdmin,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSessionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('library_name')) {
      context.handle(
        _libraryNameMeta,
        libraryName.isAcceptableOrUnknown(
          data['library_name']!,
          _libraryNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_libraryNameMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('sheet_id')) {
      context.handle(
        _sheetIdMeta,
        sheetId.isAcceptableOrUnknown(data['sheet_id']!, _sheetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sheetIdMeta);
    }
    if (data.containsKey('drive_folder_id')) {
      context.handle(
        _driveFolderIdMeta,
        driveFolderId.isAcceptableOrUnknown(
          data['drive_folder_id']!,
          _driveFolderIdMeta,
        ),
      );
    }
    if (data.containsKey('is_admin')) {
      context.handle(
        _isAdminMeta,
        isAdmin.isAcceptableOrUnknown(data['is_admin']!, _isAdminMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  UserSessionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSessionData(
      libraryName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}library_name'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      sheetId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sheet_id'],
          )!,
      driveFolderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drive_folder_id'],
      ),
      isAdmin:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_admin'],
          )!,
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class UserSessionData extends DataClass implements Insertable<UserSessionData> {
  final String libraryName;
  final String userId;
  final String sheetId;
  final String? driveFolderId;
  final bool isAdmin;
  final bool isActive;
  const UserSessionData({
    required this.libraryName,
    required this.userId,
    required this.sheetId,
    this.driveFolderId,
    required this.isAdmin,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['library_name'] = Variable<String>(libraryName);
    map['user_id'] = Variable<String>(userId);
    map['sheet_id'] = Variable<String>(sheetId);
    if (!nullToAbsent || driveFolderId != null) {
      map['drive_folder_id'] = Variable<String>(driveFolderId);
    }
    map['is_admin'] = Variable<bool>(isAdmin);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      libraryName: Value(libraryName),
      userId: Value(userId),
      sheetId: Value(sheetId),
      driveFolderId:
          driveFolderId == null && nullToAbsent
              ? const Value.absent()
              : Value(driveFolderId),
      isAdmin: Value(isAdmin),
      isActive: Value(isActive),
    );
  }

  factory UserSessionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSessionData(
      libraryName: serializer.fromJson<String>(json['libraryName']),
      userId: serializer.fromJson<String>(json['userId']),
      sheetId: serializer.fromJson<String>(json['sheetId']),
      driveFolderId: serializer.fromJson<String?>(json['driveFolderId']),
      isAdmin: serializer.fromJson<bool>(json['isAdmin']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'libraryName': serializer.toJson<String>(libraryName),
      'userId': serializer.toJson<String>(userId),
      'sheetId': serializer.toJson<String>(sheetId),
      'driveFolderId': serializer.toJson<String?>(driveFolderId),
      'isAdmin': serializer.toJson<bool>(isAdmin),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  UserSessionData copyWith({
    String? libraryName,
    String? userId,
    String? sheetId,
    Value<String?> driveFolderId = const Value.absent(),
    bool? isAdmin,
    bool? isActive,
  }) => UserSessionData(
    libraryName: libraryName ?? this.libraryName,
    userId: userId ?? this.userId,
    sheetId: sheetId ?? this.sheetId,
    driveFolderId:
        driveFolderId.present ? driveFolderId.value : this.driveFolderId,
    isAdmin: isAdmin ?? this.isAdmin,
    isActive: isActive ?? this.isActive,
  );
  UserSessionData copyWithCompanion(SessionsCompanion data) {
    return UserSessionData(
      libraryName:
          data.libraryName.present ? data.libraryName.value : this.libraryName,
      userId: data.userId.present ? data.userId.value : this.userId,
      sheetId: data.sheetId.present ? data.sheetId.value : this.sheetId,
      driveFolderId:
          data.driveFolderId.present
              ? data.driveFolderId.value
              : this.driveFolderId,
      isAdmin: data.isAdmin.present ? data.isAdmin.value : this.isAdmin,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSessionData(')
          ..write('libraryName: $libraryName, ')
          ..write('userId: $userId, ')
          ..write('sheetId: $sheetId, ')
          ..write('driveFolderId: $driveFolderId, ')
          ..write('isAdmin: $isAdmin, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    libraryName,
    userId,
    sheetId,
    driveFolderId,
    isAdmin,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSessionData &&
          other.libraryName == this.libraryName &&
          other.userId == this.userId &&
          other.sheetId == this.sheetId &&
          other.driveFolderId == this.driveFolderId &&
          other.isAdmin == this.isAdmin &&
          other.isActive == this.isActive);
}

class SessionsCompanion extends UpdateCompanion<UserSessionData> {
  final Value<String> libraryName;
  final Value<String> userId;
  final Value<String> sheetId;
  final Value<String?> driveFolderId;
  final Value<bool> isAdmin;
  final Value<bool> isActive;
  final Value<int> rowid;
  const SessionsCompanion({
    this.libraryName = const Value.absent(),
    this.userId = const Value.absent(),
    this.sheetId = const Value.absent(),
    this.driveFolderId = const Value.absent(),
    this.isAdmin = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String libraryName,
    required String userId,
    required String sheetId,
    this.driveFolderId = const Value.absent(),
    this.isAdmin = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : libraryName = Value(libraryName),
       userId = Value(userId),
       sheetId = Value(sheetId);
  static Insertable<UserSessionData> custom({
    Expression<String>? libraryName,
    Expression<String>? userId,
    Expression<String>? sheetId,
    Expression<String>? driveFolderId,
    Expression<bool>? isAdmin,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (libraryName != null) 'library_name': libraryName,
      if (userId != null) 'user_id': userId,
      if (sheetId != null) 'sheet_id': sheetId,
      if (driveFolderId != null) 'drive_folder_id': driveFolderId,
      if (isAdmin != null) 'is_admin': isAdmin,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? libraryName,
    Value<String>? userId,
    Value<String>? sheetId,
    Value<String?>? driveFolderId,
    Value<bool>? isAdmin,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      libraryName: libraryName ?? this.libraryName,
      userId: userId ?? this.userId,
      sheetId: sheetId ?? this.sheetId,
      driveFolderId: driveFolderId ?? this.driveFolderId,
      isAdmin: isAdmin ?? this.isAdmin,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (libraryName.present) {
      map['library_name'] = Variable<String>(libraryName.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sheetId.present) {
      map['sheet_id'] = Variable<String>(sheetId.value);
    }
    if (driveFolderId.present) {
      map['drive_folder_id'] = Variable<String>(driveFolderId.value);
    }
    if (isAdmin.present) {
      map['is_admin'] = Variable<bool>(isAdmin.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('libraryName: $libraryName, ')
          ..write('userId: $userId, ')
          ..write('sheetId: $sheetId, ')
          ..write('driveFolderId: $driveFolderId, ')
          ..write('isAdmin: $isAdmin, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ComposersTable extends Composers
    with TableInfo<$ComposersTable, ComposerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComposersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const String $name = 'composers';
  @override
  VerificationContext validateIntegrity(
    Insertable<ComposerData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
  ComposerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ComposerData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
    );
  }

  @override
  $ComposersTable createAlias(String alias) {
    return $ComposersTable(attachedDatabase, alias);
  }
}

class ComposerData extends DataClass implements Insertable<ComposerData> {
  final int id;
  final String name;
  const ComposerData({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  ComposersCompanion toCompanion(bool nullToAbsent) {
    return ComposersCompanion(id: Value(id), name: Value(name));
  }

  factory ComposerData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ComposerData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  ComposerData copyWith({int? id, String? name}) =>
      ComposerData(id: id ?? this.id, name: name ?? this.name);
  ComposerData copyWithCompanion(ComposersCompanion data) {
    return ComposerData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ComposerData(')
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
      (other is ComposerData && other.id == this.id && other.name == this.name);
}

class ComposersCompanion extends UpdateCompanion<ComposerData> {
  final Value<int> id;
  final Value<String> name;
  const ComposersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ComposersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<ComposerData> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  ComposersCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return ComposersCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComposersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _identifierMeta = const VerificationMeta(
    'identifier',
  );
  @override
  late final GeneratedColumn<String> identifier = GeneratedColumn<String>(
    'identifier',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, identifier];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('identifier')) {
      context.handle(
        _identifierMeta,
        identifier.isAcceptableOrUnknown(data['identifier']!, _identifierMeta),
      );
    } else if (isInserting) {
      context.missing(_identifierMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      identifier:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}identifier'],
          )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryData extends DataClass implements Insertable<CategoryData> {
  final int id;
  final String name;
  final String identifier;
  const CategoryData({
    required this.id,
    required this.name,
    required this.identifier,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['identifier'] = Variable<String>(identifier);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      identifier: Value(identifier),
    );
  }

  factory CategoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      identifier: serializer.fromJson<String>(json['identifier']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'identifier': serializer.toJson<String>(identifier),
    };
  }

  CategoryData copyWith({int? id, String? name, String? identifier}) =>
      CategoryData(
        id: id ?? this.id,
        name: name ?? this.name,
        identifier: identifier ?? this.identifier,
      );
  CategoryData copyWithCompanion(CategoriesCompanion data) {
    return CategoryData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      identifier:
          data.identifier.present ? data.identifier.value : this.identifier,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('identifier: $identifier')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, identifier);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryData &&
          other.id == this.id &&
          other.name == this.name &&
          other.identifier == this.identifier);
}

class CategoriesCompanion extends UpdateCompanion<CategoryData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> identifier;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.identifier = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String identifier,
  }) : name = Value(name),
       identifier = Value(identifier);
  static Insertable<CategoryData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? identifier,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (identifier != null) 'identifier': identifier,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? identifier,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      identifier: identifier ?? this.identifier,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (identifier.present) {
      map['identifier'] = Variable<String>(identifier.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('identifier: $identifier')
          ..write(')'))
        .toString();
  }
}

class $SubcategoriesTable extends Subcategories
    with TableInfo<$SubcategoriesTable, SubcategoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubcategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subcategories';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubcategoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubcategoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubcategoryData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      categoryId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}category_id'],
          )!,
    );
  }

  @override
  $SubcategoriesTable createAlias(String alias) {
    return $SubcategoriesTable(attachedDatabase, alias);
  }
}

class SubcategoryData extends DataClass implements Insertable<SubcategoryData> {
  final int id;
  final String name;
  final int categoryId;
  const SubcategoryData({
    required this.id,
    required this.name,
    required this.categoryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category_id'] = Variable<int>(categoryId);
    return map;
  }

  SubcategoriesCompanion toCompanion(bool nullToAbsent) {
    return SubcategoriesCompanion(
      id: Value(id),
      name: Value(name),
      categoryId: Value(categoryId),
    );
  }

  factory SubcategoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubcategoryData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  SubcategoryData copyWith({int? id, String? name, int? categoryId}) =>
      SubcategoryData(
        id: id ?? this.id,
        name: name ?? this.name,
        categoryId: categoryId ?? this.categoryId,
      );
  SubcategoryData copyWithCompanion(SubcategoriesCompanion data) {
    return SubcategoryData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubcategoryData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubcategoryData &&
          other.id == this.id &&
          other.name == this.name &&
          other.categoryId == this.categoryId);
}

class SubcategoriesCompanion extends UpdateCompanion<SubcategoryData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> categoryId;
  const SubcategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
  });
  SubcategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int categoryId,
  }) : name = Value(name),
       categoryId = Value(categoryId);
  static Insertable<SubcategoryData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? categoryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
    });
  }

  SubcategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? categoryId,
  }) {
    return SubcategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubcategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }
}

class $ScoresTable extends Scores with TableInfo<$ScoresTable, ScoreData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _composerIdMeta = const VerificationMeta(
    'composerId',
  );
  @override
  late final GeneratedColumn<int> composerId = GeneratedColumn<int>(
    'composer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES composers (id)',
    ),
  );
  static const VerificationMeta _arrangerMeta = const VerificationMeta(
    'arranger',
  );
  @override
  late final GeneratedColumn<String> arranger = GeneratedColumn<String>(
    'arranger',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(""),
  );
  static const VerificationMeta _catalogNumberMeta = const VerificationMeta(
    'catalogNumber',
  );
  @override
  late final GeneratedColumn<String> catalogNumber = GeneratedColumn<String>(
    'catalog_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(""),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linkMeta = const VerificationMeta('link');
  @override
  late final GeneratedColumn<String> link = GeneratedColumn<String>(
    'link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _changeTimeMeta = const VerificationMeta(
    'changeTime',
  );
  @override
  late final GeneratedColumn<DateTime> changeTime = GeneratedColumn<DateTime>(
    'change_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    composerId,
    arranger,
    catalogNumber,
    notes,
    categoryId,
    status,
    link,
    changeTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scores';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScoreData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('composer_id')) {
      context.handle(
        _composerIdMeta,
        composerId.isAcceptableOrUnknown(data['composer_id']!, _composerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_composerIdMeta);
    }
    if (data.containsKey('arranger')) {
      context.handle(
        _arrangerMeta,
        arranger.isAcceptableOrUnknown(data['arranger']!, _arrangerMeta),
      );
    }
    if (data.containsKey('catalog_number')) {
      context.handle(
        _catalogNumberMeta,
        catalogNumber.isAcceptableOrUnknown(
          data['catalog_number']!,
          _catalogNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_catalogNumberMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('link')) {
      context.handle(
        _linkMeta,
        link.isAcceptableOrUnknown(data['link']!, _linkMeta),
      );
    }
    if (data.containsKey('change_time')) {
      context.handle(
        _changeTimeMeta,
        changeTime.isAcceptableOrUnknown(data['change_time']!, _changeTimeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScoreData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScoreData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      composerId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}composer_id'],
          )!,
      arranger:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}arranger'],
          )!,
      catalogNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}catalog_number'],
          )!,
      notes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}notes'],
          )!,
      categoryId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}category_id'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      link: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link'],
      ),
      changeTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}change_time'],
          )!,
    );
  }

  @override
  $ScoresTable createAlias(String alias) {
    return $ScoresTable(attachedDatabase, alias);
  }
}

class ScoreData extends DataClass implements Insertable<ScoreData> {
  final int id;
  final String title;
  final int composerId;
  final String arranger;
  final String catalogNumber;
  final String notes;
  final int categoryId;
  final String status;
  final String? link;
  final DateTime changeTime;
  const ScoreData({
    required this.id,
    required this.title,
    required this.composerId,
    required this.arranger,
    required this.catalogNumber,
    required this.notes,
    required this.categoryId,
    required this.status,
    this.link,
    required this.changeTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['composer_id'] = Variable<int>(composerId);
    map['arranger'] = Variable<String>(arranger);
    map['catalog_number'] = Variable<String>(catalogNumber);
    map['notes'] = Variable<String>(notes);
    map['category_id'] = Variable<int>(categoryId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || link != null) {
      map['link'] = Variable<String>(link);
    }
    map['change_time'] = Variable<DateTime>(changeTime);
    return map;
  }

  ScoresCompanion toCompanion(bool nullToAbsent) {
    return ScoresCompanion(
      id: Value(id),
      title: Value(title),
      composerId: Value(composerId),
      arranger: Value(arranger),
      catalogNumber: Value(catalogNumber),
      notes: Value(notes),
      categoryId: Value(categoryId),
      status: Value(status),
      link: link == null && nullToAbsent ? const Value.absent() : Value(link),
      changeTime: Value(changeTime),
    );
  }

  factory ScoreData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScoreData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      composerId: serializer.fromJson<int>(json['composerId']),
      arranger: serializer.fromJson<String>(json['arranger']),
      catalogNumber: serializer.fromJson<String>(json['catalogNumber']),
      notes: serializer.fromJson<String>(json['notes']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      status: serializer.fromJson<String>(json['status']),
      link: serializer.fromJson<String?>(json['link']),
      changeTime: serializer.fromJson<DateTime>(json['changeTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'composerId': serializer.toJson<int>(composerId),
      'arranger': serializer.toJson<String>(arranger),
      'catalogNumber': serializer.toJson<String>(catalogNumber),
      'notes': serializer.toJson<String>(notes),
      'categoryId': serializer.toJson<int>(categoryId),
      'status': serializer.toJson<String>(status),
      'link': serializer.toJson<String?>(link),
      'changeTime': serializer.toJson<DateTime>(changeTime),
    };
  }

  ScoreData copyWith({
    int? id,
    String? title,
    int? composerId,
    String? arranger,
    String? catalogNumber,
    String? notes,
    int? categoryId,
    String? status,
    Value<String?> link = const Value.absent(),
    DateTime? changeTime,
  }) => ScoreData(
    id: id ?? this.id,
    title: title ?? this.title,
    composerId: composerId ?? this.composerId,
    arranger: arranger ?? this.arranger,
    catalogNumber: catalogNumber ?? this.catalogNumber,
    notes: notes ?? this.notes,
    categoryId: categoryId ?? this.categoryId,
    status: status ?? this.status,
    link: link.present ? link.value : this.link,
    changeTime: changeTime ?? this.changeTime,
  );
  ScoreData copyWithCompanion(ScoresCompanion data) {
    return ScoreData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      composerId:
          data.composerId.present ? data.composerId.value : this.composerId,
      arranger: data.arranger.present ? data.arranger.value : this.arranger,
      catalogNumber:
          data.catalogNumber.present
              ? data.catalogNumber.value
              : this.catalogNumber,
      notes: data.notes.present ? data.notes.value : this.notes,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      status: data.status.present ? data.status.value : this.status,
      link: data.link.present ? data.link.value : this.link,
      changeTime:
          data.changeTime.present ? data.changeTime.value : this.changeTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScoreData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('composerId: $composerId, ')
          ..write('arranger: $arranger, ')
          ..write('catalogNumber: $catalogNumber, ')
          ..write('notes: $notes, ')
          ..write('categoryId: $categoryId, ')
          ..write('status: $status, ')
          ..write('link: $link, ')
          ..write('changeTime: $changeTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    composerId,
    arranger,
    catalogNumber,
    notes,
    categoryId,
    status,
    link,
    changeTime,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScoreData &&
          other.id == this.id &&
          other.title == this.title &&
          other.composerId == this.composerId &&
          other.arranger == this.arranger &&
          other.catalogNumber == this.catalogNumber &&
          other.notes == this.notes &&
          other.categoryId == this.categoryId &&
          other.status == this.status &&
          other.link == this.link &&
          other.changeTime == this.changeTime);
}

class ScoresCompanion extends UpdateCompanion<ScoreData> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> composerId;
  final Value<String> arranger;
  final Value<String> catalogNumber;
  final Value<String> notes;
  final Value<int> categoryId;
  final Value<String> status;
  final Value<String?> link;
  final Value<DateTime> changeTime;
  const ScoresCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.composerId = const Value.absent(),
    this.arranger = const Value.absent(),
    this.catalogNumber = const Value.absent(),
    this.notes = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.status = const Value.absent(),
    this.link = const Value.absent(),
    this.changeTime = const Value.absent(),
  });
  ScoresCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required int composerId,
    this.arranger = const Value.absent(),
    required String catalogNumber,
    this.notes = const Value.absent(),
    required int categoryId,
    required String status,
    this.link = const Value.absent(),
    this.changeTime = const Value.absent(),
  }) : title = Value(title),
       composerId = Value(composerId),
       catalogNumber = Value(catalogNumber),
       categoryId = Value(categoryId),
       status = Value(status);
  static Insertable<ScoreData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? composerId,
    Expression<String>? arranger,
    Expression<String>? catalogNumber,
    Expression<String>? notes,
    Expression<int>? categoryId,
    Expression<String>? status,
    Expression<String>? link,
    Expression<DateTime>? changeTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (composerId != null) 'composer_id': composerId,
      if (arranger != null) 'arranger': arranger,
      if (catalogNumber != null) 'catalog_number': catalogNumber,
      if (notes != null) 'notes': notes,
      if (categoryId != null) 'category_id': categoryId,
      if (status != null) 'status': status,
      if (link != null) 'link': link,
      if (changeTime != null) 'change_time': changeTime,
    });
  }

  ScoresCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int>? composerId,
    Value<String>? arranger,
    Value<String>? catalogNumber,
    Value<String>? notes,
    Value<int>? categoryId,
    Value<String>? status,
    Value<String?>? link,
    Value<DateTime>? changeTime,
  }) {
    return ScoresCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      composerId: composerId ?? this.composerId,
      arranger: arranger ?? this.arranger,
      catalogNumber: catalogNumber ?? this.catalogNumber,
      notes: notes ?? this.notes,
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      link: link ?? this.link,
      changeTime: changeTime ?? this.changeTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (composerId.present) {
      map['composer_id'] = Variable<int>(composerId.value);
    }
    if (arranger.present) {
      map['arranger'] = Variable<String>(arranger.value);
    }
    if (catalogNumber.present) {
      map['catalog_number'] = Variable<String>(catalogNumber.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    if (changeTime.present) {
      map['change_time'] = Variable<DateTime>(changeTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScoresCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('composerId: $composerId, ')
          ..write('arranger: $arranger, ')
          ..write('catalogNumber: $catalogNumber, ')
          ..write('notes: $notes, ')
          ..write('categoryId: $categoryId, ')
          ..write('status: $status, ')
          ..write('link: $link, ')
          ..write('changeTime: $changeTime')
          ..write(')'))
        .toString();
  }
}

class $ScoreSubcategoriesTable extends ScoreSubcategories
    with TableInfo<$ScoreSubcategoriesTable, ScoreSubcategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScoreSubcategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scoreIdMeta = const VerificationMeta(
    'scoreId',
  );
  @override
  late final GeneratedColumn<int> scoreId = GeneratedColumn<int>(
    'score_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES scores (id)',
    ),
  );
  static const VerificationMeta _subcategoryIdMeta = const VerificationMeta(
    'subcategoryId',
  );
  @override
  late final GeneratedColumn<int> subcategoryId = GeneratedColumn<int>(
    'subcategory_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subcategories (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [scoreId, subcategoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'score_subcategories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScoreSubcategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('score_id')) {
      context.handle(
        _scoreIdMeta,
        scoreId.isAcceptableOrUnknown(data['score_id']!, _scoreIdMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreIdMeta);
    }
    if (data.containsKey('subcategory_id')) {
      context.handle(
        _subcategoryIdMeta,
        subcategoryId.isAcceptableOrUnknown(
          data['subcategory_id']!,
          _subcategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subcategoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scoreId, subcategoryId};
  @override
  ScoreSubcategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScoreSubcategory(
      scoreId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}score_id'],
          )!,
      subcategoryId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}subcategory_id'],
          )!,
    );
  }

  @override
  $ScoreSubcategoriesTable createAlias(String alias) {
    return $ScoreSubcategoriesTable(attachedDatabase, alias);
  }
}

class ScoreSubcategory extends DataClass
    implements Insertable<ScoreSubcategory> {
  final int scoreId;
  final int subcategoryId;
  const ScoreSubcategory({required this.scoreId, required this.subcategoryId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['score_id'] = Variable<int>(scoreId);
    map['subcategory_id'] = Variable<int>(subcategoryId);
    return map;
  }

  ScoreSubcategoriesCompanion toCompanion(bool nullToAbsent) {
    return ScoreSubcategoriesCompanion(
      scoreId: Value(scoreId),
      subcategoryId: Value(subcategoryId),
    );
  }

  factory ScoreSubcategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScoreSubcategory(
      scoreId: serializer.fromJson<int>(json['scoreId']),
      subcategoryId: serializer.fromJson<int>(json['subcategoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scoreId': serializer.toJson<int>(scoreId),
      'subcategoryId': serializer.toJson<int>(subcategoryId),
    };
  }

  ScoreSubcategory copyWith({int? scoreId, int? subcategoryId}) =>
      ScoreSubcategory(
        scoreId: scoreId ?? this.scoreId,
        subcategoryId: subcategoryId ?? this.subcategoryId,
      );
  ScoreSubcategory copyWithCompanion(ScoreSubcategoriesCompanion data) {
    return ScoreSubcategory(
      scoreId: data.scoreId.present ? data.scoreId.value : this.scoreId,
      subcategoryId:
          data.subcategoryId.present
              ? data.subcategoryId.value
              : this.subcategoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScoreSubcategory(')
          ..write('scoreId: $scoreId, ')
          ..write('subcategoryId: $subcategoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(scoreId, subcategoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScoreSubcategory &&
          other.scoreId == this.scoreId &&
          other.subcategoryId == this.subcategoryId);
}

class ScoreSubcategoriesCompanion extends UpdateCompanion<ScoreSubcategory> {
  final Value<int> scoreId;
  final Value<int> subcategoryId;
  final Value<int> rowid;
  const ScoreSubcategoriesCompanion({
    this.scoreId = const Value.absent(),
    this.subcategoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScoreSubcategoriesCompanion.insert({
    required int scoreId,
    required int subcategoryId,
    this.rowid = const Value.absent(),
  }) : scoreId = Value(scoreId),
       subcategoryId = Value(subcategoryId);
  static Insertable<ScoreSubcategory> custom({
    Expression<int>? scoreId,
    Expression<int>? subcategoryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scoreId != null) 'score_id': scoreId,
      if (subcategoryId != null) 'subcategory_id': subcategoryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScoreSubcategoriesCompanion copyWith({
    Value<int>? scoreId,
    Value<int>? subcategoryId,
    Value<int>? rowid,
  }) {
    return ScoreSubcategoriesCompanion(
      scoreId: scoreId ?? this.scoreId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scoreId.present) {
      map['score_id'] = Variable<int>(scoreId.value);
    }
    if (subcategoryId.present) {
      map['subcategory_id'] = Variable<int>(subcategoryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScoreSubcategoriesCompanion(')
          ..write('scoreId: $scoreId, ')
          ..write('subcategoryId: $subcategoryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LibraryDatabase extends GeneratedDatabase {
  _$LibraryDatabase(QueryExecutor e) : super(e);
  $LibraryDatabaseManager get managers => $LibraryDatabaseManager(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $ComposersTable composers = $ComposersTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $SubcategoriesTable subcategories = $SubcategoriesTable(this);
  late final $ScoresTable scores = $ScoresTable(this);
  late final $ScoreSubcategoriesTable scoreSubcategories =
      $ScoreSubcategoriesTable(this);
  late final Index scoreTitle = Index(
    'score_title',
    'CREATE INDEX score_title ON scores (title)',
  );
  late final ScoresDao scoresDao = ScoresDao(this as LibraryDatabase);
  late final ScoreSubcategoriesDao scoreSubcategoriesDao =
      ScoreSubcategoriesDao(this as LibraryDatabase);
  late final CategoryDao categoryDao = CategoryDao(this as LibraryDatabase);
  late final SessionDao sessionDao = SessionDao(this as LibraryDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sessions,
    composers,
    categories,
    subcategories,
    scores,
    scoreSubcategories,
    scoreTitle,
  ];
}

typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      required String libraryName,
      required String userId,
      required String sheetId,
      Value<String?> driveFolderId,
      Value<bool> isAdmin,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<String> libraryName,
      Value<String> userId,
      Value<String> sheetId,
      Value<String?> driveFolderId,
      Value<bool> isAdmin,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$SessionsTableFilterComposer
    extends Composer<_$LibraryDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get libraryName => $composableBuilder(
    column: $table.libraryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sheetId => $composableBuilder(
    column: $table.sheetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driveFolderId => $composableBuilder(
    column: $table.driveFolderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAdmin => $composableBuilder(
    column: $table.isAdmin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionsTableOrderingComposer
    extends Composer<_$LibraryDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get libraryName => $composableBuilder(
    column: $table.libraryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sheetId => $composableBuilder(
    column: $table.sheetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driveFolderId => $composableBuilder(
    column: $table.driveFolderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAdmin => $composableBuilder(
    column: $table.isAdmin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$LibraryDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get libraryName => $composableBuilder(
    column: $table.libraryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get sheetId =>
      $composableBuilder(column: $table.sheetId, builder: (column) => column);

  GeneratedColumn<String> get driveFolderId => $composableBuilder(
    column: $table.driveFolderId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAdmin =>
      $composableBuilder(column: $table.isAdmin, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$LibraryDatabase,
          $SessionsTable,
          UserSessionData,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (
            UserSessionData,
            BaseReferences<_$LibraryDatabase, $SessionsTable, UserSessionData>,
          ),
          UserSessionData,
          PrefetchHooks Function()
        > {
  $$SessionsTableTableManager(_$LibraryDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> libraryName = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> sheetId = const Value.absent(),
                Value<String?> driveFolderId = const Value.absent(),
                Value<bool> isAdmin = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                libraryName: libraryName,
                userId: userId,
                sheetId: sheetId,
                driveFolderId: driveFolderId,
                isAdmin: isAdmin,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String libraryName,
                required String userId,
                required String sheetId,
                Value<String?> driveFolderId = const Value.absent(),
                Value<bool> isAdmin = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                libraryName: libraryName,
                userId: userId,
                sheetId: sheetId,
                driveFolderId: driveFolderId,
                isAdmin: isAdmin,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LibraryDatabase,
      $SessionsTable,
      UserSessionData,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (
        UserSessionData,
        BaseReferences<_$LibraryDatabase, $SessionsTable, UserSessionData>,
      ),
      UserSessionData,
      PrefetchHooks Function()
    >;
typedef $$ComposersTableCreateCompanionBuilder =
    ComposersCompanion Function({Value<int> id, required String name});
typedef $$ComposersTableUpdateCompanionBuilder =
    ComposersCompanion Function({Value<int> id, Value<String> name});

final class $$ComposersTableReferences
    extends BaseReferences<_$LibraryDatabase, $ComposersTable, ComposerData> {
  $$ComposersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ScoresTable, List<ScoreData>> _scoresRefsTable(
    _$LibraryDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.scores,
    aliasName: $_aliasNameGenerator(db.composers.id, db.scores.composerId),
  );

  $$ScoresTableProcessedTableManager get scoresRefs {
    final manager = $$ScoresTableTableManager(
      $_db,
      $_db.scores,
    ).filter((f) => f.composerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_scoresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ComposersTableFilterComposer
    extends Composer<_$LibraryDatabase, $ComposersTable> {
  $$ComposersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> scoresRefs(
    Expression<bool> Function($$ScoresTableFilterComposer f) f,
  ) {
    final $$ScoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scores,
      getReferencedColumn: (t) => t.composerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScoresTableFilterComposer(
            $db: $db,
            $table: $db.scores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ComposersTableOrderingComposer
    extends Composer<_$LibraryDatabase, $ComposersTable> {
  $$ComposersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ComposersTableAnnotationComposer
    extends Composer<_$LibraryDatabase, $ComposersTable> {
  $$ComposersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> scoresRefs<T extends Object>(
    Expression<T> Function($$ScoresTableAnnotationComposer a) f,
  ) {
    final $$ScoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scores,
      getReferencedColumn: (t) => t.composerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScoresTableAnnotationComposer(
            $db: $db,
            $table: $db.scores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ComposersTableTableManager
    extends
        RootTableManager<
          _$LibraryDatabase,
          $ComposersTable,
          ComposerData,
          $$ComposersTableFilterComposer,
          $$ComposersTableOrderingComposer,
          $$ComposersTableAnnotationComposer,
          $$ComposersTableCreateCompanionBuilder,
          $$ComposersTableUpdateCompanionBuilder,
          (ComposerData, $$ComposersTableReferences),
          ComposerData,
          PrefetchHooks Function({bool scoresRefs})
        > {
  $$ComposersTableTableManager(_$LibraryDatabase db, $ComposersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ComposersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ComposersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ComposersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => ComposersCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  ComposersCompanion.insert(id: id, name: name),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ComposersTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({scoresRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (scoresRefs) db.scores],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (scoresRefs)
                    await $_getPrefetchedData<
                      ComposerData,
                      $ComposersTable,
                      ScoreData
                    >(
                      currentTable: table,
                      referencedTable: $$ComposersTableReferences
                          ._scoresRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ComposersTableReferences(
                                db,
                                table,
                                p0,
                              ).scoresRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.composerId == item.id,
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

typedef $$ComposersTableProcessedTableManager =
    ProcessedTableManager<
      _$LibraryDatabase,
      $ComposersTable,
      ComposerData,
      $$ComposersTableFilterComposer,
      $$ComposersTableOrderingComposer,
      $$ComposersTableAnnotationComposer,
      $$ComposersTableCreateCompanionBuilder,
      $$ComposersTableUpdateCompanionBuilder,
      (ComposerData, $$ComposersTableReferences),
      ComposerData,
      PrefetchHooks Function({bool scoresRefs})
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      required String identifier,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> identifier,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$LibraryDatabase, $CategoriesTable, CategoryData> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SubcategoriesTable, List<SubcategoryData>>
  _subcategoriesRefsTable(_$LibraryDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.subcategories,
        aliasName: $_aliasNameGenerator(
          db.categories.id,
          db.subcategories.categoryId,
        ),
      );

  $$SubcategoriesTableProcessedTableManager get subcategoriesRefs {
    final manager = $$SubcategoriesTableTableManager(
      $_db,
      $_db.subcategories,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_subcategoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ScoresTable, List<ScoreData>> _scoresRefsTable(
    _$LibraryDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.scores,
    aliasName: $_aliasNameGenerator(db.categories.id, db.scores.categoryId),
  );

  $$ScoresTableProcessedTableManager get scoresRefs {
    final manager = $$ScoresTableTableManager(
      $_db,
      $_db.scores,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_scoresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$LibraryDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> subcategoriesRefs(
    Expression<bool> Function($$SubcategoriesTableFilterComposer f) f,
  ) {
    final $$SubcategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subcategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubcategoriesTableFilterComposer(
            $db: $db,
            $table: $db.subcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> scoresRefs(
    Expression<bool> Function($$ScoresTableFilterComposer f) f,
  ) {
    final $$ScoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scores,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScoresTableFilterComposer(
            $db: $db,
            $table: $db.scores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$LibraryDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$LibraryDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => column,
  );

  Expression<T> subcategoriesRefs<T extends Object>(
    Expression<T> Function($$SubcategoriesTableAnnotationComposer a) f,
  ) {
    final $$SubcategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subcategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubcategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.subcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> scoresRefs<T extends Object>(
    Expression<T> Function($$ScoresTableAnnotationComposer a) f,
  ) {
    final $$ScoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scores,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScoresTableAnnotationComposer(
            $db: $db,
            $table: $db.scores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$LibraryDatabase,
          $CategoriesTable,
          CategoryData,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryData, $$CategoriesTableReferences),
          CategoryData,
          PrefetchHooks Function({bool subcategoriesRefs, bool scoresRefs})
        > {
  $$CategoriesTableTableManager(_$LibraryDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> identifier = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                identifier: identifier,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String identifier,
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                identifier: identifier,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$CategoriesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            subcategoriesRefs = false,
            scoresRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (subcategoriesRefs) db.subcategories,
                if (scoresRefs) db.scores,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (subcategoriesRefs)
                    await $_getPrefetchedData<
                      CategoryData,
                      $CategoriesTable,
                      SubcategoryData
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._subcategoriesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).subcategoriesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.categoryId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (scoresRefs)
                    await $_getPrefetchedData<
                      CategoryData,
                      $CategoriesTable,
                      ScoreData
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._scoresRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).scoresRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.categoryId == item.id,
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

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$LibraryDatabase,
      $CategoriesTable,
      CategoryData,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryData, $$CategoriesTableReferences),
      CategoryData,
      PrefetchHooks Function({bool subcategoriesRefs, bool scoresRefs})
    >;
typedef $$SubcategoriesTableCreateCompanionBuilder =
    SubcategoriesCompanion Function({
      Value<int> id,
      required String name,
      required int categoryId,
    });
typedef $$SubcategoriesTableUpdateCompanionBuilder =
    SubcategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> categoryId,
    });

final class $$SubcategoriesTableReferences
    extends
        BaseReferences<
          _$LibraryDatabase,
          $SubcategoriesTable,
          SubcategoryData
        > {
  $$SubcategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$LibraryDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(db.subcategories.categoryId, db.categories.id),
      );

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ScoreSubcategoriesTable, List<ScoreSubcategory>>
  _scoreSubcategoriesRefsTable(_$LibraryDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.scoreSubcategories,
        aliasName: $_aliasNameGenerator(
          db.subcategories.id,
          db.scoreSubcategories.subcategoryId,
        ),
      );

  $$ScoreSubcategoriesTableProcessedTableManager get scoreSubcategoriesRefs {
    final manager = $$ScoreSubcategoriesTableTableManager(
      $_db,
      $_db.scoreSubcategories,
    ).filter((f) => f.subcategoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _scoreSubcategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubcategoriesTableFilterComposer
    extends Composer<_$LibraryDatabase, $SubcategoriesTable> {
  $$SubcategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> scoreSubcategoriesRefs(
    Expression<bool> Function($$ScoreSubcategoriesTableFilterComposer f) f,
  ) {
    final $$ScoreSubcategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scoreSubcategories,
      getReferencedColumn: (t) => t.subcategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScoreSubcategoriesTableFilterComposer(
            $db: $db,
            $table: $db.scoreSubcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubcategoriesTableOrderingComposer
    extends Composer<_$LibraryDatabase, $SubcategoriesTable> {
  $$SubcategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubcategoriesTableAnnotationComposer
    extends Composer<_$LibraryDatabase, $SubcategoriesTable> {
  $$SubcategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> scoreSubcategoriesRefs<T extends Object>(
    Expression<T> Function($$ScoreSubcategoriesTableAnnotationComposer a) f,
  ) {
    final $$ScoreSubcategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.scoreSubcategories,
          getReferencedColumn: (t) => t.subcategoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ScoreSubcategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.scoreSubcategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SubcategoriesTableTableManager
    extends
        RootTableManager<
          _$LibraryDatabase,
          $SubcategoriesTable,
          SubcategoryData,
          $$SubcategoriesTableFilterComposer,
          $$SubcategoriesTableOrderingComposer,
          $$SubcategoriesTableAnnotationComposer,
          $$SubcategoriesTableCreateCompanionBuilder,
          $$SubcategoriesTableUpdateCompanionBuilder,
          (SubcategoryData, $$SubcategoriesTableReferences),
          SubcategoryData,
          PrefetchHooks Function({bool categoryId, bool scoreSubcategoriesRefs})
        > {
  $$SubcategoriesTableTableManager(
    _$LibraryDatabase db,
    $SubcategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SubcategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$SubcategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SubcategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
              }) => SubcategoriesCompanion(
                id: id,
                name: name,
                categoryId: categoryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int categoryId,
              }) => SubcategoriesCompanion.insert(
                id: id,
                name: name,
                categoryId: categoryId,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SubcategoriesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            categoryId = false,
            scoreSubcategoriesRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (scoreSubcategoriesRefs) db.scoreSubcategories,
              ],
              addJoins: <
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
                if (categoryId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$SubcategoriesTableReferences
                                ._categoryIdTable(db),
                            referencedColumn:
                                $$SubcategoriesTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (scoreSubcategoriesRefs)
                    await $_getPrefetchedData<
                      SubcategoryData,
                      $SubcategoriesTable,
                      ScoreSubcategory
                    >(
                      currentTable: table,
                      referencedTable: $$SubcategoriesTableReferences
                          ._scoreSubcategoriesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$SubcategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).scoreSubcategoriesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.subcategoryId == item.id,
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

typedef $$SubcategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$LibraryDatabase,
      $SubcategoriesTable,
      SubcategoryData,
      $$SubcategoriesTableFilterComposer,
      $$SubcategoriesTableOrderingComposer,
      $$SubcategoriesTableAnnotationComposer,
      $$SubcategoriesTableCreateCompanionBuilder,
      $$SubcategoriesTableUpdateCompanionBuilder,
      (SubcategoryData, $$SubcategoriesTableReferences),
      SubcategoryData,
      PrefetchHooks Function({bool categoryId, bool scoreSubcategoriesRefs})
    >;
typedef $$ScoresTableCreateCompanionBuilder =
    ScoresCompanion Function({
      Value<int> id,
      required String title,
      required int composerId,
      Value<String> arranger,
      required String catalogNumber,
      Value<String> notes,
      required int categoryId,
      required String status,
      Value<String?> link,
      Value<DateTime> changeTime,
    });
typedef $$ScoresTableUpdateCompanionBuilder =
    ScoresCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int> composerId,
      Value<String> arranger,
      Value<String> catalogNumber,
      Value<String> notes,
      Value<int> categoryId,
      Value<String> status,
      Value<String?> link,
      Value<DateTime> changeTime,
    });

final class $$ScoresTableReferences
    extends BaseReferences<_$LibraryDatabase, $ScoresTable, ScoreData> {
  $$ScoresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ComposersTable _composerIdTable(_$LibraryDatabase db) => db.composers
      .createAlias($_aliasNameGenerator(db.scores.composerId, db.composers.id));

  $$ComposersTableProcessedTableManager get composerId {
    final $_column = $_itemColumn<int>('composer_id')!;

    final manager = $$ComposersTableTableManager(
      $_db,
      $_db.composers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_composerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$LibraryDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(db.scores.categoryId, db.categories.id),
      );

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ScoreSubcategoriesTable, List<ScoreSubcategory>>
  _scoreSubcategoriesRefsTable(_$LibraryDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.scoreSubcategories,
        aliasName: $_aliasNameGenerator(
          db.scores.id,
          db.scoreSubcategories.scoreId,
        ),
      );

  $$ScoreSubcategoriesTableProcessedTableManager get scoreSubcategoriesRefs {
    final manager = $$ScoreSubcategoriesTableTableManager(
      $_db,
      $_db.scoreSubcategories,
    ).filter((f) => f.scoreId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _scoreSubcategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ScoresTableFilterComposer
    extends Composer<_$LibraryDatabase, $ScoresTable> {
  $$ScoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arranger => $composableBuilder(
    column: $table.arranger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogNumber => $composableBuilder(
    column: $table.catalogNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get changeTime => $composableBuilder(
    column: $table.changeTime,
    builder: (column) => ColumnFilters(column),
  );

  $$ComposersTableFilterComposer get composerId {
    final $$ComposersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.composerId,
      referencedTable: $db.composers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComposersTableFilterComposer(
            $db: $db,
            $table: $db.composers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> scoreSubcategoriesRefs(
    Expression<bool> Function($$ScoreSubcategoriesTableFilterComposer f) f,
  ) {
    final $$ScoreSubcategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scoreSubcategories,
      getReferencedColumn: (t) => t.scoreId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScoreSubcategoriesTableFilterComposer(
            $db: $db,
            $table: $db.scoreSubcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScoresTableOrderingComposer
    extends Composer<_$LibraryDatabase, $ScoresTable> {
  $$ScoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arranger => $composableBuilder(
    column: $table.arranger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogNumber => $composableBuilder(
    column: $table.catalogNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get changeTime => $composableBuilder(
    column: $table.changeTime,
    builder: (column) => ColumnOrderings(column),
  );

  $$ComposersTableOrderingComposer get composerId {
    final $$ComposersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.composerId,
      referencedTable: $db.composers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComposersTableOrderingComposer(
            $db: $db,
            $table: $db.composers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScoresTableAnnotationComposer
    extends Composer<_$LibraryDatabase, $ScoresTable> {
  $$ScoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get arranger =>
      $composableBuilder(column: $table.arranger, builder: (column) => column);

  GeneratedColumn<String> get catalogNumber => $composableBuilder(
    column: $table.catalogNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get link =>
      $composableBuilder(column: $table.link, builder: (column) => column);

  GeneratedColumn<DateTime> get changeTime => $composableBuilder(
    column: $table.changeTime,
    builder: (column) => column,
  );

  $$ComposersTableAnnotationComposer get composerId {
    final $$ComposersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.composerId,
      referencedTable: $db.composers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComposersTableAnnotationComposer(
            $db: $db,
            $table: $db.composers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> scoreSubcategoriesRefs<T extends Object>(
    Expression<T> Function($$ScoreSubcategoriesTableAnnotationComposer a) f,
  ) {
    final $$ScoreSubcategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.scoreSubcategories,
          getReferencedColumn: (t) => t.scoreId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ScoreSubcategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.scoreSubcategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ScoresTableTableManager
    extends
        RootTableManager<
          _$LibraryDatabase,
          $ScoresTable,
          ScoreData,
          $$ScoresTableFilterComposer,
          $$ScoresTableOrderingComposer,
          $$ScoresTableAnnotationComposer,
          $$ScoresTableCreateCompanionBuilder,
          $$ScoresTableUpdateCompanionBuilder,
          (ScoreData, $$ScoresTableReferences),
          ScoreData,
          PrefetchHooks Function({
            bool composerId,
            bool categoryId,
            bool scoreSubcategoriesRefs,
          })
        > {
  $$ScoresTableTableManager(_$LibraryDatabase db, $ScoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ScoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ScoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ScoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> composerId = const Value.absent(),
                Value<String> arranger = const Value.absent(),
                Value<String> catalogNumber = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> link = const Value.absent(),
                Value<DateTime> changeTime = const Value.absent(),
              }) => ScoresCompanion(
                id: id,
                title: title,
                composerId: composerId,
                arranger: arranger,
                catalogNumber: catalogNumber,
                notes: notes,
                categoryId: categoryId,
                status: status,
                link: link,
                changeTime: changeTime,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required int composerId,
                Value<String> arranger = const Value.absent(),
                required String catalogNumber,
                Value<String> notes = const Value.absent(),
                required int categoryId,
                required String status,
                Value<String?> link = const Value.absent(),
                Value<DateTime> changeTime = const Value.absent(),
              }) => ScoresCompanion.insert(
                id: id,
                title: title,
                composerId: composerId,
                arranger: arranger,
                catalogNumber: catalogNumber,
                notes: notes,
                categoryId: categoryId,
                status: status,
                link: link,
                changeTime: changeTime,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ScoresTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            composerId = false,
            categoryId = false,
            scoreSubcategoriesRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (scoreSubcategoriesRefs) db.scoreSubcategories,
              ],
              addJoins: <
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
                if (composerId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.composerId,
                            referencedTable: $$ScoresTableReferences
                                ._composerIdTable(db),
                            referencedColumn:
                                $$ScoresTableReferences._composerIdTable(db).id,
                          )
                          as T;
                }
                if (categoryId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$ScoresTableReferences
                                ._categoryIdTable(db),
                            referencedColumn:
                                $$ScoresTableReferences._categoryIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (scoreSubcategoriesRefs)
                    await $_getPrefetchedData<
                      ScoreData,
                      $ScoresTable,
                      ScoreSubcategory
                    >(
                      currentTable: table,
                      referencedTable: $$ScoresTableReferences
                          ._scoreSubcategoriesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ScoresTableReferences(
                                db,
                                table,
                                p0,
                              ).scoreSubcategoriesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.scoreId == item.id,
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

typedef $$ScoresTableProcessedTableManager =
    ProcessedTableManager<
      _$LibraryDatabase,
      $ScoresTable,
      ScoreData,
      $$ScoresTableFilterComposer,
      $$ScoresTableOrderingComposer,
      $$ScoresTableAnnotationComposer,
      $$ScoresTableCreateCompanionBuilder,
      $$ScoresTableUpdateCompanionBuilder,
      (ScoreData, $$ScoresTableReferences),
      ScoreData,
      PrefetchHooks Function({
        bool composerId,
        bool categoryId,
        bool scoreSubcategoriesRefs,
      })
    >;
typedef $$ScoreSubcategoriesTableCreateCompanionBuilder =
    ScoreSubcategoriesCompanion Function({
      required int scoreId,
      required int subcategoryId,
      Value<int> rowid,
    });
typedef $$ScoreSubcategoriesTableUpdateCompanionBuilder =
    ScoreSubcategoriesCompanion Function({
      Value<int> scoreId,
      Value<int> subcategoryId,
      Value<int> rowid,
    });

final class $$ScoreSubcategoriesTableReferences
    extends
        BaseReferences<
          _$LibraryDatabase,
          $ScoreSubcategoriesTable,
          ScoreSubcategory
        > {
  $$ScoreSubcategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ScoresTable _scoreIdTable(_$LibraryDatabase db) =>
      db.scores.createAlias(
        $_aliasNameGenerator(db.scoreSubcategories.scoreId, db.scores.id),
      );

  $$ScoresTableProcessedTableManager get scoreId {
    final $_column = $_itemColumn<int>('score_id')!;

    final manager = $$ScoresTableTableManager(
      $_db,
      $_db.scores,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scoreIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SubcategoriesTable _subcategoryIdTable(_$LibraryDatabase db) =>
      db.subcategories.createAlias(
        $_aliasNameGenerator(
          db.scoreSubcategories.subcategoryId,
          db.subcategories.id,
        ),
      );

  $$SubcategoriesTableProcessedTableManager get subcategoryId {
    final $_column = $_itemColumn<int>('subcategory_id')!;

    final manager = $$SubcategoriesTableTableManager(
      $_db,
      $_db.subcategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subcategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScoreSubcategoriesTableFilterComposer
    extends Composer<_$LibraryDatabase, $ScoreSubcategoriesTable> {
  $$ScoreSubcategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ScoresTableFilterComposer get scoreId {
    final $$ScoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scoreId,
      referencedTable: $db.scores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScoresTableFilterComposer(
            $db: $db,
            $table: $db.scores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubcategoriesTableFilterComposer get subcategoryId {
    final $$SubcategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subcategoryId,
      referencedTable: $db.subcategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubcategoriesTableFilterComposer(
            $db: $db,
            $table: $db.subcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScoreSubcategoriesTableOrderingComposer
    extends Composer<_$LibraryDatabase, $ScoreSubcategoriesTable> {
  $$ScoreSubcategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ScoresTableOrderingComposer get scoreId {
    final $$ScoresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scoreId,
      referencedTable: $db.scores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScoresTableOrderingComposer(
            $db: $db,
            $table: $db.scores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubcategoriesTableOrderingComposer get subcategoryId {
    final $$SubcategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subcategoryId,
      referencedTable: $db.subcategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubcategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.subcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScoreSubcategoriesTableAnnotationComposer
    extends Composer<_$LibraryDatabase, $ScoreSubcategoriesTable> {
  $$ScoreSubcategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ScoresTableAnnotationComposer get scoreId {
    final $$ScoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scoreId,
      referencedTable: $db.scores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScoresTableAnnotationComposer(
            $db: $db,
            $table: $db.scores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubcategoriesTableAnnotationComposer get subcategoryId {
    final $$SubcategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subcategoryId,
      referencedTable: $db.subcategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubcategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.subcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScoreSubcategoriesTableTableManager
    extends
        RootTableManager<
          _$LibraryDatabase,
          $ScoreSubcategoriesTable,
          ScoreSubcategory,
          $$ScoreSubcategoriesTableFilterComposer,
          $$ScoreSubcategoriesTableOrderingComposer,
          $$ScoreSubcategoriesTableAnnotationComposer,
          $$ScoreSubcategoriesTableCreateCompanionBuilder,
          $$ScoreSubcategoriesTableUpdateCompanionBuilder,
          (ScoreSubcategory, $$ScoreSubcategoriesTableReferences),
          ScoreSubcategory,
          PrefetchHooks Function({bool scoreId, bool subcategoryId})
        > {
  $$ScoreSubcategoriesTableTableManager(
    _$LibraryDatabase db,
    $ScoreSubcategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ScoreSubcategoriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$ScoreSubcategoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ScoreSubcategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> scoreId = const Value.absent(),
                Value<int> subcategoryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScoreSubcategoriesCompanion(
                scoreId: scoreId,
                subcategoryId: subcategoryId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int scoreId,
                required int subcategoryId,
                Value<int> rowid = const Value.absent(),
              }) => ScoreSubcategoriesCompanion.insert(
                scoreId: scoreId,
                subcategoryId: subcategoryId,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ScoreSubcategoriesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({scoreId = false, subcategoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (scoreId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.scoreId,
                            referencedTable: $$ScoreSubcategoriesTableReferences
                                ._scoreIdTable(db),
                            referencedColumn:
                                $$ScoreSubcategoriesTableReferences
                                    ._scoreIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (subcategoryId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.subcategoryId,
                            referencedTable: $$ScoreSubcategoriesTableReferences
                                ._subcategoryIdTable(db),
                            referencedColumn:
                                $$ScoreSubcategoriesTableReferences
                                    ._subcategoryIdTable(db)
                                    .id,
                          )
                          as T;
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

typedef $$ScoreSubcategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$LibraryDatabase,
      $ScoreSubcategoriesTable,
      ScoreSubcategory,
      $$ScoreSubcategoriesTableFilterComposer,
      $$ScoreSubcategoriesTableOrderingComposer,
      $$ScoreSubcategoriesTableAnnotationComposer,
      $$ScoreSubcategoriesTableCreateCompanionBuilder,
      $$ScoreSubcategoriesTableUpdateCompanionBuilder,
      (ScoreSubcategory, $$ScoreSubcategoriesTableReferences),
      ScoreSubcategory,
      PrefetchHooks Function({bool scoreId, bool subcategoryId})
    >;

class $LibraryDatabaseManager {
  final _$LibraryDatabase _db;
  $LibraryDatabaseManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$ComposersTableTableManager get composers =>
      $$ComposersTableTableManager(_db, _db.composers);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$SubcategoriesTableTableManager get subcategories =>
      $$SubcategoriesTableTableManager(_db, _db.subcategories);
  $$ScoresTableTableManager get scores =>
      $$ScoresTableTableManager(_db, _db.scores);
  $$ScoreSubcategoriesTableTableManager get scoreSubcategories =>
      $$ScoreSubcategoriesTableTableManager(_db, _db.scoreSubcategories);
}
