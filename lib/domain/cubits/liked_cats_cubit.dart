import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder/data/liked_cats_repository.dart';
import 'package:kinder/domain/models/liked_cat.dart';

part 'liked_cats_state.dart';

class LikedCatsCubit extends Cubit<LikedCatsState> {
  final LikedCatsRepository _repository;

  LikedCatsCubit(this._repository) : super(LikedCatsState.initial());

  Future<void> loadLikedCats() async {
    final likedCats = await _repository.getLikedCats();
    emit(state.copyWith(likedCats: likedCats, filteredCats: likedCats));
  }

  void addLikedCat(LikedCat cat) async {
    await _repository.addLikedCat(cat);
    final likedCats = await _repository.getLikedCats();
    emit(
      state.copyWith(
        likedCats: likedCats,
        filteredCats:
            state.selectedBreed == null
                ? likedCats
                : likedCats
                    .where((c) => c.breed == state.selectedBreed)
                    .toList(),
      ),
    );
  }

  void removeLikedCat(String catId) async {
    await _repository.removeLikedCat(catId);
    final likedCats = await _repository.getLikedCats();
    emit(
      state.copyWith(
        likedCats: likedCats,
        filteredCats:
            state.selectedBreed == null
                ? likedCats
                : likedCats
                    .where((c) => c.breed == state.selectedBreed)
                    .toList(),
      ),
    );
  }

  void filterCats(String query) {
    if (query.isEmpty) {
      emit(
        state.copyWith(
          filteredCats:
              state.selectedBreed == null
                  ? state.likedCats
                  : state.likedCats
                      .where((c) => c.breed == state.selectedBreed)
                      .toList(),
        ),
      );
    } else {
      final filteredCats =
          state.likedCats.where((cat) {
            return cat.breed.toLowerCase().contains(query.toLowerCase()) ||
                cat.description.toLowerCase().contains(query.toLowerCase());
          }).toList();
      emit(state.copyWith(filteredCats: filteredCats));
    }
  }

  void filterByBreed(String? breed) {
    emit(
      state.copyWith(
        selectedBreed: breed,
        filteredCats:
            breed == null
                ? state.likedCats
                : state.likedCats.where((cat) => cat.breed == breed).toList(),
      ),
    );
  }
}
