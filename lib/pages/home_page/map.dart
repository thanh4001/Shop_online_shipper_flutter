import 'dart:convert';

import 'package:flutter_shipper_github/data/FunctionApp/MapFuntion.dart';
import 'package:flutter_shipper_github/data/FunctionApp/Point.dart';
import 'package:flutter_shipper_github/data/controller/Store_Controller.dart';
import 'package:flutter_shipper_github/data/models/Item/Storeitem.dart';
import 'package:flutter_shipper_github/themes/AppDimention.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng daNangCoordinates = LatLng(16.0544, 108.2022);
  Mapfuntion functionmap = Mapfuntion();
  Point? currentPoint;
  MapController mapController = MapController();
  bool? loadedCurrenr = false;
  String? selectedValue;
  int? storeid;
  bool? isShowRoute = false;
  @override
  void initState() {
    super.initState();
    loadCurrent();
  }

  void loadCurrent() async {
    loadedCurrenr = false;
    currentPoint = await functionmap.getCurrentLocation();
    setState(() {
      loadedCurrenr = true;
    });
  }
  Storesitem? storeselected ;
  void onChanged(Storesitem store) {
    setState(() {
      storeselected = store;
      selectedValue = store.storeName;
      storeid = store.storeId;
    });
  }
  double zoomValue = 14;
  List<LatLng> routePoints = [];
  
  Future<void> getRoute(LatLng startPoint, LatLng endPoint) async {
    final apiKey = '5b3ce3597851110001cf62482f6aa59251a040bca10bfec215ef276c';
    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${startPoint.longitude},${startPoint.latitude}&end=${endPoint.longitude},${endPoint.latitude}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coordinates =
          data['features'][0]['geometry']['coordinates'];

      setState(() {
        routePoints =
            coordinates.map((point) => LatLng(point[1], point[0])).toList();
      });
    } else {
      Get.snackbar("Thông báo", "Không có đường bộ để đi");
    }
  }

  @override
  Widget build(BuildContext context) {
    return !loadedCurrenr!
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GetBuilder<Storecontroller>(
            builder: (controller) {
              return Scaffold(
                appBar: AppBar(title: Text('Bản đồ Đà Nẵng')),
                body: Column(
                  children: [
                    Expanded(
                      child:
                       Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.size100 * 3,
                    decoration: BoxDecoration(color: Colors.amber),
                    child: Stack(
                            children: [
                              FlutterMap(
                                mapController: mapController,
                                options: MapOptions(
                                  initialCenter: LatLng(currentPoint!.latitude!,
                                      currentPoint!.longitude!),
                                  initialZoom: zoomValue,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                    
                                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    subdomains: ['a', 'b', 'c'],
                                  ),
                                  MarkerLayer(
                            markers: controller.getstoreList.map((item) {
                              LatLng storeLocation =
                                  LatLng(item.latitude!, item.longitude!);

                              return Marker(
                                width: 200,
                                height: 80.0,
                                point: storeLocation,
                                child: Column(
                                  children: [
                                    Container(
                                      width: AppDimention.size100 * 2,
                                      height: AppDimention.size40,
                                      child: Text(item.storeName!),
                                    ),
                                    Icon(Icons.location_on,
                                        color: Colors.red, size: 40),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          MarkerLayer(markers: [
                            Marker(
                              width: 200,
                              height: 80.0,
                              point: LatLng(currentPoint!.latitude!,
                                  currentPoint!.longitude!),
                              child: Icon(Icons.location_on,
                                  color: Colors.red, size: 40),
                            )
                          ]),
                                  if (isShowRoute!)
                                    PolylineLayer(
                                      polylines: [
                                        Polyline(
                                          points: routePoints,
                                          strokeWidth: 4.0,
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      mapController.move(
                                          LatLng(currentPoint!.latitude!,
                                              currentPoint!.longitude!),
                                          zoomValue);
                                    },
                                    child: Container(
                                      width: AppDimention.size40,
                                      height: AppDimention.size40,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              AppDimention.size5),
                                          border: Border.all(
                                              width: 1, color: Colors.black26)),
                                      child: Center(
                                        child: Icon(
                                          Icons.my_location,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  )),
                              Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        zoomValue = zoomValue + 1;
                                      });
                                      mapController.move(
                                          LatLng(currentPoint!.latitude!,
                                              currentPoint!.longitude!),
                                          zoomValue);
                                    },
                                    child: Container(
                                      width: AppDimention.size40,
                                      height: AppDimention.size40,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              AppDimention.size5),
                                          border: Border.all(
                                              width: 1, color: Colors.black26)),
                                      child: Center(
                                        child: Icon(
                                          Icons.zoom_out_map_outlined,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  )),
                              Positioned(
                                  bottom: 10,
                                  left: 60,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        zoomValue = zoomValue - 1;
                                      });
                                      mapController.move(
                                          LatLng(currentPoint!.latitude!,
                                              currentPoint!.longitude!),
                                          zoomValue);
                                    },
                                    child: Container(
                                      width: AppDimention.size40,
                                      height: AppDimention.size40,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              AppDimention.size5),
                                          border: Border.all(
                                              width: 1, color: Colors.black26)),
                                      child: Center(
                                        child: Icon(
                                          Icons.zoom_in_map_outlined,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  )),
                                  Positioned(
                                  bottom: 10,
                                  left: 110,
                                  child: GestureDetector(
                                    onTap: () {
                                      if(storeselected == null){
                                        Get.snackbar("Thông báo", "Vui lòng chọn cửa hàng");
                                      }
                                      else{
                                      setState(() {
                                        getRoute(
                                            LatLng(currentPoint!.latitude!,
                                                currentPoint!.longitude!),
                                            LatLng(storeselected!.latitude!,
                                                storeselected!.longitude!));
                                        isShowRoute = !isShowRoute!;
                                      });
                                      }
                                    },
                                    child: Container(
                                      width: AppDimention.size40,
                                      height: AppDimention.size40,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              AppDimention.size5),
                                          border: Border.all(
                                              width: 1, color: Colors.black26)),
                                      child: Center(
                                        child: Icon(
                                          Icons.roundabout_left,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  )),
                              
                            ],
                          )
                       
                  ),
                    ),
                    Container(
                      height: 80,
                      child: Container(
                        width: AppDimention.screenWidth,
                        padding: EdgeInsets.all(AppDimention.size10),
                        child: DropdownButtonFormField<Storesitem>(
                          dropdownColor: Colors.amber.withOpacity(0.5),
                          hint: Text(
                            "Chọn cửa hàng",
                            style:
                                TextStyle(color: Colors.black26, fontSize: 12),
                          ),
                          items: controller.getstoreList.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Container(
                                width: AppDimention.size100 * 3.8,
                                margin: EdgeInsets.only(
                                    top: AppDimention.size10,
                                    bottom: AppDimention.size10),
                                padding: EdgeInsets.all(AppDimention.size10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[200],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: AppDimention.size100 * 3.8,
                                      child: Text(item.storeName!),
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: AppDimention.size50,
                                              height: AppDimention.size50,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(image: MemoryImage(
                                                  base64Decode(item.image!)
                                                ))
                                              ),
                                            ),
                                            SizedBox(
                                                height: AppDimention.size10),
                                            Row(
                                              children: [
                                                Icon(Icons.location_on,
                                                    size: 10,
                                                    color: Colors.blue),
                                                Text(
                                                  "${(functionmap.calculateDistance(item.latitude!, item.longitude!, loadedCurrenr! ? currentPoint!.latitude! : 0, loadedCurrenr! ? currentPoint!.longitude! : 0) / 1000).toInt()} km",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.blue),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        Container(
                                          width: AppDimention.size100 * 2.7,
                                          padding: EdgeInsets.all(
                                              AppDimention.size10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Địa chỉ :" + item.location!,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                "Sđt :" +
                                                    item.numberPhone!
                                                        .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                "Thời gian : " +
                                                    functionmap.formatTime(
                                                        item.openingTime!) +
                                                    " - " +
                                                    functionmap.formatTime(
                                                        item.closingTime!),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            var selectedStore = value as Storesitem;
                            onChanged(selectedStore);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size5),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size5),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size5),
                              borderSide:
                                  BorderSide(color: Colors.green, width: 1.0),
                            ),
                          ),
                          selectedItemBuilder: (BuildContext context) {
                            return controller.storeList.map((item) {
                              return Container(
                                alignment: Alignment.centerLeft,
                                height: 60,
                                width: AppDimention.size100 * 3,
                                child: Text(item.storeName!,
                                    style: TextStyle(fontSize: 16)),
                              );
                            }).toList();
                          },
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
