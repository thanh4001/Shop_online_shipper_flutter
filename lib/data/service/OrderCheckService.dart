import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_shipper_github/data/controller/OrderController.dart';
class OrderCheckService extends GetxService {
  Timer? _timer;
  int? previousLength;
  late Ordercontroller orderController;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<OrderCheckService> initService() async {
    orderController = Get.find<Ordercontroller>();
    _timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) async {
      int currentLength = orderController.orderlist.length;

      if (currentLength == 0) {
        await orderController.getall();
      } else if (previousLength == 0 && currentLength > 0) {
       
        await showNotification();
      }

      previousLength = currentLength;
    });

    return this;
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Thông báo',
      'Có đơn hàng mới',
      platformChannelSpecifics,
    );
  }

  @override
  void onClose() {
   
    _timer?.cancel();
    super.onClose();
  }
}
