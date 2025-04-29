import 'package:get_it/get_it.dart';
import 'package:kinder/api/cat_api.dart';
import 'package:kinder/data/datasources/local_database.dart';
import 'package:kinder/data/liked_cats_repository.dart';
import 'package:kinder/domain/cubits/liked_cats_cubit.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton(() => CatApi());
  getIt.registerLazySingleton(() => AppDatabase());
  getIt.registerLazySingleton(() => LikedCatsRepository(getIt<AppDatabase>()));
  getIt.registerFactory(() => LikedCatsCubit(getIt<LikedCatsRepository>()));
}
