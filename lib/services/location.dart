import 'package:geolocator/geolocator.dart';

class Location {
  late double _latitude;
  late double _longitude;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _latitude = position.latitude;
      _longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  setLatitude(double latitude) {
    this._latitude = latitude;
  }

  setLongitude(double longitude) {
    this._longitude = longitude;
  }

  getLatitude() {
    return this._latitude;
  }

  getLongitude() {
    return this._longitude;
  }
}
