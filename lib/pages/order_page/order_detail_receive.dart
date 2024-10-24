import 'dart:convert';

import 'package:flutter_shipper_github/data/FunctionApp/MapFuntion.dart';
import 'package:flutter_shipper_github/data/FunctionApp/MathFunction.dart';
import 'package:flutter_shipper_github/data/FunctionApp/Point.dart';
import 'package:flutter_shipper_github/data/controller/AuthController.dart';
import 'package:flutter_shipper_github/data/controller/OrderController.dart';
import 'package:flutter_shipper_github/data/controller/Store_Controller.dart';
import 'package:flutter_shipper_github/data/models/Item/Storeitem.dart';
import 'package:flutter_shipper_github/data/models/OrderModel.dart';
import 'package:flutter_shipper_github/data/models/UserModelV2.dart';
import 'package:flutter_shipper_github/themes/AppColor.dart';
import 'package:flutter_shipper_github/themes/AppDimention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:math' as math;

class OrderDetailReceive extends StatefulWidget {
  final int orderCode;
  const OrderDetailReceive({Key? key, required this.orderCode})
      : super(key: key);
  @override
  _OrderDetailReceiveState createState() => _OrderDetailReceiveState();
}

class _OrderDetailReceiveState extends State<OrderDetailReceive> {
  Mathfunction mathfunction = Mathfunction();
  
  LatLng daNangCoordinates = LatLng(16.0544, 108.2022);
  Storecontroller storeController = Get.find<Storecontroller>();
  AuthController authController = Get.find<AuthController>();
  Ordercontroller ordercontroller = Get.find<Ordercontroller>();
  MapController mapController = MapController();
  Point? pointCurrent;
  bool? isLoadedLocation = false;
  Mapfuntion mapfuntion = Mapfuntion();
  double zoomValue = 14;
   String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
  }

  List<LatLng> routePoints = [];
  bool? isShowRoute = false;
  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  void _sendSMS(String phoneNumber) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Could not send SMS to $phoneNumber';
    }
  }

  void _sendEmail(String email, String subject, String body) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not send email to $email';
    }
  }

  void _changeStatus() {
    int shipperOrderId = ordercontroller.orderlist[0].id!;
    List<int> listorderid = ordercontroller.getlistorderdetailid()!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Bạn muốn chuyển trạng thái đơn hàng?',
            style: TextStyle(fontSize: 15),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                  width: AppDimention.size100 * 3,
                  height: AppDimention.size80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.close(1);
                        },
                        child: Container(
                          width: AppDimention.size120,
                          height: AppDimention.size50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Appcolor.mainColor),
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size5)),
                          child: Center(
                            child: Text("Hủy"),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ordercontroller.updatestatus(shipperOrderId, listorderid);
                          Get.close(1);
                        },
                        child: Container(
                          width: AppDimention.size120,
                          height: AppDimention.size50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Appcolor.mainColor),
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size5)),
                          child: Center(
                            child: Text("Đồng ý"),
                          ),
                        ),
                      ),
                    ],
                  ));
            },
          ),
        );
      },
    );
  }

  void _ShowSendMessage(String email, String ordercode) {
    TextEditingController messageController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                  width: AppDimention.size100 * 3,
                  height: AppDimention.size100 * 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                          width: AppDimention.size100 * 3,
                          height: AppDimention.size100 * 2.3,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black26),
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size5)),
                          child: TextField(
                            controller: messageController,
                            maxLines: null,
                            expands: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.all(AppDimention.size10),
                            ),
                          )),
                      SizedBox(
                        height: AppDimention.size20,
                      ),
                      Center(
                          child: GestureDetector(
                        onTap: () {
                          _sendEmail(
                              email,
                              "Thông báo đơn hàng số ${ordercode}",
                              messageController.text);
                        },
                        child: Container(
                          width: AppDimention.size150,
                          height: AppDimention.size50,
                          decoration: BoxDecoration(
                              color: Appcolor.mainColor,
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size10)),
                          child: Center(
                            child: Text(
                              "Gửi ngay",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ))
                    ],
                  ));
            },
          ),
        );
      },
    );
  }


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
      print("Failed to fetch route");
    }
  }
List<bool> liststatus = [];
User? customer;
Storesitem? storesitem;
OrderData? item;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDataOrder();
    getCurrentLocation();
  }
  bool loaded = false;
  void loadDataOrder() async{
    loaded = false;
    item = ordercontroller.orderlist[0];
    
      if (item!.status == "Đơn hàng mới")
        liststatus = [true, false, false, false];
      else if (item!.status == "Đơn hàng đã được xác nhận")
        liststatus = [true, true, false, false];
      else if (item!.status == "Đơn hàng đang giao")
        liststatus = [true, true, true, false];
      else if (item!.status == "Đơn hàng đã hoàn thành")
        liststatus = [true, true, true, true];
      storesitem = storeController.getstorebyid(item!.storeId!)!;
      customer = await authController.getCustomerProfile(item!.userId!);
  
    setState((){
      loaded = true;
    });
  }

  Future<void> getCurrentLocation() async {
    PermissionStatus permission = await Permission.location.request();

    if (permission.isGranted) {
      pointCurrent = await mapfuntion.getCurrentLocation();

      setState(() {
        isLoadedLocation = true;
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
   
      

      return !loaded ? Center(child: CircularProgressIndicator(),) :Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      width: AppDimention.screenWidth,
                      padding: EdgeInsets.all(AppDimention.size20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              size: AppDimention.size20,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Mã đơn hàng : ",
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                              Text(
                                "${item!.orderCode}",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                  Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.size100 * 3,
                    decoration: BoxDecoration(color: Colors.amber),
                    child: isLoadedLocation!
                        ? Stack(
                            children: [
                              FlutterMap(
                                mapController: mapController,
                                options: MapOptions(
                                  initialCenter: LatLng(pointCurrent!.latitude!,
                                      pointCurrent!.longitude!),
                                  initialZoom: zoomValue,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                    
                                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    subdomains: ['a', 'b', 'c'],
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                          width: 100.0,
                                          height: 80.0,
                                          point: LatLng(
                                              item!.latitude!, item!.longitude!),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(
                                                    AppDimention.size10),
                                                decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppDimention
                                                                .size5)),
                                                child: Text(
                                                  "Điểm giao",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.blue,
                                              ),
                                            ],
                                          )),
                                      Marker(
                                          width: 100.0,
                                          height: 80.0,
                                          point: LatLng(storesitem!.latitude!,
                                              storesitem!.longitude!),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(
                                                    AppDimention.size10),
                                                decoration: BoxDecoration(
                                                    color: Colors.yellow,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppDimention
                                                                .size5)),
                                                child: Text(
                                                  "Cửa hàng",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.yellow,
                                              ),
                                            ],
                                          )),
                                      Marker(
                                        width: 80.0,
                                        height: 80.0,
                                        point: LatLng(pointCurrent!.latitude!,
                                            pointCurrent!.longitude!),
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
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
                                          LatLng(pointCurrent!.latitude!,
                                              pointCurrent!.longitude!),
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
                                          LatLng(pointCurrent!.latitude!,
                                              pointCurrent!.longitude!),
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
                                          LatLng(pointCurrent!.latitude!,
                                              pointCurrent!.longitude!),
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
                                      setState(() {
                                        getRoute(
                                            LatLng(pointCurrent!.latitude!,
                                                pointCurrent!.longitude!),
                                            LatLng(item!.latitude!,
                                                item!.longitude!));
                                        isShowRoute = !isShowRoute!;
                                      });
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
                        : CircularProgressIndicator(),
                  ),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Container(
                    width: AppDimention.screenWidth,
                    child: Row(
                      children: [
                        SizedBox(width: AppDimention.size10),
                        Icon(
                          Icons.feed,
                          size: AppDimention.size30,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: AppDimention.size10,
                        ),
                        Text(
                          "Phí vận chuyển : ${mathfunction.formatNumber(item!.shippingFee!.toInt())} vnđ",
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.size120,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 30,
                          left: 0,
                          child: Container(
                            width: AppDimention.screenWidth,
                            height: AppDimention.size10,
                            decoration: BoxDecoration(
                                color: Appcolor.mainColor,
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size10)),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: AppDimention.screenWidth,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              color: liststatus[0]
                                                  ? Colors.green
                                                  : Colors.black26,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppDimention.size30)),
                                          child: Center(
                                            child: Icon(
                                              Icons.receipt_long_rounded,
                                              color: Colors.white,
                                            ),
                                          )),
                                      Container(
                                        width: AppDimention.size80,
                                        child: Center(
                                          child: Text(
                                            "Đơn hàng mới",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                
                                    Column(
                                      children: [
                                        Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                // color: Colors.yellow,
                                                color: liststatus[1]
                                                    ? Colors.yellow
                                                    : Colors.black26,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppDimention.size30)),
                                            child: Center(
                                              child: Icon(
                                                Icons.outbox_rounded,
                                                color: Colors.white,
                                              ),
                                            )),
                                        Container(
                                          width: AppDimention.size60,
                                          child: Center(
                                            child: Text(
                                              "Đã xác nhận",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  Column(
                                    children: [
                                      Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              // color: Colors.blue,
                                              color: liststatus[2]
                                                  ? Colors.blue
                                                  : Colors.black26,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppDimention.size30)),
                                          child: Center(
                                            child: Icon(
                                              Icons.delivery_dining,
                                              color: Colors.white,
                                            ),
                                          )),
                                      Container(
                                        width: AppDimention.size60,
                                        child: Center(
                                          child: Text(
                                            "Đang giao",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              // color: Colors.red,
                                              color: liststatus[3]
                                                  ? Colors.orange
                                                  : Colors.black26,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppDimention.size30)),
                                          child: Center(
                                            child: Icon(
                                              Icons.check_box,
                                              color: Colors.white,
                                            ),
                                          )),
                                      Container(
                                        width: AppDimention.size60,
                                        child: Center(
                                          child: Text(
                                            "Hoàn thành",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    width: AppDimention.screenWidth,
                    padding: EdgeInsets.only(left: AppDimention.size20),
                    child: Text("Thông tin khách hàng",
                        style: TextStyle(
                          fontSize: AppDimention.size20,
                        )),
                  ),
                  SizedBox(
                    height: AppDimention.size10,
                  ),
                  Container(
                    width: AppDimention.screenWidth,
                    margin: EdgeInsets.only(
                        left: AppDimention.size10, right: AppDimention.size10),
                    padding: EdgeInsets.all(AppDimention.size20),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black26),
                        borderRadius:
                            BorderRadius.circular(AppDimention.size10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Họ tên : ${customer!.fullName}"),
                        SizedBox(
                          height: AppDimention.size10,
                        ),
                        Text(
                          "Địa chỉ : ${customer!.address}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: AppDimention.size10,
                        ),
                        Text("Số điện thoại : ${customer!.phoneNumber}"),
                        SizedBox(
                          height: AppDimention.size10,
                        ),
                        Text("Email : ${customer!.email}"),
                        SizedBox(
                          height: AppDimention.size20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _ShowSendMessage(
                                    "${customer!.email}", "${item!.orderCode}");
                              },
                              child: Container(
                                width: AppDimention.size100,
                                height: AppDimention.size50,
                                decoration: BoxDecoration(
                                    color: Appcolor.mainColor,
                                    borderRadius: BorderRadius.circular(
                                        AppDimention.size10)),
                                child: Center(
                                  child: Icon(
                                    Icons.email,
                                    color: Colors.white,
                                    size: AppDimention.size30,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _sendSMS("${customer!.phoneNumber}");
                              },
                              child: Container(
                                width: AppDimention.size100,
                                height: AppDimention.size50,
                                decoration: BoxDecoration(
                                    color: Appcolor.mainColor,
                                    borderRadius: BorderRadius.circular(
                                        AppDimention.size10)),
                                child: Center(
                                  child: Icon(
                                    Icons.pending,
                                    color: Colors.white,
                                    size: AppDimention.size30,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  _makePhoneCall("${customer!.phoneNumber}");
                                },
                                child: Container(
                                  width: AppDimention.size100,
                                  height: AppDimention.size50,
                                  decoration: BoxDecoration(
                                      color: Appcolor.mainColor,
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size10)),
                                  child: Center(
                                    child: Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                      size: AppDimention.size30,
                                    ),
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppDimention.size30,
                  ),
                  Container(
                    width: AppDimention.screenWidth,
                    padding: EdgeInsets.only(left: AppDimention.size20),
                    child: Text("Thông tin đơn hàng",
                        style: TextStyle(
                          fontSize: AppDimention.size20,
                        )),
                  ),
                  SizedBox(
                    height: AppDimention.size10,
                  ),
                  Container(
                      width: AppDimention.screenWidth,
                      margin: EdgeInsets.only(
                          left: AppDimention.size10,
                          right: AppDimention.size10),
                      padding: EdgeInsets.only(
                          left: AppDimention.size20,
                          right: AppDimention.size20,
                          bottom: AppDimention.size20),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black26),
                          borderRadius:
                              BorderRadius.circular(AppDimention.size10)),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: item!.orderDetails!.length,
                          itemBuilder: (context, index) {
                            OrderDetails orderDetails = item!.orderDetails![index];
                            ProductDetail? productDetail;
                            ComboDetail? comboDetail;
                            bool? key;
                            if(orderDetails.type == "product")
                            {
                              productDetail = orderDetails.productDetail;
                              key = true;
                          }
                            else
                            {
                              comboDetail = orderDetails.comboDetail;
                              key = false;
                            }
                            return key ? Container(
                              width: AppDimention.screenWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${productDetail!.productName}",
                                      style: TextStyle(
                                          fontSize: AppDimention.size20,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(
                                    height: AppDimention.size5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Size : ${productDetail.size}"),
                                      Text("SL : ${productDetail.quantity}"),
                                      Text("Giá : ${_formatNumber(productDetail.unitPrice!.toInt())}"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: AppDimention.size10,
                                  )
                                ],
                              ),
                            ): 
                             Container(
                              width: AppDimention.screenWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${comboDetail!.comboId}",
                                      style: TextStyle(
                                          fontSize: AppDimention.size20,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(
                                    height: AppDimention.size5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Size : M"),
                                      Text("SL : 5"),
                                      Text("Giá : 20.000 vnđ"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: AppDimention.size10,
                                  )
                                ],
                              ),
                            );
                          })),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  SizedBox(
                    height: AppDimention.size30,
                    width: AppDimention.screenWidth,
                    child: Container(
                      width: AppDimention.screenWidth,
                      decoration: BoxDecoration(
                          border: Border(top: BorderSide(width: 1))),
                    ),
                  ),
                  Container(
                    width: AppDimention.screenWidth,
                    padding: EdgeInsets.only(left: AppDimention.size20),
                    child: Text("Thông tin chi tiết",
                        style: TextStyle(
                          fontSize: AppDimention.size20,
                        )),
                  ),
                  SizedBox(
                    height: AppDimention.size10,
                  ),
                  Container(
                    width: AppDimention.screenWidth,
                    margin: EdgeInsets.only(
                        left: AppDimention.size10, right: AppDimention.size10),
                    padding: EdgeInsets.all(AppDimention.size20),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black26),
                        borderRadius:
                            BorderRadius.circular(AppDimention.size10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Địa chỉ giao hàng : ${item!.deliveryAddress}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: AppDimention.size20,
                        ),
                        Text("Phương thức thanh toán :"),
                        SizedBox(
                          height: AppDimention.size20,
                        ),
                        Text(
                            "Ghi chú :"),
                        SizedBox(
                          height: AppDimention.size20,
                        ),
                        Text("Tổng đơn hàng : 500.000 vnđ"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppDimention.size20,
                  )
                ],
              ),
            )),
            Container(
                width: AppDimention.screenWidth,
                height: AppDimention.size70,
                decoration: BoxDecoration(color: Appcolor.mainColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: AppDimention.size150,
                      height: AppDimention.size50,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppDimention.size10)),
                      child: Center(
                        child: Text(
                          "500.000 vnđ",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _changeStatus();
                       
                      },
                      child: Container(
                        width: AppDimention.size150 + AppDimention.size50,
                        height: AppDimention.size50,
                        margin: EdgeInsets.only(right: AppDimention.size10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(AppDimention.size10)),
                        child: Center(
                          child: Text(
                            "Chuyển trạng thái",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      );
   
  }
}
