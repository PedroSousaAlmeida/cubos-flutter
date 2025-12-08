import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_local_datasource.dart';
import '../datasources/movie_remote_datasource.dart';

/// Implementação concreta do MovieRepository
///
/// Responsabilidades:
/// - Decidir se busca dados remotos ou locais
/// - Gerenciar cache
/// - Converter exceptions em failures
/// - Aplicar regra: "tente remoto, se falhar use cache"
class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    // Verifica se tem internet
    if (await networkInfo.isConnected) {
      try {
        // Tenta buscar da API
        final remoteMovies = await remoteDataSource.getPopularMovies();

        // Salva no cache para uso offline
        await localDataSource.cacheMovies(remoteMovies);

        return Right(remoteMovies);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      // Sem internet, tenta buscar do cache
      try {
        final localMovies = await localDataSource.getCachedMovies();
        return Right(localMovies);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetails(int movieId) async {
    if (await networkInfo.isConnected) {
      try {
        final movie = await remoteDataSource.getMovieDetails(movieId);
        await localDataSource.cacheMovie(movie);
        return Right(movie);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      try {
        final movie = await localDataSource.getCachedMovie(movieId);
        return Right(movie);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    // Busca sempre requer internet
    if (await networkInfo.isConnected) {
      try {
        final movies = await remoteDataSource.searchMovies(query);
        return Right(movies);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('Busca requer conexão com internet'));
    }
  }

  @override
  Future<Either<Failure, List<Genre>>> getGenres() async {
    if (await networkInfo.isConnected) {
      try {
        final genres = await remoteDataSource.getGenres();
        await localDataSource.cacheGenres(genres);
        return Right(genres);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      try {
        final genres = await localDataSource.getCachedGenres();
        return Right(genres);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMoviesByGenre(int genreId) async {
    if (await networkInfo.isConnected) {
      try {
        final movies = await remoteDataSource.getMoviesByGenre(genreId);
        return Right(movies);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      // Tenta filtrar do cache local
      try {
        final allMovies = await localDataSource.getCachedMovies();
        final filteredMovies = allMovies
            .where((movie) => movie.genreIds.contains(genreId))
            .toList();
        return Right(filteredMovies);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
}
