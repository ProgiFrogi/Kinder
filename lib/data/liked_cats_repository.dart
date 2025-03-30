import 'package:kinder/domain/models/liked_cat.dart';

class LikedCatsRepository {
  final List<LikedCat> _likedCats = [];

  List<LikedCat> getLikedCats() => List.unmodifiable(_likedCats);

  void addLikedCat(LikedCat cat) {
    _likedCats.add(cat);
  }

  void removeLikedCat(String catId) {
    _likedCats.removeWhere((cat) => cat.id == catId);
  }
}
