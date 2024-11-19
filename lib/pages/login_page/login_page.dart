import 'package:flutter_shipper_github/data/controller/AuthController.dart';
import 'package:flutter_shipper_github/data/dto/UserLoginDto.dart';
import 'package:flutter_shipper_github/pages/register_page/register_page.dart';
import 'package:flutter_shipper_github/route/app_route.dart';
import 'package:flutter_shipper_github/themes/AppColor.dart';
import 'package:flutter_shipper_github/themes/AppDimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final PageController pageController = PageController(viewportFraction: 1);
  bool? isHidden = true;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      if (pageController.page != null && pageController.page == 2) {
        pageController.animateToPage(0,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  String announce = "";
  void _HandleLogin() {
    String username = phoneController.text;
    String password = passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        announce = "Vui lòng nhập đủ thông tin";
      });
    } else {
      Userlogindto userlogindto =
          Userlogindto(numberPhone: username, password: password);
      AuthController authController = Get.find<AuthController>();
      authController.login(userlogindto).then((status) {
        if (status) {
          Get.toNamed(AppRoute.HOME_PAGE);
        } else {
          setState(() {
            announce = authController.getvalidateLogin;
          });
        }
      });
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
                    height: AppDimention.screenHeight * 0.4,
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
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size10),
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
                              obscureText: isHidden!,
                              decoration: InputDecoration(
                                hintText: "Mật khẩu",
                                hintStyle: TextStyle(color: Colors.black26),
                                prefixIcon:
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          isHidden = !isHidden!;
                                        });
                                      },
                                      child: Icon(Icons.lock, color: Colors.amber),
                                    ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
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
                                      AppDimention.size30),
                                ),
                              ),
                            ),
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
                              child: Row(children: [
                            Container(
                              width: AppDimention.size100 * 2,
                              height: AppDimention.size50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size10),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  _HandleLogin();
                                },
                                child: Center(
                                  child: Text(
                                    "Đăng nhập",
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
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size10),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(RegisterPage());
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
                          ]))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black26),
          prefixIcon: Icon(prefixIcon, color: Colors.amber),
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
    );
  }
}
