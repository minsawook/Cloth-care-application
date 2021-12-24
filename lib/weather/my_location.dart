import 'package:geolocator/geolocator.dart';

class MyLocation {
  double lat2;
  double lon2;

  Future<void> getyLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      print(position);
      lat2 = position.latitude;
      lon2 = position.longitude;
    } catch (e) {
      print('위치를 찾을 수 없음');
    }
  }
}
