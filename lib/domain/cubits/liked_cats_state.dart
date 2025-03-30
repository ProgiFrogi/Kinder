import 'package:equatable/equatable.dart';
import 'package:kinder/domain/models/liked_cat.dart';

class LikedCatsState extends Equatable {
  final List<LikedCat> likedCats;
  final List<LikedCat> filteredCats;
  final String? selectedBreed;

  const LikedCatsState({
    required this.likedCats,
    required this.filteredCats,
    this.selectedBreed,
  });

  factory LikedCatsState.initial() => const LikedCatsState(
    likedCats: [],
    filteredCats: [],
    selectedBreed: null,
  );

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

  @override
  List<Object?> get props => [likedCats, filteredCats, selectedBreed];
}
