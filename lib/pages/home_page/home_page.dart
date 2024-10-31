import 'package:flutter_shipper_github/data/controller/AuthController.dart';
import 'package:flutter_shipper_github/pages/home_page/home_footer.dart';
import 'package:flutter_shipper_github/pages/home_page/home_header.dart';
import 'package:flutter_shipper_github/pages/home_page/home_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class HomePage extends StatefulWidget{
   const HomePage({
       Key? key,
   }): super(key:key);
   @override
   _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    
  }
  void loadData() async{
    await Get.find<AuthController>().getProfile();
  }
   @override
   Widget build(BuildContext context) {
      return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          HomeHeader(),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                  HomeList()
              ],
            ),
          )),
          HomeFooter()
        ],
      ),
    );
   }
}