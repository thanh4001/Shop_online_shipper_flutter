import 'package:flutter_shipper_github/data/controller/AuthController.dart';
import 'package:flutter_shipper_github/data/controller/Store_Controller.dart';
import 'package:flutter_shipper_github/data/service/OrderCheckService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_shipper_github/helper/dependencies.dart' as dep;
import 'package:flutter_shipper_github/route/app_page.dart';
import 'package:flutter_shipper_github/route/app_route.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_shipper_github/data/controller/OrderController.dart'; // Import Ordercontroller
import 'package:permission_handler/permission_handler.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  await initNotifications();
  await Get.putAsync(() => OrderCheckService().initService());
   await requestLocationPermission();
  runApp(const MyApp());
}
Future<void> requestLocationPermission() async {
  var status = await Permission.location.status;
  if (status.isDenied) {
    status = await Permission.location.request();
    if (status.isDenied) {
      // Xử lý khi quyền bị từ chối
      print("User denied location permissions.");
      // Hiển thị thông báo hoặc điều hướng người dùng đến trang cài đặt
    }
  }
}
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  @override
  Widget build(BuildContext context) {
     final authController = Get.find<AuthController>();

    return Obx(() {
      if (authController.IsLogin.value) {
        Get.find<Storecontroller>().getall();
      
      }
    return GetMaterialApp(
      initialRoute: AppRoute.LOGIN_PAGE,
      getPages: AppPage.list,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
    );
  });
  }
}
