import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// UseCase para buscar filmes populares
class GetPopularMovies implements UseCase<List<Movie>, PopularMoviesParams> {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(PopularMoviesParams params) async {
    return await repository.getPopularMovies(page: params.page);
  }
}

/// Parâmetros para busca de filmes populares
class PopularMoviesParams extends Equatable {
  final int page;

  const PopularMoviesParams({this.page = 1});

  @override
  List<Object> get props => [page];
}