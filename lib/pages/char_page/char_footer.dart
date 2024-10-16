import 'package:flutter_shipper_github/pages/char_page/char_first.dart';
import 'package:flutter_shipper_github/route/app_route.dart';
import 'package:flutter_shipper_github/themes/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CharFooter extends StatefulWidget {
  const CharFooter({Key? key}) : super(key: key);

  @override
  _CharFooterState createState() => _CharFooterState();
}

class _CharFooterState extends State<CharFooter> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Get.toNamed(AppRoute.HOME_PAGE);
      } else if (index == 1) {
        Get.toNamed(AppRoute.CHAR_PAGE);
      } else if (index == 2) {
       Get.toNamed(AppRoute.ORDER_PAGE);
      } else if (index == 3) {
        Get.toNamed(AppRoute.PROFILE_PAGE);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.line_axis_rounded),
          label: 'Char',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.delivery_dining),
          label: 'Order',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
       
      ],
      selectedItemColor: Appcolor.mainColor,
      unselectedItemColor: Colors.grey,
    );
  }
}
