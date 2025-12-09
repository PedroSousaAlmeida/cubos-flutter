import 'package:equatable/equatable.dart';

class ProductionCompany extends Equatable {
  final int id;
  final String name;
  final String? logoPath;

  const ProductionCompany({
    required this.id,
    required this.name,
    this.logoPath,
  });

  String? get fullLogoPath {
    if (logoPath == null) return null;
    return 'https://image.tmdb.org/t/p/w200$logoPath';
  }

  @override
  List<Object?> get props => [id, name, logoPath];
}
