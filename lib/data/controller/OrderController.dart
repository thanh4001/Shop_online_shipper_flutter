import 'package:flutter_shipper_github/data/api/ApiClient.dart';
import 'package:flutter_shipper_github/data/models/Item/Storeitem.dart';
import 'package:flutter_shipper_github/data/models/OrderModel.dart';
import 'package:flutter_shipper_github/data/models/StoreModel.dart';
import 'package:flutter_shipper_github/data/repository/OrderRepo.dart';
import 'package:flutter_shipper_github/data/repository/Store_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

class Ordercontroller extends GetxController {
  final Orderrepo orderrepo;
  Ordercontroller({
    required this.orderrepo,
  });
  bool isLoading = false;
  bool get getisLoading => isLoading;

  List<OrderData> orderlist = [];
  List<OrderData> get getorderlist => orderlist;
  Future<void> getall() async {
    isLoading = true;
    Response response = await orderrepo.getall();
    if (response.statusCode == 200) {
      var data = response.body;
      orderlist = [];
      orderlist.addAll(Ordermodels.fromJson(data).getorderlist ?? []);
    } 
    else {
      orderlist = [];
      print("Lỗi không lấy được danh sách đơn hàng : " +response.statusCode.toString());
    }
    isLoading = false;
    getllOrderNotComplete();
    update();
  }
  OrderData? getbyid(int shipperOrderId){
    for(OrderData item in orderlist){
      if(item.shipperOrderId == shipperOrderId){

        return item;
      }
    }
  }

  List<OrderData> orderlistNotComplete = [];
  List<OrderData> get getorderlistNotComplete => orderlistNotComplete;
  void getllOrderNotComplete(){
    orderlistNotComplete = [];
      for(OrderData orderData in orderlist){
        if(orderData.status != "Đã giao hàng"){
          orderlistNotComplete.add(orderData);
          update();
        }
      }
    print(orderlistNotComplete);
  }
 String formatDateV1(String deliveredAt) {
    DateTime dateTime = DateTime.parse(deliveredAt);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  List<OrderData>  getllOrderComplete(String datetime){
    List<OrderData> orderlistComplete = [];
      for(OrderData orderData in orderlist){
        if(orderData.status == "Đã giao hàng" && datetime ==formatDateV1(orderData.deliveredAt!)){
          orderlistComplete.add(orderData);
        }
      }
    return orderlistComplete;
  }
  int  getllOrderCompleteFee(String datetime){
    List<OrderData> orderlistComplete = [];
      for(OrderData orderData in orderlist){
        if(orderData.status == "Đã giao hàng" && datetime ==formatDateV1(orderData.deliveredAt!)){
          orderlistComplete.add(orderData);
        }
      }
    int totalFee = 0;
    for(OrderData orderData in orderlistComplete){
        totalFee = totalFee + orderData.shippingFee!.toInt();
    }
    return totalFee;
  }

  List<int>? getlistorderdetailid(){
    List<int> result = [];
    for(OrderDetails orderDetails in orderlist[0].orderDetails! ){
      if(orderDetails.productDetail != null){
        result.add(orderDetails.productDetail!.orderDetailId!);
      }
    }
    return result;
  }
  Future<void> updatestatus(int shipperOrderId,List<int> orderdetailId)async{
    for(int id in orderdetailId){
      Response response = await orderrepo.updatestatus(shipperOrderId, id);
      if(response.statusCode != 200){
        print("Lỗi cập nhật trạng thái đơn hàng ${response.statusCode} : ${response.body["message"]}");
      }
      else{
        Get.snackbar("Thông báo", "Cập nhật thành công");
      }
    }
    getall();
    
    update();
  }
  Future<void> finishOrder(int shipperOrderId, List<int> orderdetailId ) async{
    for(int id in orderdetailId){
      Response response = await orderrepo.finishorder(shipperOrderId, id);
      if(response.statusCode != 200){
        print("Lỗi cập nhật trạng thái đơn hàng ${response.statusCode} : ${response.body["message"]}");
      }
      else{
        Get.snackbar("Thông báo", "Cập nhật thành công");
      }
    }
    getall();
    
    update();
  }
  Future<void> acceptorder(int shipperOrderId) async{
    Response response = await orderrepo.acceptorder(shipperOrderId);
    if(response.statusCode == 200){
      Get.snackbar(
          "Thông báo",
          "Bạn vừa nhận giao một đơn hàng mới",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.black,
          icon: Icon(Icons.card_giftcard_sharp, color: Colors.green),
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 1),
          isDismissible: true,
        );
    }
    else{
      Get.snackbar(
          "Thông báo",
          "Nhận đơn hàng thất bại",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.black,
          icon: Icon(Icons.card_giftcard_sharp, color: Colors.green),
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 1),
          isDismissible: true,
        );
    }
  }

}
