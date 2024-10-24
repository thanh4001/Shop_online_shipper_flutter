
import 'package:flutter_shipper_github/data/FunctionApp/Point.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;

class Mapfuntion {
  Mapfuntion();
  Future<Point> getCurrentLocation() async {
  // Request location permissions
 
    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return Point(latitude: position.latitude, longitude: position.longitude);
 
}
double calculateBearing(LatLng start, LatLng end) {
  double startLat = start.latitude * (math.pi / 180);
  double startLng = start.longitude * (math.pi / 180);
  double endLat = end.latitude * (math.pi / 180);
  double endLng = end.longitude * (math.pi / 180);

  double dLng = endLng - startLng;

  double y = math.sin(dLng) * math.cos(endLat);
  double x = math.cos(startLat) * math.sin(endLat) - 
             math.sin(startLat) * math.cos(endLat) * math.cos(dLng);
  
  double initialBearing = math.atan2(y, x);
  
  // Chuyển đổi từ radian sang độ
  return (initialBearing * (180 / math.pi) + 360) % 360;
}

  Future<Point> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        double latitude = locations.first.latitude;
        double longitude = locations.first.longitude;
        return Point(latitude: latitude, longitude: longitude);
      }
    } catch (e) {
      print('Error: $e');
    }
    return Point(latitude: 0, longitude: 0);
  }
  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    return distanceInMeters;
  }
  String formatTime(String isoDateTime) {
    DateTime dateTime = DateTime.parse(isoDateTime);
    return DateFormat('hh:mm').format(dateTime);
  }
}