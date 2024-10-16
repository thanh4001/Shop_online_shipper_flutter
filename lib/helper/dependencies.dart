
import 'package:flutter_shipper_github/data/api/ApiClient.dart';
import 'package:flutter_shipper_github/data/api/AppConstant.dart';

import 'package:flutter_shipper_github/data/controller/AuthController.dart';
import 'package:flutter_shipper_github/data/controller/OrderController.dart';
import 'package:flutter_shipper_github/data/controller/Store_Controller.dart';
import 'package:flutter_shipper_github/data/repository/AuthRepo.dart';
import 'package:flutter_shipper_github/data/repository/OrderRepo.dart';
import 'package:flutter_shipper_github/data/repository/Store_repo.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  // api client
  Get.lazyPut(() => ApiClient(appBaseUrl: Appconstant.BASE_URL));

  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));

  Get.lazyPut(() => StoreRepo(apiClient: Get.find()));
  Get.lazyPut(() => Storecontroller(storeRepo: Get.find()));

  Get.lazyPut(() => Orderrepo(apiClient: Get.find()));
  Get.lazyPut(() => Ordercontroller(orderrepo: Get.find()));

  
}
