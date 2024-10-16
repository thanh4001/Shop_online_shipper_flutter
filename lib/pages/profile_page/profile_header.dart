import 'package:flutter_shipper_github/themes/AppColor.dart';
import 'package:flutter_shipper_github/themes/AppDimention.dart';
import 'package:flutter/material.dart';
class ProfileHeader extends StatefulWidget{
   const ProfileHeader({
       Key? key,
   }): super(key:key);
   @override
   _ProfileHeaderState createState() => _ProfileHeaderState();
}
class _ProfileHeaderState extends State<ProfileHeader>{
   @override
   Widget build(BuildContext context) {
       return Container(
        width: AppDimention.screenWidth,
        height: AppDimention.size100 * 2.5,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: AppDimention.screenWidth,
                height: AppDimention.size100 * 2,
                decoration: BoxDecoration(
                  color: Appcolor.mainColor
                ),
              ),
            ),
            Positioned(
              top: AppDimention.size100,
              left: 0,
              child: Container(
                width: AppDimention.size150,
                height: AppDimention.size150,
                margin: EdgeInsets.only(left: AppDimention.screenWidth / 2 - AppDimention.size150/2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(AppDimention.size100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5), 
                      spreadRadius: 5, 
                      blurRadius: 7, 
                      offset: Offset(0, 2), 
                    ),
                  ],
                
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      "assets/image/anh_1.jpg"
                    ))
                ),
              ),
            )
          ],
        ),
       );
   }
}