import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'local_database.g.dart';

@DataClassName('Cat')
class Cats extends Table {
  TextColumn get id => text()();
  TextColumn get url => text()();
  TextColumn get breed => text()();
  TextColumn get description => text()();
  BoolColumn get isLiked => boolean().withDefault(const Constant(false))();
  BoolColumn get isDisliked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get likedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Cats])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Cat>> getAllCats() => select(cats).get();

  Future<void> upsertCat(Cat cat) => into(cats).insertOnConflictUpdate(cat);

  Future<void> updateLikeStatus(String id, bool isLiked, DateTime? likedAt) =>
      (update(cats)..where(
        (t) => t.id.equals(id),
      )).write(CatsCompanion(isLiked: Value(isLiked), likedAt: Value(likedAt)));

  Future<void> updateDislikeStatus(String id, bool isDisliked) => (update(cats)
    ..where(
      (t) => t.id.equals(id),
    )).write(CatsCompanion(isDisliked: Value(isDisliked)));
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'cats.sqlite'));
    return NativeDatabase(file);
  });
}
