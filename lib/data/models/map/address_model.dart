import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import '../../../domain/entity/address/address_entity.dart';

class AddressModel extends Equatable {
  final String placeId;
  final String formattedAddress;
  final double latitude;
  final double longitude;

  const AddressModel({
    required this.placeId,
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
  });

  factory AddressModel.fromPlacemarks({
    required double latitude,
    required double longitude,
    required List<Placemark> placemarks,
    String fallbackPlaceId = 'unknown_place',
  }) {
    final place = placemarks.isNotEmpty ? placemarks.first : null;
    
    final line1 = [
      place?.name,
      place?.subLocality,
      place?.thoroughfare,
    ].where((value) => value != null && value.trim().isNotEmpty).join(', ');
    
    final line2 = [
      place?.locality,
      place?.administrativeArea,
      place?.country,
    ].where((value) => value != null && value.trim().isNotEmpty).join(', ');
    
    final formatted = [
      line1,
      line2,
    ].where((value) => value.trim().isNotEmpty).join('\n');

    return AddressModel(
      latitude: latitude,
      longitude: longitude,
      formattedAddress: formatted.isEmpty
          ? 'Lat: ${latitude.toStringAsFixed(6)}, Lng: ${longitude.toStringAsFixed(6)}'
          : formatted,
      placeId: fallbackPlaceId,
    );
  }

  AddressEntity toEntity() {
    return AddressEntity(
      placeId: placeId,
      formattedAddress: formattedAddress,
      latitude: latitude,
      longitude: longitude,
    );
  }

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      placeId: entity.placeId,
      formattedAddress: entity.formattedAddress,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }

  @override
  List<Object?> get props => [
    placeId,
    formattedAddress,
    latitude,
    longitude,
  ];
}