import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
import 'features/movies/data/datasources/movie_local_datasource.dart';
import 'features/movies/data/datasources/movie_remote_datasource.dart';
import 'features/movies/data/repositories/movie_repo_impl.dart';
import 'features/movies/domain/repositories/movie_repository.dart';
import 'features/movies/domain/usecases/get_genres.dart';
import 'features/movies/domain/usecases/get_movies_by_genre.dart';
import 'features/movies/domain/usecases/get_popular_movies.dart';
import 'features/movies/domain/usecases/search_movies.dart';
import 'features/movies/presentation/stores/movie_list_store.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==================== Features - Movies ====================

  // Stores
  sl.registerFactory(
    () => MovieListStore(
      getPopularMovies: sl(),
      getGenres: sl(),
      getMoviesByGenre: sl(),
      searchMovies: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetPopularMovies(sl()));
  sl.registerLazySingleton(() => GetGenres(sl()));
  sl.registerLazySingleton(() => GetMoviesByGenre(sl()));
  sl.registerLazySingleton(() => SearchMovies(sl()));

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(),
  );

  // ==================== Core ====================

  // Network
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // API Client
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton(() => sl<ApiClient>().dio);

  // ==================== External ====================

  // Internet Connection Checker
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  // Hive (inicializar)
  await Hive.initFlutter();
}
