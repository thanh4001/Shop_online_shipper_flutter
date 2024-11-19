import 'package:flutter_shipper_github/data/FunctionApp/MapFuntion.dart';
import 'package:flutter_shipper_github/data/controller/AuthController.dart';
import 'package:flutter_shipper_github/data/dto/RegisterDto.dart';
import 'package:flutter_shipper_github/data/dto/UserLoginDto.dart';
import 'package:flutter_shipper_github/route/app_route.dart';
import 'package:flutter_shipper_github/themes/AppColor.dart';
import 'package:flutter_shipper_github/themes/AppDimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController homenumbercontroller = TextEditingController();
  final PageController pageController = PageController(viewportFraction: 1);
  bool isHidden = true;
  String? selectedProvince;
  List<String> provinces = [];
  String? selectedDistrict;
  List<String> districts = [];
  Mapfuntion functionMap = Mapfuntion();
  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      if (pageController.page != null && pageController.page == 2) {
        pageController.animateToPage(0,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });
    loadProvince();
  }

  void loadProvince() async {
    provinces = await functionMap.listProvinces();
    setState(() {});
  }

  void loadDistrict() async {
    while (selectedProvince == null) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    districts = await functionMap.listDistrict(selectedProvince!);
    setState(() {});
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  String announce = "";
  void _HandleLogin() {
    if (phoneController.text == null ||
        fullNameController.text == null ||
        emailController.text == null ||
        selectedProvince == null ||
        selectedDistrict == null ||
        homenumbercontroller.text == null ||
        passwordController.text == null ||
        repasswordController.text == null ||
        codeController.text == null) {
      setState(() {
        announce = "Vui lòng nhập đủ thông tin";
        return;
      });
    } else {
      if (repasswordController.text != passwordController.text) {
        setState(() {
          announce = "Mật khẩu không trùng khớp";
          return;
        });
      }
      final RegExp passwordRegExp = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
      );
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(emailController.text)) {
        setState(() {
          announce = "Email không đúng định dạng";
          return;
        });
      }
      if (!passwordRegExp.hasMatch(passwordController.text)) {
        setState(() {
          announce =
              "Mật khẩu phải chứa ít nhất một ký tự viết thường, viết hoa, số và ký tự đặc biệt";
          return;
        });
      }
      String address = homenumbercontroller.text +
          "|@##@|" +
          selectedDistrict.toString() +
          "|@##@|" +
          selectedProvince.toString();
      Registerdto dto = Registerdto(
          address: address,
          code: codeController.text,
          email: emailController.text,
          fullName: fullNameController.text,
          phoneNumber: phoneController.text,
          password: passwordController.text);
      Get.find<AuthController>().register(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                width: AppDimention.screenWidth,
                height: AppDimention.screenHeight,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.screenHeight * 0.6,
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: 2,
                          itemBuilder: (context, position) {
                            return _buildView(position);
                          },
                        ),
                      ),
                      Container(
                        width: AppDimention.screenWidth,
                        child: Container(
                          padding: EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Appcolor.mainColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTextField(
                                controller: phoneController,
                                hintText: "Số điện thoại",
                                prefixIcon: Icons.phone,
                              ),
                              SizedBox(height: AppDimention.size20),
                              _buildTextField(
                                controller: fullNameController,
                                hintText: "Họ và tên",
                                prefixIcon: Icons.people,
                              ),
                              SizedBox(height: AppDimention.size20),
                              _buildTextField(
                                controller: emailController,
                                hintText: "Email",
                                prefixIcon: Icons.email,
                              ),
                              SizedBox(height: AppDimention.size20),
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
                                    hintStyle: TextStyle(
                                        color: Colors.black26, fontSize: 13),
                                    prefixIcon: Icon(
                                      Icons.location_city,
                                      color: Colors.amber,
                                      size: AppDimention.size25,
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: AppDimention.size15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size5),
                                      borderSide: BorderSide(
                                          width: 1.0, color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size30),
                                      borderSide: BorderSide(
                                          width: 1.0, color: Colors.white),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size10),
                                    ),
                                  ),
                                  items: provinces
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
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
                                height: 20,
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
                                    hintStyle: TextStyle(
                                        color: Colors.black26, fontSize: 13),
                                    prefixIcon: Icon(
                                      Icons.location_city,
                                      color: Colors.amber,
                                      size: AppDimention.size25,
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: AppDimention.size15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size5),
                                      borderSide: BorderSide(
                                          width: 1.0, color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size30),
                                      borderSide: BorderSide(
                                          width: 1.0, color: Colors.white),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size10),
                                    ),
                                  ),
                                  items: districts
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
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
                                height: AppDimention.size20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: TextField(
                                  controller: homenumbercontroller,
                                  decoration: InputDecoration(
                                    hintText: "Số nhà , đường ...",
                                    hintStyle: TextStyle(
                                        color: Colors.black26, fontSize: 13),
                                    prefixIcon: Icon(
                                      Icons.roundabout_left_outlined,
                                      color: Colors.amberAccent,
                                      size: AppDimention.size25,
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: AppDimention.size15),
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
                              ),
                              SizedBox(
                                height: AppDimention.size20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
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
                                  controller: passwordController,
                                  obscureText: isHidden,
                                  decoration: InputDecoration(
                                    hintText: "Mật khẩu",
                                    hintStyle: TextStyle(color: Colors.black26),
                                    prefixIcon:
                                        GestureDetector(
                                          onTap: (){
                                              setState(() {
                                                isHidden = !isHidden;
                                              });
                                          },
                                          child: Icon(Icons.lock, color: Colors.amber),
                                        ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide: BorderSide(
                                          width: 1.0, color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide: BorderSide(
                                          width: 1.0, color: Colors.white),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: AppDimention.size20),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
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
                                  controller: repasswordController,
                                  obscureText: isHidden,
                                  decoration: InputDecoration(
                                    hintText: "Xác nhận mật khẩu",
                                    hintStyle: TextStyle(color: Colors.black26),
                                    prefixIcon:
                                        GestureDetector(
                                          onTap: (){
                                              setState(() {
                                                isHidden = !isHidden;
                                              });
                                          },
                                          child: Icon(Icons.lock, color: Colors.amber),
                                        ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide: BorderSide(
                                          width: 1.0, color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide: BorderSide(
                                          width: 1.0, color: Colors.white),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: AppDimention.size20),
                              _buildTextField(
                                controller: codeController,
                                hintText: "Mã đăng kí",
                                prefixIcon: Icons.code_off_outlined,
                              ),
                              SizedBox(height: AppDimention.size10),
                              Center(
                                child: Text(
                                  announce,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: AppDimention.size10),
                              Center(
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                    Container(
                                      width: AppDimention.size100 * 2,
                                      height: AppDimention.size50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            AppDimention.size10),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          _HandleLogin();
                                        },
                                        child: Center(
                                          child: Text(
                                            "Đăng kí",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Appcolor.mainColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: AppDimention.size100 * 0.88,
                                      height: AppDimention.size50,
                                      margin: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            AppDimention.size10),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.toNamed(AppRoute.LOGIN_PAGE);
                                        },
                                        child: Center(
                                          child: Text(
                                            "Đăng nhập",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Appcolor.mainColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildView(int index) {
    return Container(
      width: AppDimention.screenWidth,
      height: AppDimention.screenHeight,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(index == 0
                  ? "assets/image/anh_1.jpg"
                  : "assets/image/anh_2.jpg"))),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black26),
          prefixIcon: Icon(prefixIcon, color: Colors.amber),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(width: 1.0, color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(width: 1.0, color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }
}
