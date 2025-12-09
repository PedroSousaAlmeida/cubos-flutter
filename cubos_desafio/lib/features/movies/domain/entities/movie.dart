import 'package:equatable/equatable.dart';
import 'cast.dart';
import 'crew.dart';
import 'production_company.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String? originalTitle;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final double? popularity;
  final int? voteCount;
  final String? status;
  final String? tagline;
  final String? releaseDate;
  final double? revenue;
  final double? budget;
  final int? runtime;
  final List<int> genreIds;
  final String? homePage;
  final List<Cast> cast;
  final List<Crew> crew;
  final List<ProductionCompany> productionCompanies;

  const Movie({
    required this.id,
    required this.title,
    this.originalTitle,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage,
    this.popularity,
    this.voteCount,
    this.status,
    this.tagline,
    this.releaseDate,
    this.revenue,
    this.budget,
    this.runtime,
    required this.genreIds,
    this.homePage,
    this.cast = const [],
    this.crew = const [],
    this.productionCompanies = const [],
  });

  String? get fullPosterPath {
    if (posterPath == null) return null;
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String? get fullBackdropPath {
    if (backdropPath == null) return null;
    return 'https://image.tmdb.org/t/p/original$backdropPath';
  }

  @override
  List<Object?> get props => [
    id,
    title,
    originalTitle,
    overview,
    posterPath,
    backdropPath,
    voteAverage,
    popularity,
    voteCount,
    status,
    tagline,
    releaseDate,
    revenue,
    budget,
    runtime,
    genreIds,
    homePage,
    cast,
    crew,
    productionCompanies,
  ];
}
