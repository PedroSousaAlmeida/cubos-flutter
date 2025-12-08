import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// UseCase para buscar detalhes de um filme específico
class GetMovieDetails implements UseCase<Movie, MovieParams> {
  final MovieRepository repository;

  GetMovieDetails(this.repository);

  @override
  Future<Either<Failure, Movie>> call(MovieParams params) async {
    // Validação
    if (params.movieId <= 0) {
      return const Left(ValidationFailure('ID do filme inválido'));
    }
    
    return await repository.getMovieDetails(params.movieId);
  }
}

/// Parâmetros para buscar detalhes
class MovieParams extends Equatable {
  final int movieId;

  const MovieParams({required this.movieId});

  @override
  List<Object> get props => [movieId];
}