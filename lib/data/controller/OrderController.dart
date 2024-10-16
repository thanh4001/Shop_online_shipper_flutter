import 'package:flutter_shipper_github/data/api/ApiClient.dart';
import 'package:flutter_shipper_github/data/models/Item/Storeitem.dart';
import 'package:flutter_shipper_github/data/models/OrderModel.dart';
import 'package:flutter_shipper_github/data/models/StoreModel.dart';
import 'package:flutter_shipper_github/data/repository/OrderRepo.dart';
import 'package:flutter_shipper_github/data/repository/Store_repo.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

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
      print("Lấy dữ liệu danh sách đơn hàng thành công");
    } 
    else {
      print("Lỗi không lấy được danh sách đơn hàng : " +response.statusCode.toString());
    }
    isLoading = false;
    update();
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
        print("Lỗi cập nhât ${response.statusCode}");
        return;
      }
    }
    getall();
    Get.snackbar("Thông báo","Cập nhật thành công");
    update();
  }

}
