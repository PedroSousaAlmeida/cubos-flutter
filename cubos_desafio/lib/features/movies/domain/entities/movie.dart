import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final double popularity;
  final int voteCount;
  final String status;
  final String tagline;
  final String releaseDate;
  final double revenue;
  final double budget;
  final int runtime;
  final List<int> genreIds;
  final String homePage;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.popularity,
    required this.voteCount,
    required this.status,
    required this.tagline,
    required this.releaseDate,
    required this.revenue,
    required this.budget,
    required this.runtime,
    required this.genreIds,
    required this.homePage,
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
