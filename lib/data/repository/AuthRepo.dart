

import 'package:flutter_shipper_github/data/api/ApiClient.dart';
import 'package:flutter_shipper_github/data/api/AppConstant.dart';
import 'package:flutter_shipper_github/data/dto/ShipperRequest.dart';
import 'package:flutter_shipper_github/data/dto/UserLoginDto.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });
  Future<Response> login(Userlogindto dto) async {
    return await apiClient.postData(Appconstant.LOGIN_URL, dto.toJson());
  }
  Future<Response> updateProfile(Shipperrequest request) async {
    return await apiClient.postData(Appconstant.UPDATE_PROFILE_URL, request.toJson());
  }
  Future<Response> getProfile() async {
    return await apiClient.getData(Appconstant.GET_PROFILE_URL);
  }
  Future<Response> getCutomerProfile(int userid) async {
    return await apiClient.getData(Appconstant.CUSTOMER_PROFILE_URL.replaceFirst("{id}", userid.toString()));
  }

  saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(Appconstant.TOKEN, token);
  }
}
