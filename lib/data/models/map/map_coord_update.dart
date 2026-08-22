import 'package:equatable/equatable.dart';

class MapCoordinateUpdate extends Equatable {
  final int viewId;
  final double latitude;
  final double longitude;

  const MapCoordinateUpdate({
    required this.viewId,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [viewId, latitude, longitude];
}