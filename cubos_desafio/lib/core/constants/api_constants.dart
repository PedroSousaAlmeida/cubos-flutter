import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';

  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';

  static String get bearerToken => dotenv.env['TMDB_BEARER_TOKEN'] ?? '';

  static const String popularMovies = '/movie/popular';
  static const String searchMovies = '/search/movie';
  static const String movieDetails = '/movie';
  static const String genres = '/genre/movie/list';
  static const String discoverMovies = '/discover/movie';

  static const String posterSize = 'w500';
  static const String backdropSize = 'original';

  static const String language = 'en-US';
}
