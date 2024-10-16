
import 'package:flutter_shipper_github/pages/login_page/login_page.dart';
import 'package:flutter_shipper_github/route/app_route.dart';
import 'package:get/get.dart';
class AppPage {
  static var list = [
    GetPage(name:AppRoute.LOGIN_PAGE , page:() => LoginPage()),
   
  ];
}