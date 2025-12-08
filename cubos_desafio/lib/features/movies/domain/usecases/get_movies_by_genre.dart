import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// UseCase para buscar filmes por gênero
class GetMoviesByGenre implements UseCase<List<Movie>, GenreParams> {
  final MovieRepository repository;

  GetMoviesByGenre(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(GenreParams params) async {
    if (params.genreId <= 0) {
      return const Left(ValidationFailure('ID do gênero inválido'));
    }

    return await repository.getMoviesByGenre(params.genreId);
  }
}

/// Parâmetros para filtrar por gênero
class GenreParams extends Equatable {
  final int genreId;

  const GenreParams({required this.genreId});

  @override
  List<Object> get props => [genreId];
}
