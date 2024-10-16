import 'package:flutter_shipper_github/data/FunctionApp/MapFuntion.dart';
import 'package:flutter_shipper_github/data/FunctionApp/Point.dart';
import 'package:flutter_shipper_github/data/controller/Store_Controller.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng daNangCoordinates = LatLng(16.0544, 108.2022);

  @override
  void initState() {
    super.initState();
    // Nếu cần, gọi hàm để tải dữ liệu cửa hàng ở đây.
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Storecontroller>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: Text('Bản đồ Đà Nẵng')),
          body: Column(
            children: [
              Expanded( 
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: daNangCoordinates,
                    initialZoom: 14.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: controller.getstoreList.map((item) {
                        LatLng storeLocation = LatLng(item.latitude!, item.longitude!);

                        return Marker(
                          width: 80.0,
                          height: 80.0,
                          point: storeLocation,
                          child: Container(
                            child: Icon(Icons.location_on, color: Colors.red, size: 40),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Container(
                height: 100, 
                color: Colors.blueAccent, 
                child: Center(
                  child: Text(
                    'Thông tin bổ sung ở đây', 
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
