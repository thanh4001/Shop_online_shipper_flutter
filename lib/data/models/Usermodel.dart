import 'package:flutter_shipper_github/data/models/Item/Useritem.dart';

class Usermodel {
  bool? success;
  String? message;
  Useritem? user;
  Useritem? get getuser => user;

  Usermodel({this.success, this.message, this.user});

  Usermodel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    user = json['data'] != null ? new Useritem.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.user != null) {
      data['data'] = this.user!.toJson();
    }
    return data;
  }
}
