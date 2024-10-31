import 'package:flutter_shipper_github/pages/char_page/char_page.dart';
import 'package:flutter_shipper_github/pages/home_page/home_page.dart';
import 'package:flutter_shipper_github/pages/login_page/login_page.dart';
import 'package:flutter_shipper_github/pages/order_page/order_detail_receive.dart';
import 'package:flutter_shipper_github/pages/order_page/order_page.dart';
import 'package:flutter_shipper_github/pages/profile_page/profile_page.dart';
import 'package:flutter_shipper_github/pages/store_page/order_detail.dart';
import 'package:flutter_shipper_github/pages/store_page/store_page.dart';
import 'package:flutter_shipper_github/route/app_route.dart';
import 'package:get/get.dart';
class AppPage {
  static var list = [
    GetPage(name:AppRoute.LOGIN_PAGE , page:() => LoginPage()),
    GetPage(name:AppRoute.HOME_PAGE , page:() => HomePage()),
    GetPage(name:AppRoute.CHAR_PAGE , page:() => CharPage()),
    GetPage(name:AppRoute.ORDER_PAGE , page:() => OrderPage()),
    GetPage(name:AppRoute.PROFILE_PAGE , page:() => ProfilePage()),
     GetPage(
        name: AppRoute.STORE_PAGE,
        page: () {
          var storeId = Get.parameters['storeId'];
          int storeIdInt = int.tryParse(storeId ?? '0') ?? 0;
          return StorePage(
              storeId: storeIdInt);
        }),

    GetPage(
        name: AppRoute.ORDER_DETAIL_PAGE,
        page: () {
          var orderCode = Get.parameters['orderCode'];
          int orderCodeInt = int.tryParse(orderCode ?? '0') ?? 0;
          return OrderDetail(
              orderCode: orderCodeInt);
        }),
     GetPage(
        name: AppRoute.ORDER_DETAIL_RECEIVE_PAGE,
        page: () {
          var shipperOrderId = Get.parameters['shipperOrderId'];
          int shipperOrderIdInt = int.tryParse(shipperOrderId ?? '0') ?? 0;
          return OrderDetailReceive(
              shipperOrderId: shipperOrderIdInt);
        }),
  ];
}