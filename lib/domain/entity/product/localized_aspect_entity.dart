import 'package:equatable/equatable.dart';

class LocalizedAspectEntity extends Equatable {
  final String type;
  final String name;
  final String value;

  const LocalizedAspectEntity({
    required this.type,
    required this.name,
    required this.value,
  });
  
  @override
  List<Object?> get props => [type, name, value];
}