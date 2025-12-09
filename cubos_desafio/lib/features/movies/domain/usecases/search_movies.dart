import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// UseCase para buscar filmes por query
class SearchMovies implements UseCase<List<Movie>, SearchParams> {
  final MovieRepository repository;

  SearchMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(SearchParams params) async {
    // Validação básica
    if (params.query.trim().isEmpty) {
      return const Left(ValidationFailure('Query não pode ser vazia'));
    }

    return await repository.searchMovies(params.query, page: params.page);
  }
}

/// Parâmetros para busca
class SearchParams extends Equatable {
  final String query;
  final int page;

  const SearchParams({required this.query, this.page = 1});

  @override
  List<Object> get props => [query, page];
}