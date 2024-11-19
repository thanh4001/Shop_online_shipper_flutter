import 'package:flutter_shipper_github/data/FunctionApp/MapFuntion.dart';
import 'package:flutter_shipper_github/data/FunctionApp/Point.dart';
import 'package:flutter_shipper_github/data/controller/AuthController.dart';
import 'package:flutter_shipper_github/data/dto/ShipperRequest.dart';
import 'package:flutter_shipper_github/data/dto/UpdateDto.dart';
import 'package:flutter_shipper_github/data/models/Item/Useritem.dart';
import 'package:flutter_shipper_github/data/models/UserModelV2.dart';
import 'package:flutter_shipper_github/pages/profile_page/profile_page.dart';
import 'package:flutter_shipper_github/route/app_route.dart';
import 'package:flutter_shipper_github/themes/AppColor.dart';
import 'package:flutter_shipper_github/themes/AppDimention.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({
    Key? key,
  }) : super(key: key);
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  late AuthController authcontroller = Get.find<AuthController>();
  TextEditingController fullnamecontroller = TextEditingController();
  TextEditingController homenumbercontroller = TextEditingController();
  TextEditingController districtcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();

  TextEditingController phonecontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController newpasswordcontroller = TextEditingController();
  TextEditingController repasswordcontroller = TextEditingController();

  bool _showFormChangePassword = false;
  bool _showValidateChangePasswordForm = false;
  String _validateChangePasswordValue = "";
  User? user;
  String? selectedProvince;
  List<String> provinces = [];
  String? selectedDistrict;
  List<String> districts = [];
  Mapfuntion functionMap = Mapfuntion();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<AuthController>().getProfile();
    loadData();
    loadProvince();
  }

  void loadProvince() async {
    provinces = await functionMap.listProvinces();
    loadData();
    setState(() {});
  }

  void loadDistrict() async {
    while (selectedProvince == null) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    districts = await functionMap.listDistrict(selectedProvince!);
    setState(() {});
  }

  bool loaded = false;
  void loadData() async {
    loaded = false;

    while (authcontroller.getLoadingProfile!) {
      await Future.delayed(const Duration(microseconds: 100));
    }
    user = authcontroller.userProfile;
    emailcontroller.text = user!.email!;
    phonecontroller.text = user!.phoneNumber!;

    List<String> listaddress = user!.address!.split("|@##@|");
    homenumbercontroller.text = listaddress[2];
    for (String item in provinces) {
      if (item.trim().toLowerCase() == listaddress[0].toLowerCase().trim()) {
        selectedProvince = item;
      }
    }
    loadDistrict();
    while (districts.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    for (String item in districts) {
      if (item.trim().toLowerCase() == listaddress[1].toLowerCase().trim()) {
        selectedDistrict = item;
      }
    }
    loaded = true;
    setState(() {});
  }

  void _updateProfile() async {
    String fullName = fullnamecontroller.text;
    String email = emailcontroller.text;
    String avatar = "";
    String address = selectedProvince.toString()+"|@##@|"+selectedDistrict.toString()+"|@##@|"+homenumbercontroller.text;
    Point point = await functionMap.getCoordinatesFromAddress(address);

    Updatedto shipperrequest = Updatedto(
        fullName: fullName,
        avatar: avatar,
        email: email,
        address: address,);
    authcontroller.updateProfile(shipperrequest);
    Get.toNamed(AppRoute.PROFILE_PAGE);
  }

  void _changePassword() {
    String password = passwordcontroller.text;
    String newpassword = newpasswordcontroller.text;
    String repassword = repasswordcontroller.text;
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );

    setState(() {
      if (password == "" || newpassword == "" || repassword == "") {
        _validateChangePasswordValue = "Vui lòng nhập đủ thông tin";
        _showValidateChangePasswordForm = true;
      } else if (newpassword.length < 8) {
        _validateChangePasswordValue = "Mật khẩu không ít hơn 8 kí tự";
        _showValidateChangePasswordForm = true;
      } else if (!passwordRegExp.hasMatch(newpassword)) {
        _validateChangePasswordValue =
            "Mật khẩu phải chứa ít nhất một ký tự viết thường, viết hoa, số và ký tự đặc biệt";
        _showValidateChangePasswordForm = true;
      } else if (newpassword != repassword) {
        _validateChangePasswordValue = "Mật khẩu không trùng khớp";
        _showValidateChangePasswordForm = true;
      } else {
        _validateChangePasswordValue = "";
        _showValidateChangePasswordForm = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return !loaded
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            width: AppDimention.screenWidth,
            margin: EdgeInsets.only(
                left: AppDimention.size20,
                right: AppDimention.size20,
                top: AppDimention.size20),
            child: Column(
              children: [
                Container(
                  width: AppDimention.screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    
                    
                  ),
                  child: TextField(
                    controller: fullnamecontroller,
                    decoration: InputDecoration(
                      hintText: "Họ tên",
                      prefixIcon: Icon(Icons.nest_cam_wired_stand_outlined,
                          color: Colors.amber),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimention.size30),
                        borderSide: BorderSide(width: 1.0, color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimention.size30),
                        borderSide: BorderSide(width: 1.0, color: Colors.white),
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimention.size30),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: AppDimention.screenWidth,
                  margin: EdgeInsets.only(top: AppDimention.size20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    
                    
                  ),
                  child: TextField(
                    controller: phonecontroller,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: "Số điện thoại",
                      prefixIcon: Icon(Icons.phone, color: Colors.amber),
                      focusedBorder: OutlineInputBorder(
                        
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent),
                      ),
                      border: OutlineInputBorder(
                        
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: AppDimention.screenWidth,
                  margin: EdgeInsets.only(top: AppDimention.size20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    
                    
                  ),
                  child: TextField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email, color: Colors.amber),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimention.size30),
                        borderSide: BorderSide(width: 1.0, color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimention.size30),
                        borderSide: BorderSide(width: 1.0, color: Colors.white),
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimention.size30),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: AppDimention.screenWidth,
                  height: AppDimention.size60,
                 
                  decoration: BoxDecoration(
                    color: Colors.white,
                    
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedProvince,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedProvince = newValue;
                        selectedDistrict = null;
                        loadDistrict();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Tỉnh",
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 13),
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: Colors.amber,
                        size: AppDimention.size25,
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: AppDimention.size15),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimention.size5),
                        borderSide: BorderSide(width: 1.0, color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimention.size30),
                        borderSide: BorderSide(width: 1.0, color: Colors.white),
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimention.size10),
                      ),
                    ),
                    items:
                        provinces.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: AppDimention.screenWidth,
                  height: AppDimention.size60,
                 
                  decoration: BoxDecoration(
                    color: Colors.white,
                    
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedDistrict,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDistrict = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Quận / huyện",
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 13),
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: Colors.amber,
                        size: AppDimention.size25,
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: AppDimention.size15),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimention.size5),
                        borderSide: BorderSide(width: 1.0, color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimention.size30),
                        borderSide: BorderSide(width: 1.0, color: Colors.white),
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimention.size10),
                      ),
                    ),
                    items:
                        districts.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: AppDimention.size10,
                ),
                Container(
                 
                  decoration: BoxDecoration(color: Colors.white, ),
                  child: TextField(
                    controller: homenumbercontroller,
                    decoration: InputDecoration(
                      hintText: "Số nhà , đường ...",
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 13),
                      prefixIcon: Icon(
                        Icons.roundabout_left_outlined,
                        color: Colors.amberAccent,
                        size: AppDimention.size25,
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: AppDimention.size15),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimention.size30),
                          borderSide:
                              BorderSide(width: 1.0, color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimention.size30),
                          borderSide:
                              BorderSide(width: 1.0, color: Colors.white)),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimention.size30),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: AppDimention.size20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showFormChangePassword = !_showFormChangePassword;
                        });
                      },
                      child: Text("Đổi mật khẩu"),
                    ),
                    GestureDetector(
                      onTap: () {
                        _updateProfile();
                      },
                      child: Text("Lưu thay đổi"),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppDimention.size10,
                ),
                if (_showFormChangePassword)
                  Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.size170 * 2 + AppDimention.size60,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius:
                            BorderRadius.circular(AppDimention.size10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: AppDimention.size20,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: AppDimention.size30),
                          child: Text("Mật khẩu cũ"),
                        ),
                        Container(
                          width: AppDimention.screenWidth,
                          height: AppDimention.size60,
                          child: Center(
                              child: Container(
                            margin: EdgeInsets.only(
                                left: AppDimention.size20,
                                right: AppDimention.size20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size30),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: AppDimention.size10,
                                      spreadRadius: 7,
                                      offset: Offset(1, 10),
                                      color: Colors.grey.withOpacity(0.2))
                                ]),
                            child: TextField(
                              controller: passwordcontroller,
                              decoration: InputDecoration(
                                hintText: "Mật khẩu cũ ...",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: Colors.amber,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppDimention.size30),
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.white)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppDimention.size30),
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.white)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                ),
                              ),
                            ),
                          )),
                        ),
                        SizedBox(
                          height: AppDimention.size10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: AppDimention.size30),
                          child: Text("Mật khẩu mới"),
                        ),
                        Container(
                          width: AppDimention.screenWidth,
                          height: AppDimention.size60,
                          child: Center(
                              child: Container(
                            margin: EdgeInsets.only(
                                left: AppDimention.size20,
                                right: AppDimention.size20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size30),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: AppDimention.size10,
                                      spreadRadius: 7,
                                      offset: Offset(1, 10),
                                      color: Colors.grey.withOpacity(0.2))
                                ]),
                            child: TextField(
                              controller: newpasswordcontroller,
                              decoration: InputDecoration(
                                hintText: "Mật khẩu mới ...",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: Colors.amber,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppDimention.size30),
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.white)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppDimention.size30),
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.white)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                ),
                              ),
                            ),
                          )),
                        ),
                        SizedBox(
                          height: AppDimention.size10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: AppDimention.size30),
                          child: Text("Xác nhận mật khẩu mới"),
                        ),
                        Container(
                          width: AppDimention.screenWidth,
                          height: AppDimention.size60,
                          child: Center(
                              child: Container(
                            margin: EdgeInsets.only(
                                left: AppDimention.size20,
                                right: AppDimention.size20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size30),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: AppDimention.size10,
                                      spreadRadius: 7,
                                      offset: Offset(1, 10),
                                      color: Colors.grey.withOpacity(0.2))
                                ]),
                            child: TextField(
                              controller: repasswordcontroller,
                              decoration: InputDecoration(
                                hintText: "Xác nhận mật khẩu ...",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: Icon(
                                  Icons.commit_sharp,
                                  color: Colors.amber,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppDimention.size30),
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.white)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppDimention.size30),
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.white)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                ),
                              ),
                            ),
                          )),
                        ),
                        SizedBox(
                          height: AppDimention.size10,
                        ),
                        if (_showValidateChangePasswordForm)
                          Container(
                            width: AppDimention.screenWidth,
                            margin: EdgeInsets.only(
                              left: AppDimention.size20,
                            ),
                            child: Center(
                              child: Text(
                                _validateChangePasswordValue,
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: AppDimention.size20,
                        ),
                        Center(
                            child: GestureDetector(
                          onTap: () {
                            _changePassword();
                          },
                          child: Container(
                            width: AppDimention.size130,
                            height: AppDimention.size40,
                            decoration: BoxDecoration(
                                color: Appcolor.mainColor,
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size10)),
                            child: Center(
                              child: Text(
                                "Đổi mật khẩu",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
              ],
            ),
          );
  }
}
