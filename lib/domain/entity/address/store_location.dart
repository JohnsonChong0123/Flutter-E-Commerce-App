import 'package:equatable/equatable.dart';

class StoreLocation extends Equatable {
  final String id;
  final String title;
  final double latitude;
  final double longitude;
  final String address;

  const StoreLocation({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  List<Object?> get props => [id, title, latitude, longitude, address];
}
