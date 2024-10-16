import 'package:flutter_shipper_github/data/models/Item/Storeitem.dart';
import 'package:flutter_shipper_github/data/models/StoreModel.dart';
import 'package:flutter_shipper_github/data/repository/Store_repo.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Storecontroller extends GetxController {
  final StoreRepo storeRepo;
  Storecontroller({
    required this.storeRepo,
  });
  bool isLoading = false;
  bool get getisLoading => isLoading;

  List<Storesitem> storeList = [];
  List<Storesitem> get getstoreList => storeList;

  Future<void> getall() async {
    isLoading = true;
    Response response = await storeRepo.getall();

    if (response.statusCode == 200) {
      var data = response.body;
      storeList = [];
      storeList.addAll(Storesmodel.fromJson(data).get_liststores ?? []);

      print("Lấy dữ liệu danh sách cửa hàng thành công");
    } 
    else {
      print("Lỗi không lấy được danh sách cửa hàng : " +response.statusCode.toString());
    }
    
    isLoading = false;
    update();
  }
  Storesitem? getstorebyid(int id){
    for(Storesitem item in storeList){
      if(item.storeId == id){
        return item;
      }
    }
    return null;
  }
}
