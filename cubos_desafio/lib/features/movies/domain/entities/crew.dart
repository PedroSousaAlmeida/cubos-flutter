import 'package:equatable/equatable.dart';

class Crew extends Equatable {
  final int id;
  final String name;
  final String job;
  final String department;
  final String? profilePath;

  const Crew({
    required this.id,
    required this.name,
    required this.job,
    required this.department,
    this.profilePath,
  });

  String? get fullProfilePath {
    if (profilePath == null) return null;
    return 'https://image.tmdb.org/t/p/w200$profilePath';
  }

  @override
  List<Object?> get props => [id, name, job, department, profilePath];
}
