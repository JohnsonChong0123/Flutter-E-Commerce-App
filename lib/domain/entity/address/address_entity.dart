import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final double latitude;
  final double longitude;
  final String formattedAddress;
  final String placeId;

  const AddressEntity({
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
    required this.placeId,
  });

  AddressEntity copyWith({
    double? latitude,
    double? longitude,
    String? formattedAddress,
    String? placeId,
  }) {
    return AddressEntity(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      placeId: placeId ?? this.placeId,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, formattedAddress, placeId];
}
