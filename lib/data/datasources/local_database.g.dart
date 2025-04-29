// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $CatsTable extends Cats with TableInfo<$CatsTable, Cat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _breedMeta = const VerificationMeta('breed');
  @override
  late final GeneratedColumn<String> breed = GeneratedColumn<String>(
    'breed',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isLikedMeta = const VerificationMeta(
    'isLiked',
  );
  @override
  late final GeneratedColumn<bool> isLiked = GeneratedColumn<bool>(
    'is_liked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_liked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDislikedMeta = const VerificationMeta(
    'isDisliked',
  );
  @override
  late final GeneratedColumn<bool> isDisliked = GeneratedColumn<bool>(
    'is_disliked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_disliked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _likedAtMeta = const VerificationMeta(
    'likedAt',
  );
  @override
  late final GeneratedColumn<DateTime> likedAt = GeneratedColumn<DateTime>(
    'liked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    url,
    breed,
    description,
    isLiked,
    isDisliked,
    likedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cats';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('breed')) {
      context.handle(
        _breedMeta,
        breed.isAcceptableOrUnknown(data['breed']!, _breedMeta),
      );
    } else if (isInserting) {
      context.missing(_breedMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('is_liked')) {
      context.handle(
        _isLikedMeta,
        isLiked.isAcceptableOrUnknown(data['is_liked']!, _isLikedMeta),
      );
    }
    if (data.containsKey('is_disliked')) {
      context.handle(
        _isDislikedMeta,
        isDisliked.isAcceptableOrUnknown(data['is_disliked']!, _isDislikedMeta),
      );
    }
    if (data.containsKey('liked_at')) {
      context.handle(
        _likedAtMeta,
        likedAt.isAcceptableOrUnknown(data['liked_at']!, _likedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cat(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      url:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}url'],
          )!,
      breed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}breed'],
          )!,
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      isLiked:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_liked'],
          )!,
      isDisliked:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_disliked'],
          )!,
      likedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}liked_at'],
      ),
    );
  }

  @override
  $CatsTable createAlias(String alias) {
    return $CatsTable(attachedDatabase, alias);
  }
}

class Cat extends DataClass implements Insertable<Cat> {
  final String id;
  final String url;
  final String breed;
  final String description;
  final bool isLiked;
  final bool isDisliked;
  final DateTime? likedAt;
  const Cat({
    required this.id,
    required this.url,
    required this.breed,
    required this.description,
    required this.isLiked,
    required this.isDisliked,
    this.likedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['url'] = Variable<String>(url);
    map['breed'] = Variable<String>(breed);
    map['description'] = Variable<String>(description);
    map['is_liked'] = Variable<bool>(isLiked);
    map['is_disliked'] = Variable<bool>(isDisliked);
    if (!nullToAbsent || likedAt != null) {
      map['liked_at'] = Variable<DateTime>(likedAt);
    }
    return map;
  }

  CatsCompanion toCompanion(bool nullToAbsent) {
    return CatsCompanion(
      id: Value(id),
      url: Value(url),
      breed: Value(breed),
      description: Value(description),
      isLiked: Value(isLiked),
      isDisliked: Value(isDisliked),
      likedAt:
          likedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(likedAt),
    );
  }

  factory Cat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cat(
      id: serializer.fromJson<String>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      breed: serializer.fromJson<String>(json['breed']),
      description: serializer.fromJson<String>(json['description']),
      isLiked: serializer.fromJson<bool>(json['isLiked']),
      isDisliked: serializer.fromJson<bool>(json['isDisliked']),
      likedAt: serializer.fromJson<DateTime?>(json['likedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'url': serializer.toJson<String>(url),
      'breed': serializer.toJson<String>(breed),
      'description': serializer.toJson<String>(description),
      'isLiked': serializer.toJson<bool>(isLiked),
      'isDisliked': serializer.toJson<bool>(isDisliked),
      'likedAt': serializer.toJson<DateTime?>(likedAt),
    };
  }

  Cat copyWith({
    String? id,
    String? url,
    String? breed,
    String? description,
    bool? isLiked,
    bool? isDisliked,
    Value<DateTime?> likedAt = const Value.absent(),
  }) => Cat(
    id: id ?? this.id,
    url: url ?? this.url,
    breed: breed ?? this.breed,
    description: description ?? this.description,
    isLiked: isLiked ?? this.isLiked,
    isDisliked: isDisliked ?? this.isDisliked,
    likedAt: likedAt.present ? likedAt.value : this.likedAt,
  );
  Cat copyWithCompanion(CatsCompanion data) {
    return Cat(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      breed: data.breed.present ? data.breed.value : this.breed,
      description:
          data.description.present ? data.description.value : this.description,
      isLiked: data.isLiked.present ? data.isLiked.value : this.isLiked,
      isDisliked:
          data.isDisliked.present ? data.isDisliked.value : this.isDisliked,
      likedAt: data.likedAt.present ? data.likedAt.value : this.likedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cat(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('breed: $breed, ')
          ..write('description: $description, ')
          ..write('isLiked: $isLiked, ')
          ..write('isDisliked: $isDisliked, ')
          ..write('likedAt: $likedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, url, breed, description, isLiked, isDisliked, likedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cat &&
          other.id == this.id &&
          other.url == this.url &&
          other.breed == this.breed &&
          other.description == this.description &&
          other.isLiked == this.isLiked &&
          other.isDisliked == this.isDisliked &&
          other.likedAt == this.likedAt);
}

class CatsCompanion extends UpdateCompanion<Cat> {
  final Value<String> id;
  final Value<String> url;
  final Value<String> breed;
  final Value<String> description;
  final Value<bool> isLiked;
  final Value<bool> isDisliked;
  final Value<DateTime?> likedAt;
  final Value<int> rowid;
  const CatsCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.breed = const Value.absent(),
    this.description = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.isDisliked = const Value.absent(),
    this.likedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatsCompanion.insert({
    required String id,
    required String url,
    required String breed,
    required String description,
    this.isLiked = const Value.absent(),
    this.isDisliked = const Value.absent(),
    this.likedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       url = Value(url),
       breed = Value(breed),
       description = Value(description);
  static Insertable<Cat> custom({
    Expression<String>? id,
    Expression<String>? url,
    Expression<String>? breed,
    Expression<String>? description,
    Expression<bool>? isLiked,
    Expression<bool>? isDisliked,
    Expression<DateTime>? likedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (breed != null) 'breed': breed,
      if (description != null) 'description': description,
      if (isLiked != null) 'is_liked': isLiked,
      if (isDisliked != null) 'is_disliked': isDisliked,
      if (likedAt != null) 'liked_at': likedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatsCompanion copyWith({
    Value<String>? id,
    Value<String>? url,
    Value<String>? breed,
    Value<String>? description,
    Value<bool>? isLiked,
    Value<bool>? isDisliked,
    Value<DateTime?>? likedAt,
    Value<int>? rowid,
  }) {
    return CatsCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      breed: breed ?? this.breed,
      description: description ?? this.description,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
      likedAt: likedAt ?? this.likedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (breed.present) {
      map['breed'] = Variable<String>(breed.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isLiked.present) {
      map['is_liked'] = Variable<bool>(isLiked.value);
    }
    if (isDisliked.present) {
      map['is_disliked'] = Variable<bool>(isDisliked.value);
    }
    if (likedAt.present) {
      map['liked_at'] = Variable<DateTime>(likedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatsCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('breed: $breed, ')
          ..write('description: $description, ')
          ..write('isLiked: $isLiked, ')
          ..write('isDisliked: $isDisliked, ')
          ..write('likedAt: $likedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CatsTable cats = $CatsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cats];
}

typedef $$CatsTableCreateCompanionBuilder =
    CatsCompanion Function({
      required String id,
      required String url,
      required String breed,
      required String description,
      Value<bool> isLiked,
      Value<bool> isDisliked,
      Value<DateTime?> likedAt,
      Value<int> rowid,
    });
typedef $$CatsTableUpdateCompanionBuilder =
    CatsCompanion Function({
      Value<String> id,
      Value<String> url,
      Value<String> breed,
      Value<String> description,
      Value<bool> isLiked,
      Value<bool> isDisliked,
      Value<DateTime?> likedAt,
      Value<int> rowid,
    });

class $$CatsTableFilterComposer extends Composer<_$AppDatabase, $CatsTable> {
  $$CatsTableFilterComposer({
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

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get breed => $composableBuilder(
    column: $table.breed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLiked => $composableBuilder(
    column: $table.isLiked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDisliked => $composableBuilder(
    column: $table.isDisliked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get likedAt => $composableBuilder(
    column: $table.likedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatsTableOrderingComposer extends Composer<_$AppDatabase, $CatsTable> {
  $$CatsTableOrderingComposer({
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

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get breed => $composableBuilder(
    column: $table.breed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLiked => $composableBuilder(
    column: $table.isLiked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDisliked => $composableBuilder(
    column: $table.isDisliked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get likedAt => $composableBuilder(
    column: $table.likedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatsTable> {
  $$CatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get breed =>
      $composableBuilder(column: $table.breed, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLiked =>
      $composableBuilder(column: $table.isLiked, builder: (column) => column);

  GeneratedColumn<bool> get isDisliked => $composableBuilder(
    column: $table.isDisliked,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get likedAt =>
      $composableBuilder(column: $table.likedAt, builder: (column) => column);
}

class $$CatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatsTable,
          Cat,
          $$CatsTableFilterComposer,
          $$CatsTableOrderingComposer,
          $$CatsTableAnnotationComposer,
          $$CatsTableCreateCompanionBuilder,
          $$CatsTableUpdateCompanionBuilder,
          (Cat, BaseReferences<_$AppDatabase, $CatsTable, Cat>),
          Cat,
          PrefetchHooks Function()
        > {
  $$CatsTableTableManager(_$AppDatabase db, $CatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> breed = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<bool> isLiked = const Value.absent(),
                Value<bool> isDisliked = const Value.absent(),
                Value<DateTime?> likedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatsCompanion(
                id: id,
                url: url,
                breed: breed,
                description: description,
                isLiked: isLiked,
                isDisliked: isDisliked,
                likedAt: likedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String url,
                required String breed,
                required String description,
                Value<bool> isLiked = const Value.absent(),
                Value<bool> isDisliked = const Value.absent(),
                Value<DateTime?> likedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatsCompanion.insert(
                id: id,
                url: url,
                breed: breed,
                description: description,
                isLiked: isLiked,
                isDisliked: isDisliked,
                likedAt: likedAt,
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

typedef $$CatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatsTable,
      Cat,
      $$CatsTableFilterComposer,
      $$CatsTableOrderingComposer,
      $$CatsTableAnnotationComposer,
      $$CatsTableCreateCompanionBuilder,
      $$CatsTableUpdateCompanionBuilder,
      (Cat, BaseReferences<_$AppDatabase, $CatsTable, Cat>),
      Cat,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CatsTableTableManager get cats => $$CatsTableTableManager(_db, _db.cats);
}
