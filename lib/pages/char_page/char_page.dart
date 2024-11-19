import 'dart:math';

import 'package:flutter_shipper_github/data/controller/OrderController.dart';
import 'package:flutter_shipper_github/data/controller/Store_Controller.dart';
import 'package:flutter_shipper_github/data/models/Item/Storeitem.dart';
import 'package:flutter_shipper_github/data/models/OrderModel.dart';
import 'package:flutter_shipper_github/pages/char_page/char_footer.dart';
import 'package:flutter_shipper_github/pages/char_page/char_first.dart';
import 'package:flutter_shipper_github/themes/AppColor.dart';
import 'package:flutter_shipper_github/themes/AppDimention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CharPage extends StatefulWidget {
  const CharPage({Key? key}) : super(key: key);

  @override
  _CharPageState createState() => _CharPageState();
}

class _CharPageState extends State<CharPage> {
  Ordercontroller ordercontroller = Get.find<Ordercontroller>();
  Storecontroller storecontroller = Get.find<Storecontroller>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
  }

  String formatDateV0(DateTime deliveredAt) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(deliveredAt);
  }

  String formatDateV1(String deliveredAt) {
    // Chuyển đổi chuỗi `deliveredAt` thành DateTime
    DateTime dateTime = DateTime.parse(deliveredAt);

    // Định dạng lại theo ngày/tháng/năm
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  void _showDropdown(List<OrderData> listorder) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
            width: AppDimention.screenWidth,
            height: AppDimention.size100 * 7,
            padding: EdgeInsets.all(AppDimention.size10),
            child: SingleChildScrollView(
              child: Column(
              children: listorder.map((item) {
                Storesitem? store = storecontroller.getstorebyid(item.storeId!);
                return Container(
                  width: AppDimention.screenWidth,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(AppDimention.size10),
                  decoration: BoxDecoration(color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${store!.storeName}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text("Địa chỉ : ${store.location}"),
                      SizedBox(height: AppDimention.size10,),
                      Text(
                          "Phí vận chuyển : đ${_formatNumber(item.shippingFee!.toInt())}"),
                      SizedBox(height: AppDimention.size10,),
                      Text(
                          "Giá trị đơn : đ${_formatNumber(item.totalAmount!.toInt())}"),
                      SizedBox(height: AppDimention.size10,),
                      Container(
                          width: AppDimention.screenWidth,
                          padding: EdgeInsets.all(AppDimention.size10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size10)),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: item.orderDetails!.map((item) {
                                  bool? key;
                                  ComboDetail? comboDetail;
                                  ProductDetail? productDetail;
                                  if (item.type == "product") {
                                    key = true;
                                    productDetail = item.productDetail;
                                  } else {
                                    key = false;
                                    comboDetail = item.comboDetail;
                                  }
                                  return Container(
                                    width: AppDimention.screenWidth,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "${key ? productDetail!.quantity : comboDetail!.quantity} ${key ? " sản phẩm" : "combo"}"),
                                        Text(
                                            "đ${key ? _formatNumber(productDetail!.totalPrice!.toInt()) : _formatNumber(comboDetail!.totalPrice!.toInt())}")
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: AppDimention.size10,),
                              Text("Giao hàng tại : ${item.deliveryAddress}")
                            ],
                          ))
                    ],
                  ),
                );
              }).toList(),
            ),
            )
          ));
        });
  }

  String? _selectedOption = "Tuần";
  String? _selectedOptionText = "Tuần";
  String? typePage = "Đơn hàng đã giao";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
              width: AppDimention.screenWidth,
              height: AppDimention.size80,
              decoration: BoxDecoration(color: Appcolor.mainColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      width: AppDimention.screenWidth,
                      child: Center(
                        child: DropdownButton<String>(
                          hint: Text('Chọn'),
                          value: typePage,
                          items: <String>[
                            'Đơn hàng đã giao',
                            'Doanh thu của bạn'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              typePage = newValue;
                            });
                          },
                        ),
                      )),
                ],
              )),
          Expanded(
            child: SingleChildScrollView(child: mainPage(typePage!)),
          ),
          CharFooter(),
        ],
      ),
    );
  }

  Widget mainPage(String typePage) {
    if (typePage == "Đơn hàng đã giao")
      return Column(
        children: [
          SizedBox(
            height: AppDimention.size20,
          ),
          Row(
            children: [
              SizedBox(
                width: AppDimention.size10,
              ),
              Icon(
                Icons.line_axis_rounded,
                size: 45,
                color: Colors.green,
              ),
              SizedBox(
                width: AppDimention.size10,
              ),
              Text(
                "Biểu đồ đơn hàng",
                style: TextStyle(fontSize: 18),
              ),
              Container(
                width: AppDimention.size120,
                padding: EdgeInsets.all(16.0),
                child: DropdownButton<String>(
                  hint: Text('Chọn'),
                  value: _selectedOption,
                  items: <String>['Tuần', 'Tháng'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppDimention.size10,
          ),
          chartToRun(_selectedOption!),
          SizedBox(
            height: AppDimention.size20,
          ),
          Row(
            children: [
              SizedBox(
                width: AppDimention.size10,
              ),
              Icon(
                Icons.line_axis_rounded,
                size: 45,
                color: Colors.blue,
              ),
              SizedBox(
                width: AppDimention.size10,
              ),
              Text(
                "Danh sách đơn hàng",
                style: TextStyle(fontSize: 18),
              ),
              Container(
                width: AppDimention.size110,
                padding: EdgeInsets.only(left: AppDimention.size15),
                child: DropdownButton<String>(
                  hint: Text('Chọn'),
                  value: _selectedOptionText,
                  items: <String>['Tuần', 'Tháng'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOptionText = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
          Container(
            width: AppDimention.screenWidth,
            margin: EdgeInsets.all(AppDimention.size10),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black26),
            ),
            child: textToRun(_selectedOptionText!),
          ),
        ],
      );
    else
      return Column(
        children: [
          SizedBox(
            height: AppDimention.size20,
          ),
          if (_selectedOptionText == "Tuần")
            DiagramRevenue(
              keyvalue: 7,
            ),
          if (_selectedOptionText == "Tháng")
            DiagramRevenue(
              keyvalue: 30,
            ),
          SizedBox(
            height: AppDimention.size20,
          ),
          Row(
            children: [
              SizedBox(
                width: AppDimention.size10,
              ),
              Icon(
                Icons.line_axis_rounded,
                size: 45,
                color: Colors.blue,
              ),
              SizedBox(
                width: AppDimention.size10,
              ),
              Text(
                "Danh sách thu nhập",
                style: TextStyle(fontSize: 18),
              ),
              Container(
                width: AppDimention.size110,
                padding: EdgeInsets.only(left: AppDimention.size15),
                child: DropdownButton<String>(
                  hint: Text('Chọn'),
                  value: _selectedOptionText,
                  items: <String>['Tuần', 'Tháng'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOptionText = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
          Container(
            width: AppDimention.screenWidth,
            margin: EdgeInsets.all(AppDimention.size10),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black26),
            ),
            child: textToRun(_selectedOptionText!),
          ),
        ],
      );
  }

  Widget chartToRun(String typeDiagram) {
    List<DateTime> getCurrentMonthDates() {
      DateTime today = DateTime.now();
      DateTime startOfMonth = DateTime(today.year, today.month, 1);
      DateTime endOfMonth = DateTime(today.year, today.month + 1, 0);
      return List.generate(
          endOfMonth.day, (index) => startOfMonth.add(Duration(days: index)));
    }

    List<DateTime> getMonthDates(int year, int month) {
      DateTime startOfMonth = DateTime(year, month, 1);
      DateTime endOfMonth = DateTime(year, month + 1, 0);
      return List.generate(
          endOfMonth.day, (index) => startOfMonth.add(Duration(days: index)));
    }

    List<DateTime> getCurrentWeekDates() {
      DateTime today = DateTime.now();
      DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      return List.generate(
          7, (index) => startOfWeek.add(Duration(days: index)));
    }

    List<DateTime> listdate = [];
    List<double> value = [];
    List<String> valueLabel = [];
    if (typeDiagram == "Tuần") {
      listdate = getCurrentWeekDates();
      for (DateTime item in listdate) {
        value.add(ordercontroller
            .getllOrderComplete(formatDateV0(item))
            .length
            .toDouble());
      }
      valueLabel = ['Mon', 'Tue', 'Wed', 'Thu', 'Sat', 'Fri', 'Sun'];
    } else if (typeDiagram == "Tháng") {
      listdate = getCurrentMonthDates();
      for (DateTime item in listdate) {
        value.add(ordercontroller
            .getllOrderComplete(formatDateV0(item))
            .length
            .toDouble());
      }
      for (DateTime item in listdate) {
        valueLabel.add(item.day.toString());
      }
    } else {
      value = [10.0, 20.0, 5.0, 30.0, 5.0, 20.0, 10.0];
      valueLabel = ['Mon', 'Tue', 'Wed', 'Thu', 'Sat', 'Fri', 'Sun'];
    }
    final chartOptions = const ChartOptions();
    final xContainerLabelLayoutStrategy = DefaultIterativeLabelLayoutStrategy(
      options: chartOptions,
    );
    final chartData = ChartData(
      dataRows: [
        value,
      ],
      xUserLabels: valueLabel,
      dataRowsLegends: const ['Số lượng đơn hàng'],
      chartOptions: chartOptions,
    );
    final lineChartContainer = LineChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );
    final lineChart = LineChart(
      painter: LineChartPainter(
        lineChartContainer: lineChartContainer,
      ),
    );
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: lineChart,
    );
  }

  Widget textToRun(String typeDiagram) {
    List<DateTime> getCurrentMonthDates() {
      DateTime today = DateTime.now();
      DateTime startOfMonth = DateTime(today.year, today.month, 1);
      DateTime endOfMonth = DateTime(today.year, today.month + 1, 0);
      return List.generate(
          endOfMonth.day, (index) => startOfMonth.add(Duration(days: index)));
    }

    List<DateTime> getMonthDates(int year, int month) {
      DateTime startOfMonth = DateTime(year, month, 1);
      DateTime endOfMonth = DateTime(year, month + 1, 0);
      return List.generate(
          endOfMonth.day, (index) => startOfMonth.add(Duration(days: index)));
    }

    List<DateTime> getCurrentWeekDates() {
      DateTime today = DateTime.now();
      DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      return List.generate(
          7, (index) => startOfWeek.add(Duration(days: index)));
    }

    List<DateTime> listdate = [];
    int valueIndex;
    if (typeDiagram == "Tuần") {
      valueIndex = 7;
      listdate = getCurrentWeekDates();
    } else if (typeDiagram == "Tháng") {
      valueIndex = 30;
      listdate = getCurrentMonthDates();
    } else {
      valueIndex = 30;
    }

    int selectedMonth = DateTime.now().month;
    int selectedYear = DateTime.now().year;
    List<int> months = List<int>.generate(12, (i) => i + 1);
    List<int> years = List<int>.generate(100, (i) => DateTime.now().year - i);

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      void changeTimeSelected() {
        setState(() {
          listdate = getMonthDates(selectedYear, selectedMonth);
        });
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (typeDiagram == "Tháng")
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Dropdown chọn tháng
                  DropdownButton<int>(
                    hint: Text("Tháng"),
                    value: selectedMonth,
                    items: months.map((int month) {
                      return DropdownMenuItem<int>(
                        value: month,
                        child: Text(month.toString()),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedMonth = newValue!;
                        changeTimeSelected();
                      });
                    },
                  ),
                  // Dropdown chọn năm
                  DropdownButton<int>(
                    hint: Text("Năm"),
                    value: selectedYear,
                    items: years.map((int year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedYear = newValue!;
                        changeTimeSelected();
                      });
                    },
                  ),
                ],
              ),
            ),
          GetBuilder<Ordercontroller>(builder: (ordercontroller) {
            return Column(
                children: listdate.map((item) {
              return Container(
                  padding: EdgeInsets.all(AppDimention.size10),
                  child: Container(
                    width: AppDimention.screenWidth,
                    padding: EdgeInsets.all(AppDimention.size10),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius:
                            BorderRadius.circular(AppDimention.size10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ngày : ${formatDateV0(item)}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        if (ordercontroller
                                .getllOrderComplete(formatDateV0(item))
                                .length ==
                            0)
                          Text("Bạn không có đơn hàng vào ngày này"),
                        if (ordercontroller
                                .getllOrderComplete(formatDateV0(item))
                                .length !=
                            0)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Bạn có ${ordercontroller.getllOrderComplete(formatDateV0(item)).length} đơn hàng"),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    _showDropdown(
                                        ordercontroller.getllOrderComplete(
                                            formatDateV0(item)));
                                  },
                                  child: Container(
                                    width: AppDimention.size100,
                                    height: AppDimention.size30,
                                    margin: EdgeInsets.only(
                                        top: AppDimention.size10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppDimention.size5),
                                        border: Border.all(
                                            width: 1,
                                            color: Appcolor.mainColor)),
                                    child: Center(
                                      child: Text("Chi tiết"),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                  ));
            }).toList());
          }),
         
          SizedBox(
            height: AppDimention.size20,
          )
        ],
      );
    });
  }

  Widget textToRun2(String typeDiagram) {
    int valueIndex;
    if (typeDiagram == "Tuần") {
      valueIndex = 7;
    } else if (typeDiagram == "Tháng") {
      valueIndex = 30;
    } else {
      valueIndex = 30;
    }

    return Column(
      children: [
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: valueIndex > 7 ? 10 : 7,
            itemBuilder: (context, index) {
              return Container(
                width: AppDimention.screenWidth,
                padding: EdgeInsets.only(
                    left: AppDimention.size20, right: AppDimention.size20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ngày ${index + 1}/9/2024",
                        style: TextStyle(
                          fontSize: AppDimention.size20,
                        )),
                    SizedBox(
                      height: AppDimention.size5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Số lượng : 5"),
                        Text("Tổng tiền : 500.000 vnđ"),
                      ],
                    ),
                    SizedBox(
                      height: AppDimention.size5,
                    ),
                    Container(
                      width: AppDimention.size100,
                      height: AppDimention.size40,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Appcolor.mainColor),
                          borderRadius:
                              BorderRadius.circular(AppDimention.size10)),
                      child: Center(
                        child: Text("Chi tiết"),
                      ),
                    ),
                    SizedBox(
                      height: AppDimention.size20,
                    ),
                  ],
                ),
              );
            }),
        if (valueIndex > 7)
          Center(
            child: Text("Xem thêm"),
          ),
        SizedBox(
          height: AppDimention.size20,
        )
      ],
    );
  }
}
