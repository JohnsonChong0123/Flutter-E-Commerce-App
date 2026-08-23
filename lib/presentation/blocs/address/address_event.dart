part of 'address_bloc.dart';

sealed class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

final class MapViewCreated extends AddressEvent {
  final int mapViewId;
  final AddressEntity? initialAddress;

  const MapViewCreated({
    required this.mapViewId,
    this.initialAddress,
  });

  @override
  List<Object?> get props => [mapViewId, initialAddress];
}

final class MapCoordinateUpdated extends AddressEvent {
  final double latitude;
  final double longitude;

  const MapCoordinateUpdated({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

final class RetryMapLoad extends AddressEvent {
  const RetryMapLoad();
}