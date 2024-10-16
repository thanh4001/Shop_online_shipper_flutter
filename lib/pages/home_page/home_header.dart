import 'package:flutter_shipper_github/pages/home_page/map.dart';
import 'package:flutter_shipper_github/themes/AppColor.dart';
import 'package:flutter_shipper_github/themes/AppDimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);
  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  TextEditingController searchController = TextEditingController();  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: AppDimention.size40,
      ),
      padding: EdgeInsets.only(
        left: AppDimention.size20, 
        right: AppDimention.size20
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
               Get.to(() => MapScreen());
            },
            child: Container(
              width: AppDimention.size40,
              child: Center(
                child: Icon(
                  Icons.map_outlined,
                  color: Appcolor.mainColor,
                  size: AppDimention.size30,
                ),
              ),
            ),
          ),
          SizedBox(width: AppDimention.size10),
          Text("Bản đồ")
        ],
      ),
    );
  }
}
