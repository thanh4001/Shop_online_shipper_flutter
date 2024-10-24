import 'package:flutter_shipper_github/data/controller/OrderController.dart';
import 'package:flutter_shipper_github/data/models/OrderModel.dart';
import 'package:flutter_shipper_github/pages/order_page/order_footer.dart';
import 'package:flutter_shipper_github/route/app_route.dart';
import 'package:flutter_shipper_github/themes/AppColor.dart';
import 'package:flutter_shipper_github/themes/AppDimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    Key? key,
  }) : super(key: key);
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  OverlayEntry? overlayEntry;
  void showPopover(BuildContext context, Offset offset, String message) {
    OverlayState? overlayState = Overlay.of(context);

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + 10,
        left: offset.dx - 30,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            width: AppDimention.size100,
            child: Center(
                child: Text(
              message,
              style: TextStyle(color: Colors.grey),
            )),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry!);
    Future.delayed(Duration(milliseconds: 500), () {
      overlayEntry?.remove();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Container(
            width: AppDimention.screenWidth,
            height: AppDimention.size80,
            decoration: BoxDecoration(color: Appcolor.mainColor),
            child: Center(
               
                child:  Text(
                  "Đơn hàng của bạn",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                )
              
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                GetBuilder<Ordercontroller>(builder: (controller) {
                  return controller.isLoading
                      ? CircularProgressIndicator()
                      :controller.orderlistNotComplete.length == 0 ? Column(children: [SizedBox(height: AppDimention.size10,),Center(child: Text("Bạn chưa có đơn hàng"),)],) :  ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.orderlistNotComplete.length,
                          itemBuilder: (context, index) {
                            OrderData item = controller.orderlistNotComplete[index];
                            
                            

                            return Container(
                              width: AppDimention.screenWidth,
                              padding: EdgeInsets.all(AppDimention.size10),
                              margin: EdgeInsets.only(
                                bottom: AppDimention.size10,
                                left: AppDimention.size10,
                                right: AppDimention.size10,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: AppDimention.screenWidth,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Mã đơn hàng : ",
                                              style: TextStyle(
                                                  color: Colors.grey[500]),
                                            ),
                                            Text("${item.orderCode}")
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.toNamed(AppRoute.get_order_detail_receive(item.orderId!));
                                          },
                                          child: Container(
                                            width: AppDimention.size80,
                                            height: AppDimention.size30,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppDimention.size5),
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.black12)),
                                            child: Center(
                                              child: Text("Chi tiết"),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Phí vận chuyển : đ",
                                        style:
                                            TextStyle(color: Colors.grey[500]),
                                      ),
                                      Text("${item.shippingFee!.toInt()}")
                                    ],
                                  ),
                                  SizedBox(height: AppDimention.size20,),
                                  Row(
                                    children: [
                                      Text(
                                        "Trạng thái đơn hàng ",
                                        style:
                                            TextStyle(color: Colors.grey[500]),
                                            
                                      ),
                                    
                                    ],
                                  ),
                                  Container(
                                            width: AppDimention.screenWidth,
                                            padding: EdgeInsets.only(
                                              top: AppDimention.size10,
                                            ),
                                            child: Row(
                                              children: [
                                                if (item.status ==
                                                    "Đơn hàng mới")
                                                  Container(
                                                      width:
                                                          AppDimention.size100 *
                                                              3.4,
                                                      height:
                                                          AppDimention.size30,
                                                      child: Stack(
                                                        children: [
                                                          Positioned(
                                                            left: 10,
                                                            top: 10,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTapDown:
                                                                (details) {
                                                              showPopover(
                                                                  context,
                                                                  details
                                                                      .globalPosition,
                                                                  "Đơn hàng mới");
                                                            },
                                                            child: Icon(
                                                              Icons.circle,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          )
                                                        ],
                                                      ))
                                                else if (item.status  ==
                                                    "Đơn hàng đã được xác nhận")
                                                  Container(
                                                      width:
                                                          AppDimention.size100 *
                                                              3.4,
                                                      height:
                                                          AppDimention.size30,
                                                      child: Stack(
                                                        children: [
                                                          Positioned(
                                                            left: 10,
                                                            top: 10,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: 0,
                                                            top: 0,
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTapDown:
                                                                      (details) {
                                                                    showPopover(
                                                                        context,
                                                                        details
                                                                            .globalPosition,
                                                                        "Đơn hàng mới");
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .circle,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: AppDimention
                                                                .size110,
                                                            top: 0,
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTapDown:
                                                                      (details) {
                                                                    showPopover(
                                                                        context,
                                                                        details
                                                                            .globalPosition,
                                                                        "Đã xác nhận");
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .circle,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                else if (item.status  ==
                                                    "Đơn hàng đang giao")
                                                  Container(
                                                      width:
                                                          AppDimention.size100 *
                                                              3.4,
                                                      height:
                                                          AppDimention.size30,
                                                      child: Stack(
                                                        children: [
                                                          Positioned(
                                                            left: 10,
                                                            top: 10,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: 0,
                                                            top: 0,
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTapDown:
                                                                      (details) {
                                                                    showPopover(
                                                                        context,
                                                                        details
                                                                            .globalPosition,
                                                                        "Đơn hàng mới");
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .circle,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: AppDimention
                                                                .size110,
                                                            top: 0,
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTapDown:
                                                                      (details) {
                                                                    showPopover(
                                                                        context,
                                                                        details
                                                                            .globalPosition,
                                                                        "Đã xác nhận");
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .circle,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: AppDimention
                                                                    .size110 *
                                                                2,
                                                            top: 0,
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTapDown:
                                                                      (details) {
                                                                    showPopover(
                                                                        context,
                                                                        details
                                                                            .globalPosition,
                                                                        "Đang giao");
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .circle,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                else if (item.status  ==
                                                    "Đơn hàng đã hoàn thành")
                                                  Container(
                                                      width:
                                                          AppDimention.size100 *
                                                              3.45,
                                                      height:
                                                          AppDimention.size30,
                                                      child: Stack(
                                                        children: [
                                                          Positioned(
                                                            left: 10,
                                                            top: 10,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTapDown:
                                                                (details) {
                                                              showPopover(
                                                                  context,
                                                                  details
                                                                      .globalPosition,
                                                                  "Đã xác nhận");
                                                            },
                                                            child: Icon(
                                                              Icons.circle,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTapDown:
                                                                (details) {
                                                              showPopover(
                                                                  context,
                                                                  details
                                                                      .globalPosition,
                                                                  "Đã xác nhận");
                                                            },
                                                            child: Icon(
                                                              Icons.circle,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTapDown:
                                                                (details) {
                                                              showPopover(
                                                                  context,
                                                                  details
                                                                      .globalPosition,
                                                                  "Đã xác nhận");
                                                            },
                                                            child: Icon(
                                                              Icons.circle,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTapDown:
                                                                (details) {
                                                              showPopover(
                                                                  context,
                                                                  details
                                                                      .globalPosition,
                                                                  "Đã xác nhận");
                                                            },
                                                            child: Icon(
                                                              Icons.circle,
                                                              color: Colors.red,
                                                            ),
                                                          )
                                                        ],
                                                      ))
                                              ],
                                            ),
                                          ),
                                ],
                              ),
                            );
                          });
                })
              ],
            ),
          )),
          OrderFooter()
        ],
      ),
    );
  }
}
