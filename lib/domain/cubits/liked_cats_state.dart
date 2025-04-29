part of 'liked_cats_cubit.dart';

class LikedCatsState {
  final List<LikedCat> likedCats;
  final List<LikedCat> filteredCats;
  final String? selectedBreed;

  LikedCatsState({
    required this.likedCats,
    required this.filteredCats,
    this.selectedBreed,
  });

  factory LikedCatsState.initial() {
    return LikedCatsState(likedCats: [], filteredCats: [], selectedBreed: null);
  }

  LikedCatsState copyWith({
    List<LikedCat>? likedCats,
    List<LikedCat>? filteredCats,
    String? selectedBreed,
  }) {
    return LikedCatsState(
      likedCats: likedCats ?? this.likedCats,
      filteredCats: filteredCats ?? this.filteredCats,
      selectedBreed: selectedBreed ?? this.selectedBreed,
    );
  }
}
