import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/genre_model.dart';
import '../models/movie_model.dart';


abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies({int page = 1});
  Future<MovieModel> getMovieDetails(int movieId);
  Future<List<MovieModel>> searchMovies(String query, {int page = 1});
  Future<List<GenreModel>> getGenres();
  Future<List<MovieModel>> getMoviesByGenre(int genreId, {int page = 1});
  Future<List<MovieModel>> getMoviesByGenres(
    List<int> genreIds, {
    int page = 1,
  });
}


class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    try {
      final response = await dio.get(
        ApiConstants.popularMovies,
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw ServerException('Erro ao buscar filmes populares');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Erro de servidor');
    }
  }

  @override
  Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      final response = await dio.get(
        '${ApiConstants.movieDetails}/$movieId',
        queryParameters: {'append_to_response': 'credits'},
      );

      if (response.statusCode == 200) {
        return MovieModel.fromJson(response.data);
      } else {
        throw ServerException('Erro ao buscar detalhes do filme');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Erro de servidor');
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await dio.get(
        ApiConstants.searchMovies,
        queryParameters: {'query': query, 'page': page},
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw ServerException('Erro ao buscar filmes');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Erro de servidor');
    }
  }

  @override
  Future<List<GenreModel>> getGenres() async {
    try {
      final response = await dio.get(ApiConstants.genres);

      if (response.statusCode == 200) {
        final results = response.data['genres'] as List;
        return results.map((json) => GenreModel.fromJson(json)).toList();
      } else {
        throw ServerException('Erro ao buscar gêneros');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Erro de servidor');
    }
  }

  @override
  Future<List<MovieModel>> getMoviesByGenre(int genreId, {int page = 1}) async {
    try {
      final response = await dio.get(
        ApiConstants.discoverMovies,
        queryParameters: {'with_genres': genreId, 'page': page},
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw ServerException('Erro ao buscar filmes por gênero');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Erro de servidor');
    }
  }

  @override
  Future<List<MovieModel>> getMoviesByGenres(
    List<int> genreIds, {
    int page = 1,
  }) async {
    try {
      final genresParam = genreIds.join(',');

      final response = await dio.get(
        ApiConstants.discoverMovies,
        queryParameters: {'with_genres': genresParam, 'page': page},
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw ServerException('Erro ao buscar filmes por gêneros');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Erro de servidor');
    }
  }
}
