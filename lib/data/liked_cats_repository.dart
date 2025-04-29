import 'package:kinder/data/datasources/local_database.dart';
import 'package:kinder/domain/models/liked_cat.dart';

class LikedCatsRepository {
  final AppDatabase _database;

  LikedCatsRepository(this._database);

  Future<List<LikedCat>> getLikedCats() async {
    final cats = await _database.getAllCats();
    final likedCats =
        cats
            .where((cat) => cat.isLiked)
            .map(
              (cat) => LikedCat(
                id: cat.id,
                url: cat.url,
                breed: cat.breed,
                description: cat.description,
                likedAt: cat.likedAt ?? DateTime.now(),
              ),
            )
            .toList();
    return likedCats;
  }

  Future<void> addLikedCat(LikedCat cat) async {
    await _database.upsertCat(
      Cat(
        id: cat.id,
        url: cat.url,
        breed: cat.breed,
        description: cat.description,
        isLiked: true,
        isDisliked: false,
        likedAt: cat.likedAt,
      ),
    );
    await _database.updateLikeStatus(cat.id, true, cat.likedAt);
  }

  Future<void> removeLikedCat(String catId) async {
    await _database.updateLikeStatus(catId, false, null);
  }

  Future<void> addDislikedCat(LikedCat cat) async {
    await _database.upsertCat(
      Cat(
        id: cat.id,
        url: cat.url,
        breed: cat.breed,
        description: cat.description,
        isLiked: false,
        isDisliked: true,
        likedAt: null,
      ),
    );
    await _database.updateDislikeStatus(cat.id, true);
  }

  Future<List<Cat>> getAllCats() async {
    final cats = await _database.getAllCats();
    return cats;
  }

  Future<void> upsertCat(Cat cat) async {
    await _database.upsertCat(cat);
  }
}
