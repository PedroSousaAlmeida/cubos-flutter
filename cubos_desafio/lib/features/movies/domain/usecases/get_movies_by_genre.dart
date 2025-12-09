import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// UseCase para buscar filmes por gênero(s)
class GetMoviesByGenre implements UseCase<List<Movie>, GenreParams> {
  final MovieRepository repository;

  GetMoviesByGenre(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(GenreParams params) async {
    if (params.genreIds.isEmpty) {
      return const Left(ValidationFailure('Lista de gêneros vazia'));
    }

    if (params.genreIds.any((id) => id <= 0)) {
      return const Left(ValidationFailure('ID de gênero inválido'));
    }

    return await repository.getMoviesByGenres(params.genreIds, page: params.page);
  }
}

/// Parâmetros para filtrar por gênero(s)
class GenreParams extends Equatable {
  final List<int> genreIds;
  final int page;

  const GenreParams({required this.genreIds, this.page = 1});

  @override
  List<Object> get props => [genreIds, page];
}
