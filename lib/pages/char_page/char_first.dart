
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
class DiagramRevenue extends StatelessWidget{
    final int keyvalue;
   DiagramRevenue({
       Key? key,
       required this.keyvalue,
   }): super(key:key);
    List<Color> gradientColors = [
      Colors.blue,
      Colors.green
    ];
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
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
               mainData(),
            ),
          ),
        ),
        
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  
  Widget text = const SizedBox(); 

  for (int i = 0; i < keyvalue; i++) {
    if(keyvalue > 7){
      if (value.toInt() == i ) {
        if(i%7 == 0 && i != 0)
        {
          text = Text((i).toString(), style: style);
          break;
        } 
      }
    }
    else{
      if (value.toInt() == i ) {
            text = Text((i + 1).toString(), style: style);
            break; 
      }
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
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    Random random = Random();
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color:Colors.blue,
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
      maxX: keyvalue!-1,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots:  [
            for (int i = 0; i < keyvalue!; i++) 
              FlSpot(i.toDouble(), random.nextDouble() * 5 ),
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