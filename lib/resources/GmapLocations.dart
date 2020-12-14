import 'package:geolocator/geolocator.dart';

class GmapLocations {
  static Future<Position> currentPosition() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    return position;
  }

  static Future<String> currentStringLocation() async {
    if ((await Geolocator().isLocationServiceEnabled())) {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark placeMark = placemark[0];
      String name = placeMark.name;
      String locality = placeMark.locality;
      String administrativeArea = placeMark.administrativeArea;
      String postalCode = placeMark.postalCode;
      String country = placeMark.country;
      String iso = placeMark.isoCountryCode;
      //  String f = placeMark.toString();

      String address = "${placeMark.locality}, ${placeMark.subLocality}, ${placeMark.thoroughfare}, ${placeMark.subThoroughfare}";

      return address;
    }
  }

  static Future<Placemark> currentPositionFromString(String location) async {
    List<Placemark> placemark = await Geolocator().placemarkFromAddress(location);
    Placemark placeMark = placemark[0];
    return placeMark;
  }

  static Future<Placemark> getFromCoordinates(double latitude, double longitude) async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(latitude, longitude);
    Placemark placeMark = placemark[0];
    return placeMark;
  }

  static Future<List<Position>> currentPositionDirection(String location) async {
    List<Position> positions;
    Position current = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator().placemarkFromAddress(location);
    Placemark placeMark = placemark[0];
    Position destination = placeMark.position;
    print(current);
    print(destination);
    positions.add(current);
    positions.add(destination);
    return positions;
  }
}
