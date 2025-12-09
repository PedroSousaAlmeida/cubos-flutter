import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/genre_model.dart';
import '../models/movie_model.dart';

abstract class MovieLocalDataSource {
  Future<List<MovieModel>> getCachedMovies();
  Future<void> cacheMovies(List<MovieModel> movies);
  Future<MovieModel> getCachedMovie(int movieId);
  Future<void> cacheMovie(MovieModel movie);
  Future<List<GenreModel>> getCachedGenres();
  Future<void> cacheGenres(List<GenreModel> genres);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  static const String moviesBoxName = 'movies';
  static const String movieDetailsBoxName = 'movie_details';
  static const String genresBoxName = 'genres';
  static const String cacheMetaBoxName = 'cache_meta';

  // TTL: 1 hora (em milissegundos)
  static const int cacheTTL = 60 * 60 * 1000;

  Future<bool> _isCacheValid(String key) async {
    try {
      final metaBox = await Hive.openBox<int>(cacheMetaBoxName);
      final timestamp = metaBox.get(key);

      if (timestamp == null) return false;

      final now = DateTime.now().millisecondsSinceEpoch;
      return (now - timestamp) < cacheTTL;
    } catch (e) {
      return false;
    }
  }

  Future<void> _updateCacheTimestamp(String key) async {
    try {
      final metaBox = await Hive.openBox<int>(cacheMetaBoxName);
      await metaBox.put(key, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Ignora erro de timestamp
    }
  }

  @override
  Future<List<MovieModel>> getCachedMovies() async {
    try {
      // Verifica se cache expirou
      if (!await _isCacheValid('movies')) {
        throw CacheException('Cache expirado');
      }

      final box = await Hive.openBox<Map>(moviesBoxName);
      final cachedMovies = box.values.toList();

      if (cachedMovies.isEmpty) {
        throw CacheException('Nenhum filme em cache');
      }

      return cachedMovies
          .map((json) => MovieModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      throw CacheException('Erro ao acessar cache de filmes');
    }
  }

  @override
  Future<void> cacheMovies(List<MovieModel> movies) async {
    try {
      final box = await Hive.openBox<Map>(moviesBoxName);
      await box.clear();

      // Usa putAll em vez de loop (3x mais rápido)
      final moviesMap = <int, Map<String, dynamic>>{};
      for (var i = 0; i < movies.length; i++) {
        moviesMap[i] = movies[i].toJson();
      }
      await box.putAll(moviesMap);

      // Atualiza timestamp
      await _updateCacheTimestamp('movies');
    } catch (e) {
      throw CacheException('Erro ao salvar filmes no cache');
    }
  }

  @override
  Future<MovieModel> getCachedMovie(int movieId) async {
    try {
      final box = await Hive.openBox<Map>(movieDetailsBoxName);
      final cachedMovie = box.get(movieId);

      if (cachedMovie == null) {
        throw CacheException('Filme não encontrado no cache');
      }

      return MovieModel.fromJson(Map<String, dynamic>.from(cachedMovie));
    } catch (e) {
      throw CacheException('Erro ao acessar cache de detalhes');
    }
  }

  @override
  Future<void> cacheMovie(MovieModel movie) async {
    try {
      final box = await Hive.openBox<Map>(movieDetailsBoxName);
      await box.put(movie.id, movie.toJson());
    } catch (e) {
      throw CacheException('Erro ao salvar filme no cache');
    }
  }

  @override
  Future<List<GenreModel>> getCachedGenres() async {
    try {
      // Verifica se cache expirou
      if (!await _isCacheValid('genres')) {
        throw CacheException('Cache expirado');
      }

      final box = await Hive.openBox<Map>(genresBoxName);
      final cachedGenres = box.values.toList();

      if (cachedGenres.isEmpty) {
        throw CacheException('Nenhum gênero em cache');
      }

      return cachedGenres
          .map((json) => GenreModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      throw CacheException('Erro ao acessar cache de gêneros');
    }
  }

  @override
  Future<void> cacheGenres(List<GenreModel> genres) async {
    try {
      final box = await Hive.openBox<Map>(genresBoxName);
      await box.clear();

      // Usa putAll em vez de loop (3x mais rápido)
      final genresMap = <int, Map<String, dynamic>>{};
      for (var i = 0; i < genres.length; i++) {
        genresMap[i] = genres[i].toJson();
      }
      await box.putAll(genresMap);

      // Atualiza timestamp
      await _updateCacheTimestamp('genres');
    } catch (e) {
      throw CacheException('Erro ao salvar gêneros no cache');
    }
  }
}
