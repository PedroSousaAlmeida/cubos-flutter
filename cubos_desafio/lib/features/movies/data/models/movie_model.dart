import '../../domain/entities/movie.dart';
import 'cast_model.dart';
import 'crew_model.dart';
import 'production_company_model.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    super.originalTitle,
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
    super.cast,
    super.crew,
    super.productionCompanies,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int? ?? 0,

      title: json['title'] as String? ?? 'Sem título',
      originalTitle: json['original_title'] as String?,
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

      cast: _parseCast(json),
      crew: _parseCrew(json),
      productionCompanies: _parseProductionCompanies(json),
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

  static List<CastModel> _parseCast(Map<String, dynamic> json) {
    if (json['credits'] != null && json['credits']['cast'] != null) {
      return (json['credits']['cast'] as List<dynamic>)
          .map((e) => CastModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static List<CrewModel> _parseCrew(Map<String, dynamic> json) {
    if (json['credits'] != null && json['credits']['crew'] != null) {
      return (json['credits']['crew'] as List<dynamic>)
          .map((e) => CrewModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static List<ProductionCompanyModel> _parseProductionCompanies(
    Map<String, dynamic> json,
  ) {
    if (json['production_companies'] != null) {
      return (json['production_companies'] as List<dynamic>)
          .map((e) => ProductionCompanyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
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
      'credits': {
        'cast': cast.map((e) => (e as CastModel).toJson()).toList(),
        'crew': crew.map((e) => (e as CrewModel).toJson()).toList(),
      },
      'production_companies': productionCompanies
          .map((e) => (e as ProductionCompanyModel).toJson())
          .toList(),
    };
  }

  Movie toEntity() => this;
}
