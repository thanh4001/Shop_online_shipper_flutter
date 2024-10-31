import 'dart:math';

import 'package:flutter_shipper_github/data/controller/OrderController.dart';
import 'package:flutter_shipper_github/themes/AppDimention.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DiagramRevenue extends StatefulWidget {
  final int keyvalue;
  DiagramRevenue({
    Key? key,
    required this.keyvalue,
  }) : super(key: key);

  @override
  _DiagramRevenueState createState() => _DiagramRevenueState();
}

class _DiagramRevenueState extends State<DiagramRevenue> {
  List<Color> gradientColors = [Colors.blue, Colors.green];
  late List<DateTime> listdate;
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    listdate =widget.keyvalue == 7 ? getCurrentWeekDates() : getCurrentMonthDates();
    _selectedOption = widget.keyvalue == 7 ? "Tuần" :"Tháng";
  }

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
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  String formatDateV0(DateTime deliveredAt) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(deliveredAt);
  }

  Ordercontroller ordercontroller = Get.find<Ordercontroller>();
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  List<int> months = List<int>.generate(12, (i) => i + 1);
  List<int> years = List<int>.generate(100, (i) => DateTime.now().year - i);
 
 
    
    void changeTimeSelected() {
      setState(() {
        listdate = getMonthDates(selectedYear, selectedMonth);
      });
    }
  

  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              bottom: 12,
            ),
            child: Column(
              children: [
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
                "Biểu đồ thu nhập",
                style: TextStyle(fontSize: 20),
              ),
              Container(
                width: AppDimention.size110,
                padding: EdgeInsets.all(16.0),
                child: DropdownButton<String>(
                  hint: Text('Chọn'),
                  value: _selectedOption,
                  items:
                      <String>['Tuần', 'Tháng'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue!;
                      if(_selectedOption == "Tuần"){
                        setState(() {
                          listdate = getCurrentWeekDates();
                        });
                      }
                      else{
                         setState(() {
                          listdate = getCurrentMonthDates();
                        });
                      }
                    });
                  },
                ),
              ),
            ],
          ),
                if (listdate.length > 7)
                  Container(
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
                Expanded(
                  child: LineChart(
                    mainData(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );

    Widget text = const SizedBox();

    for (int i = 0; i < listdate.length; i++) {
      if (value.toInt() == i) {
        text = Text("${listdate[i].day}", style: style);
        break;
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = 'đ100';
        break;
      case 3:
        text = 'đ300';
        break;
      case 5:
        text = 'đ500';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.blue,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.green,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: listdate.length.toDouble()-1,
      minY: 0,
      maxY: 2,
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (int i = 0; i < listdate.length; i++)
              FlSpot(
                  i.toDouble(),
                  (ordercontroller.getllOrderCompleteFee(
                              formatDateV0(listdate[i])) /
                          100000)
                      .toDouble()),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
