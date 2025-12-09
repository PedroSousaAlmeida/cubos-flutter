import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_local_datasource.dart';
import '../datasources/movie_remote_datasource.dart';

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
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMovies = await remoteDataSource.getPopularMovies(
          page: page,
        );
        if (page == 1) {
          await localDataSource.cacheMovies(remoteMovies);
        }
        return Right(remoteMovies);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      if (page == 1) {
        try {
          final localMovies = await localDataSource.getCachedMovies();
          return Right(localMovies);
        } on CacheException catch (e) {
          return Left(CacheFailure(e.message));
        }
      } else {
        return const Left(
          NetworkFailure('Paginação requer conexão com internet'),
        );
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
  Future<Either<Failure, List<Movie>>> searchMovies(
    String query, {
    int page = 1,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final movies = await remoteDataSource.searchMovies(query, page: page);
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
  Future<Either<Failure, List<Movie>>> getMoviesByGenre(
    int genreId, {
    int page = 1,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final movies = await remoteDataSource.getMoviesByGenre(
          genreId,
          page: page,
        );
        return Right(movies);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      if (page == 1) {
        try {
          final allMovies = await localDataSource.getCachedMovies();
          final filteredMovies = allMovies
              .where((movie) => movie.genreIds.contains(genreId))
              .toList();
          return Right(filteredMovies);
        } on CacheException catch (e) {
          return Left(CacheFailure(e.message));
        }
      } else {
        return const Left(
          NetworkFailure('Paginação requer conexão com internet'),
        );
      }
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMoviesByGenres(
    List<int> genreIds, {
    int page = 1,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final movies = await remoteDataSource.getMoviesByGenres(
          genreIds,
          page: page,
        );
        return Right(movies);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      if (page == 1) {
        try {
          final allMovies = await localDataSource.getCachedMovies();
          final filteredMovies = allMovies
              .where(
                (movie) => movie.genreIds.any((id) => genreIds.contains(id)),
              )
              .toList();
          return Right(filteredMovies);
        } on CacheException catch (e) {
          return Left(CacheFailure(e.message));
        }
      } else {
        return const Left(
          NetworkFailure('Paginação requer conexão com internet'),
        );
      }
    }
  }
}
