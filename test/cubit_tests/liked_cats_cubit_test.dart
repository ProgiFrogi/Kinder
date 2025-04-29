import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kinder/data/liked_cats_repository.dart';
import 'package:kinder/domain/cubits/liked_cats_cubit.dart';
import 'package:kinder/domain/models/liked_cat.dart';
import 'liked_cats_cubit_test.mocks.dart';

@GenerateMocks([LikedCatsRepository])
void main() {
  late MockLikedCatsRepository mockRepository;
  late LikedCatsCubit cubit;

  setUp(() {
    mockRepository = MockLikedCatsRepository();
    cubit = LikedCatsCubit(mockRepository);
  });

  test('loadLikedCats updates state with liked cats', () async {
    final cats = [
      LikedCat(
        id: '1',
        url: 'url1',
        breed: 'Persian',
        description: 'Fluffy cat',
        likedAt: DateTime.now(),
      ),
    ];
    when(mockRepository.getLikedCats()).thenAnswer((_) async => cats);

    cubit.loadLikedCats();

    expect(cubit.state.likedCats, cats);
    expect(cubit.state.filteredCats, cats);
  });

  test('addLikedCat adds cat and updates state', () async {
    final cat = LikedCat(
      id: '1',
      url: 'url1',
      breed: 'Persian',
      description: 'Fluffy cat',
      likedAt: DateTime.now(),
    );
    when(mockRepository.getLikedCats()).thenAnswer((_) async => [cat]);

    cubit.addLikedCat(cat);

    verify(mockRepository.addLikedCat(cat)).called(1);
    expect(cubit.state.likedCats, [cat]);
  });

  test('removeLikedCat removes cat and updates state', () async {
    final cat = LikedCat(
      id: '1',
      url: 'url1',
      breed: 'Persian',
      description: 'Fluffy cat',
      likedAt: DateTime.now(),
    );
    when(mockRepository.getLikedCats()).thenAnswer((_) async => []);

    cubit.removeLikedCat(cat.id);

    verify(mockRepository.removeLikedCat(cat.id)).called(1);
    expect(cubit.state.likedCats, []);
  });

  test('filterByBreed filters cats by breed', () async {
    final cats = [
      LikedCat(
        id: '1',
        url: 'url1',
        breed: 'Persian',
        description: 'Fluffy cat',
        likedAt: DateTime.now(),
      ),
      LikedCat(
        id: '2',
        url: 'url2',
        breed: 'Siamese',
        description: 'Sleek cat',
        likedAt: DateTime.now(),
      ),
    ];
    when(mockRepository.getLikedCats()).thenAnswer((_) async => cats);

    cubit.loadLikedCats();
    cubit.filterByBreed('Persian');

    expect(cubit.state.filteredCats.length, 1);
    expect(cubit.state.filteredCats[0].breed, 'Persian');
  });
}
