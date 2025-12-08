import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    super.posterPath,
    super.backdropPath,
    required super.voteAverage,
    required super.popularity,
    required super.voteCount,
    super.status,
    super.tagline,
    required super.releaseDate,
    super.revenue,
    super.budget,
    super.runtime,
    required super.genreIds,
    super.homePage,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int? ?? 0,

      title: json['title'] as String? ?? 'Sem título',
      overview: json['overview'] as String? ?? '',

      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,

      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,

      status: json['status'] as String?,
      tagline: json['tagline'] as String?,

      releaseDate: json['release_date'] as String? ?? '',

      revenue: (json['revenue'] as num?)?.toDouble(),
      budget: (json['budget'] as num?)?.toDouble(),
      runtime: json['runtime'] as int?,

      genreIds: _parseGenreIds(json),

      homePage: json['homepage'] as String?,
    );
  }

  static List<int> _parseGenreIds(Map<String, dynamic> json) {
    if (json['genre_ids'] != null) {
      return (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList();
    }

    if (json['genres'] != null) {
      return (json['genres'] as List<dynamic>)
          .map((e) => e['id'] as int)
          .toList();
    }

    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'popularity': popularity,
      'vote_count': voteCount,
      'status': status,
      'tagline': tagline,
      'release_date': releaseDate,
      'revenue': revenue,
      'budget': budget,
      'runtime': runtime,
      'genre_ids': genreIds,
      'homepage': homePage,
    };
  }

  Movie toEntity() => this;
}
