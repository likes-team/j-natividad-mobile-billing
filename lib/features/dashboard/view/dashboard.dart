import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jnb_mobile/features/dashboard/bloc/dashboard_provider.dart';
import 'package:jnb_mobile/features/delivery/bloc/delivery_cubit.dart';
import 'package:jnb_mobile/utilities/colors.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // var selectedArea =
    //     Provider.of<AreasProvider>(context, listen: false).selectedArea;

    // var selectedSubArea =
    //     Provider.of<AreasProvider>(context, listen: false).selectedSubArea;

    // Provider.of<DashboardProvider>(context, listen: false)
    //     .getDeliveriesSummaryData(selectedArea, selectedSubArea);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }

  // List<PieChartSectionData> showingSections(Map<String, double> data) {
  //   return List.generate(4, (i) {
  //     final isTouched = i == touchedIndex;
  //     final double fontSize = isTouched ? 25 : 16;
  //     final double radius = isTouched ? 60 : 50;

  //     // var
  //     switch (i) {
  //       case 0:
  //         return PieChartSectionData(
  //           color: Colors.red,
  //           value: data['inProgressCount'] ?? 0.0,
  //           title: data['inProgressCount'] != 0.0 ? data['inProgressCount'].toStringAsPrecision(2) : "",
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: const Color(0xffffffff)),
  //         );
  //       case 1:
  //         return PieChartSectionData(
  //           color: Colors.lightBlue,
  //           value: data['deliveringCount'] ?? 0.0,
  //           title: data['deliveringCount'] != 0.0 ? data['deliveringCount'].toStringAsPrecision(2) : "",
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: const Color(0xffffffff)),
  //         );
  //       case 2:
  //         return PieChartSectionData(
  //           color: Colors.green,
  //           value: data['deliveredCount'] ?? 0.0,
  //           title: data['deliveredCount'] != 0.0 ? data['deliveredCount'].toStringAsPrecision(2) : "",
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: const Color(0xffffffff)),
  //         );
  //       case 3:
  //         return PieChartSectionData(
  //           color: Colors.orange,
  //           value: data['pendingCount'] ?? 0.0,
  //           title: data['pendingCount'] != 0.0 ? data['pendingCount'].toStringAsPrecision(2) : "",
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: const Color(0xffffffff)),
  //         );
  //       default:
  //         return null;
  //     }
  //   });
  // }
}
