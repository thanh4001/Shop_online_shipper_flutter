import 'package:flutter_shipper_github/pages/profile_page/profile_body.dart';
import 'package:flutter_shipper_github/pages/profile_page/profile_footer.dart';
import 'package:flutter_shipper_github/pages/profile_page/profile_header.dart';
import 'package:flutter/material.dart';
class ProfilePage extends StatefulWidget{
   const ProfilePage({
       Key? key,
   }): super(key:key);
   @override
   _ProfilePageState createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage>{
   @override
   Widget build(BuildContext context) {
      return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                  ProfileHeader(),
                  ProfileBody(),
              ],
            ),
          )),
          ProfileFooter()
        ],
      ),
    );
   }
}