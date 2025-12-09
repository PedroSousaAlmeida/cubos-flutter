import 'package:cubos_desafio/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/movie.dart';
import '../entities/genre.dart';

/// Interface do Repository (Domain Layer)
///
/// Define o CONTRATO de como acessar dados de filmes
/// Não sabe COMO implementar, apenas DEFINE o que deve ser feito
abstract class MovieRepository {
  /// Busca filmes populares
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1});

  /// Busca detalhes de um filme específico
  Future<Either<Failure, Movie>> getMovieDetails(int movieId);

  /// Busca filmes por query de texto
  Future<Either<Failure, List<Movie>>> searchMovies(String query, {int page = 1});

  /// Busca todos os gêneros disponíveis
  Future<Either<Failure, List<Genre>>> getGenres();

  /// Busca filmes por gênero
  Future<Either<Failure, List<Movie>>> getMoviesByGenre(int genreId, {int page = 1});
  Future<Either<Failure, List<Movie>>> getMoviesByGenres(List<int> genreIds, {int page = 1});
}
