
import 'dart:convert';

import 'package:flutter_shipper_github/data/FunctionApp/Point.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
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
  // List province
  Future<List<String>> listProvinces() async {
    String url = 'https://provinces.open-api.vn/api/?depth=2';
    List<String> provinceNames = [];

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String decodedResponse = utf8.decode(response.bodyBytes);

        // Giải mã JSON từ chuỗi đã giải mã
        List<dynamic> data = jsonDecode(decodedResponse);
        provinceNames =
            data.map((province) => province['name'] as String).toList();
      } else {
        throw Exception('Failed to load provinces');
      }
    } catch (e) {
      print("Error: $e");
    }
    return provinceNames;
  }

  Future<List<String>> listDistrict(String provinceName) async {
    String url = 'https://provinces.open-api.vn/api/?depth=2';
    List<String> districtNames = [];

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String decodedResponse = utf8.decode(response.bodyBytes);

        List<dynamic> provinces = jsonDecode(decodedResponse);

        var province = provinces.firstWhere(
            (element) => element['name'] == provinceName,
            orElse: () => null);

        if (province != null) {
          List<dynamic> districts = province['districts'] ?? [];

          districtNames =
              districts.map((district) => district['name'] as String).toList();
        } else {
          throw Exception('Province not found');
        }
      } else {
        throw Exception('Failed to load provinces');
      }
    } catch (e) {
      print("Error: $e");
    }

    return districtNames;
  }
}