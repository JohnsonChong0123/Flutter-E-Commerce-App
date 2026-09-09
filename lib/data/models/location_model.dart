import 'package:equatable/equatable.dart';

import '../../domain/entity/location_entity.dart';
import '../../domain/entity/address/address_entity.dart';

class LocationModel extends Equatable {
  final double latitude;
  final double longitude;
  final String address;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      address: json['address']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  /// Whether this model carries meaningful coordinates
  /// (as opposed to an unset/default value from the server).
  bool get hasValidCoordinates => !(latitude == 0.0 && longitude == 0.0);

  LocationEntity toEntity() {
    return LocationEntity(
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
  }

  /// Converts this model into an [AddressEntity], used by [MapRepository]
  /// where a saved location needs to be surfaced as a selectable address.
  AddressEntity toAddressEntity({String placeId = 'saved_location'}) {
    return AddressEntity(
      latitude: latitude,
      longitude: longitude,
      formattedAddress: address.isNotEmpty ? address : 'Saved Location',
      placeId: placeId,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, address];
}