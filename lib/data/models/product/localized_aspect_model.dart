import 'package:equatable/equatable.dart';

import '../../../domain/entity/product/localized_aspect_entity.dart';

class LocalizedAspectModel extends Equatable {
  final String type;
  final String name;
  final String value;

  const LocalizedAspectModel({
    required this.type,
    required this.name,
    required this.value,
  });

  factory LocalizedAspectModel.fromJson(Map<String, dynamic> json) {
    return LocalizedAspectModel(
      type: json['type']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }

  LocalizedAspectEntity toEntity() {
    return LocalizedAspectEntity(
      type: type,
      name: name,
      value: value,
    );
  }

  @override
  List<Object?> get props => [type, name, value];
}