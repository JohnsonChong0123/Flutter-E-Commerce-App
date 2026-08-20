import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartPackageName: 'e_commerce_client',
    dartOut: 'lib/data/sources/remote/generated/google_map_api.g.dart',
    kotlinOut:
        'android/app/src/main/kotlin/com/example/app/generated/google_map_api.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.example.app.generated'),
  ),
)
class MarkerDto {
  MarkerDto({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  String id;
  String title;
  double latitude;
  double longitude;
  String address;
}

@HostApi()
abstract class GoogleMapHostApi {
  void initializeMap(int viewId);

  void updateStoreMarkers(int viewId, List<MarkerDto> markers);

  void moveCamera(int viewId, double latitude, double longitude, double zoom);
}

@FlutterApi()
abstract class GoogleMapFlutterApi {
  void onCameraIdle(int viewId, double latitude, double longitude);

  void onMarkerDragEnd(int viewId, double latitude, double longitude);
}
