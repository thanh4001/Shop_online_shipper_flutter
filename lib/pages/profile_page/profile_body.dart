import 'package:flutter_shipper_github/themes/AppColor.dart';
import 'package:flutter_shipper_github/themes/AppDimention.dart';
import 'package:flutter/material.dart';
class ProfileBody extends StatefulWidget{
   const ProfileBody({
       Key? key,
   }): super(key:key);
   @override
   _ProfileBodyState createState() => _ProfileBodyState();
}
class _ProfileBodyState extends State<ProfileBody>{
  TextEditingController fullnamecontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController newpasswordcontroller = TextEditingController();
  TextEditingController repasswordcontroller = TextEditingController();

  bool _showFormChangePassword = false;
  bool _showValidateChangePasswordForm = false;
  String _validateChangePasswordValue = "";

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
      return Container(
        width: AppDimention.screenWidth,
        margin: EdgeInsets.only(left: AppDimention.size20,right: AppDimention.size20,top: AppDimention.size20),
        child: Column(
          children: [
              Container(
                width: AppDimention.screenWidth,
              
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimention.size10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: AppDimention.size10,
                      spreadRadius: 7,
                      offset: Offset(1, 10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: fullnamecontroller,
                  decoration: InputDecoration(
                    hintText: "Nguyễn Văn Nhật",
                    prefixIcon: Icon(Icons.nest_cam_wired_stand_outlined, color: Colors.amber),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                      borderSide: BorderSide(width: 1.0, color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                      borderSide: BorderSide(width: 1.0, color: Colors.white),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                    ),
                  ),
                ),
              ),
              Container(
                width: AppDimention.screenWidth,
                margin: EdgeInsets.only(top: AppDimention.size20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimention.size10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: AppDimention.size10,
                      spreadRadius: 7,
                      offset: Offset(1, 10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: phonecontroller,
                  decoration: InputDecoration(
                    hintText: "0799 162 083",
                    prefixIcon: Icon(Icons.phone, color: Colors.amber),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                      borderSide: BorderSide(width: 1.0, color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                      borderSide: BorderSide(width: 1.0, color: Colors.white),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                    ),
                  ),
                ),
              ),
              Container(
                width: AppDimention.screenWidth,
                margin: EdgeInsets.only(top: AppDimention.size20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimention.size10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: AppDimention.size10,
                      spreadRadius: 7,
                      offset: Offset(1, 10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: emailcontroller,
                  decoration: InputDecoration(
                    hintText: "nhat@gmail.com",
                    prefixIcon: Icon(Icons.email, color: Colors.amber),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                      borderSide: BorderSide(width: 1.0, color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                      borderSide: BorderSide(width: 1.0, color: Colors.white),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                    ),
                  ),
                ),
              ),
              Container(
                width: AppDimention.screenWidth,
                margin: EdgeInsets.only(top: AppDimention.size20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimention.size10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: AppDimention.size10,
                      spreadRadius: 7,
                      offset: Offset(1, 10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: addresscontroller,
                  decoration: InputDecoration(
                    hintText: "54 Nguyễn Lương Bằng , Hòa Khánh Bắc , Liển Chiểu , Đà Nẵng",
                    prefixIcon: Icon(Icons.location_on_outlined, color: Colors.amber),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                      borderSide: BorderSide(width: 1.0, color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                      borderSide: BorderSide(width: 1.0, color: Colors.white),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppDimention.size20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    GestureDetector(
                      onTap:() {
                        setState(() {
                          _showFormChangePassword = !_showFormChangePassword;
                        });
                      },
                      child:Text("Đổi mật khẩu") ,
                    ),
                    GestureDetector(
                      onTap:() {

                      },
                      child:Text("Lưu thay đổi") ,
                    ),
                ],
              ),
              SizedBox(height: AppDimention.size10,),
              if(_showFormChangePassword)
                  Container(
                      width: AppDimention.screenWidth,
                      height: AppDimention.size170 * 2 + AppDimention.size60,
                   
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
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
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
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
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
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
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
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
                                    borderRadius: BorderRadius.circular(
                                        AppDimention.size10)),
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