import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder/data/liked_cats_repository.dart';
import 'package:kinder/domain/models/liked_cat.dart';
import 'liked_cats_state.dart';

class LikedCatsCubit extends Cubit<LikedCatsState> {
  final LikedCatsRepository repository;

  LikedCatsCubit(this.repository) : super(LikedCatsState.initial());

  void loadLikedCats() {
    emit(
      LikedCatsState(
        likedCats: repository.getLikedCats(),
        filteredCats: repository.getLikedCats(),
        selectedBreed: null,
      ),
    );
  }

  void addLikedCat(LikedCat cat) {
    repository.addLikedCat(cat);
    loadLikedCats();
  }

  void removeLikedCat(String catId) {
    repository.removeLikedCat(catId);
    loadLikedCats();
  }

  void filterByBreed(String? breed) {
    final allCats = repository.getLikedCats();
    if (breed == null || breed.isEmpty) {
      emit(state.copyWith(filteredCats: allCats, selectedBreed: null));
    } else {
      final filtered = allCats.where((cat) => cat.breed == breed).toList();
      emit(state.copyWith(filteredCats: filtered, selectedBreed: breed));
    }
  }
}
