import 'package:flutter_shipper_github/data/controller/Store_Controller.dart';
import 'package:flutter_shipper_github/data/models/Item/Storeitem.dart';
import 'package:flutter_shipper_github/route/app_route.dart';
import 'package:flutter_shipper_github/themes/AppColor.dart';
import 'package:flutter_shipper_github/themes/AppDimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeList extends StatefulWidget {
  const HomeList({
    Key? key,
  }) : super(key: key);
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
   String formatTime(String isoDateTime) {
    DateTime dateTime = DateTime.parse(isoDateTime);
    return DateFormat('hh:mm a').format(dateTime);
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Storecontroller>(builder: (storeControler) {
      return storeControler.getisLoading
          ? CircularProgressIndicator()
          : ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: storeControler.getstoreList.length,
              itemBuilder: (context, index) {
                Storesitem item = storeControler.getstoreList[index];
                return Container(
                  width: AppDimention.screenWidth,
                  margin: EdgeInsets.only(
                      left: AppDimention.size10,
                      right: AppDimention.size10,
                      top: AppDimention.size20),
                  padding: EdgeInsets.all(AppDimention.size20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        AppDimention.size10,
                      ),
                      border: Border.all(width: 1, color: Colors.black12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppDimention.screenWidth,
                        padding: EdgeInsets.only(bottom: AppDimention.size10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Colors.black12))),
                        child: Text(
                          "Cửa hàng số ${item.storeId}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: AppDimention.size10,
                      ),
                      Text(
                        "${item.storeName}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      SizedBox(
                        height: AppDimention.size10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.blueAccent,
                            size: AppDimention.size20,
                          ),
                          SizedBox(
                            width: AppDimention.size10,
                          ),
                          Container(
                            width:
                                AppDimention.screenWidth - AppDimention.size100,
                            child: Text(
                              "${item.location}",
                              style:
                                  TextStyle(color: Colors.black87, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                        
                      ),
                      SizedBox(
                        height: AppDimention.size10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.redAccent,
                            size: AppDimention.size20,
                          ),
                          SizedBox(
                            width: AppDimention.size10,
                          ),
                          Container(
                            width:
                                AppDimention.screenWidth - AppDimention.size100,
                            child: Text(
                              "${item.numberPhone}",
                              style:
                                  TextStyle(color: Colors.black87, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                        
                      ),
                      SizedBox(
                        height: AppDimention.size10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.timelapse_rounded,
                            color: Colors.amberAccent,
                            size: AppDimention.size20,
                          ),
                          SizedBox(
                            width: AppDimention.size10,
                          ),
                          Container(
                            width:
                                AppDimention.screenWidth - AppDimention.size100,
                            child: Text(
                               formatTime(item.openingTime!) +
                                    " - " +
                                    formatTime(item.closingTime!),
                              style:
                                  TextStyle(color: Colors.black87, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                        
                      ),
                      SizedBox(
                        height: AppDimention.size20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoute.get_store_detail(index));
                        },
                        child: Center(
                          child: Container(
                            width: AppDimention.size120,
                            height: AppDimention.size40,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Appcolor.mainColor,
                                ),
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size10)),
                            child: Center(
                              child: Text(
                                "Xem chi tiết",
                                style: TextStyle(
                                  color: Appcolor.mainColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
    });
  }
}
