
import 'package:flutter_shipper_github/data/api/ApiClient.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '../api/AppConstant.dart';

class Orderrepo {
  final ApiClient apiClient;
  Orderrepo({required this.apiClient});

  Future<Response> getall() async {
    return await apiClient.getData(Appconstant.ORDER_URL);
  }
  Future<Response> updatestatus(int id1,int id2) async {
    return await apiClient.postData(Appconstant.UPDATE_ORDER_URL.replaceFirst("{shipperOrderId}", id1.toString()).replaceFirst("{orderdetailId}", id2.toString()),null);
  }
  Future<Response> acceptorder(int shipperOrderId) async {
    return await apiClient.postData(Appconstant.ACCEPT_ORDER_URL.replaceFirst("{shipperOrderId}", shipperOrderId.toString()),null);
  }
  Future<Response> finishorder(int id1,int id2) async {
    return await apiClient.postData(Appconstant.FINISH_ORDER_URL.replaceFirst("{shipperOrderId}", id1.toString()).replaceFirst("{orderdetailId}", id2.toString()),null);
  }

}
