import 'package:flutter_shipper_github/data/api/ApiClient.dart';
import 'package:flutter_shipper_github/data/dto/ShipperRequest.dart';
import 'package:flutter_shipper_github/data/dto/UserLoginDto.dart';
import 'package:flutter_shipper_github/data/models/Item/Useritem.dart';
import 'package:flutter_shipper_github/data/models/UserModelV2.dart';
import 'package:flutter_shipper_github/data/models/Usermodel.dart';
import 'package:flutter_shipper_github/data/repository/AuthRepo.dart';

import 'package:get/get.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  var IsLogin = false.obs;
  AuthController({
    required this.authRepo,
  });
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String validateLogin = "";
  String get getvalidateLogin => validateLogin;

  Useritem? user;
  Useritem? get getuser => user;

  Future<void> updateProfile(Shipperrequest request) async {
    Response response = await authRepo.updateProfile(request);
    if (response.statusCode == 200) {
      Get.snackbar("Thông báo", "Cập nhật thành công");
    } else {
      print("Lỗi cập nhật thông tin người dùng ${response.statusCode}");
    }
  }
  bool? isLoadingProfile ;
  bool? get getLoadingProfile => isLoadingProfile;
  User? userProfile;
  User? get getuserProfile => userProfile;

  Future<void> getProfile() async {
    isLoadingProfile = true;
    Response response = await authRepo.getProfile();
    if (response.statusCode == 200) {
      var data = response.body;

      userProfile = UsermodelV2.fromJson(data).getuser;
      print("Lấy dữ liệu thành công");
      
      update();
    } else {
      print("Lỗi dữ liệu lấy thông tin ${response.statusCode}");
    }
    isLoadingProfile = false;
    update();
  }
  Future<User?> getCustomerProfile(int id) async {
    Response response = await authRepo.getCutomerProfile(id);
    if (response.statusCode == 200) {
      var data = response.body;
      return UsermodelV2.fromJson(data).getuser!;
      
    } else {
      print("Lỗi lấy thông tin khách hàng ${response.statusCode}");
    }
}

  // Login funtion
  Future<bool> login(Userlogindto dto) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(dto);

    if (response.statusCode == 200) {
      var data = response.body;

      // Get user logined
      user = Usermodel.fromJson(data).getuser;

      if (user!.roles![0] == "ROLE_SHIPPER") {
        String newToken = data["data"]["token"];
        authRepo.saveUserToken(newToken);
        Get.find<ApiClient>().updateHeader(newToken);
        // Update value validate;
        IsLogin.value = true;
        update();
        return true;
      } else {
        return false;
      }
      // Save token in header
    } else {
      IsLogin.value = false;
      validateLogin = response.body["message"];
      update();
      return false;
    }
  }
}
