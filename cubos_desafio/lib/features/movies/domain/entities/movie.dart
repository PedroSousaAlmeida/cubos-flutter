import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
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

  const Movie({
    required this.id,
    required this.title,
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
  ];
}
