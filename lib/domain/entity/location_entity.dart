import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final String address;
  final double latitude;
  final double longitude;

  const LocationEntity({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [address, latitude, longitude];
}