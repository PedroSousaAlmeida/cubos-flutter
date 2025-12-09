import '../../domain/entities/production_company.dart';

class ProductionCompanyModel extends ProductionCompany {
  const ProductionCompanyModel({
    required super.id,
    required super.name,
    super.logoPath,
  });

  factory ProductionCompanyModel.fromJson(Map<String, dynamic> json) {
    return ProductionCompanyModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      logoPath: json['logo_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_path': logoPath,
    };
  }

  ProductionCompany toEntity() => this;
}
