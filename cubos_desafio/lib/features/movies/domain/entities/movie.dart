import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
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

  @override
  List<Object?> get props => throw UnimplementedError();
}
