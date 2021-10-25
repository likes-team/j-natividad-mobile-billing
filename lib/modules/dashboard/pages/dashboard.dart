import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:jnb_mobile/modules/dashboard/components/indicator.dart';
import 'package:jnb_mobile/modules/dashboard/providers/dashboard_provider.dart';
import 'package:jnb_mobile/modules/deliveries/providers/areas_provider.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int touchedIndex;

  @override
  void initState() {
    super.initState();
    var selectedArea =
        Provider.of<AreasProvider>(context, listen: false).selectedArea;

    var selectedSubArea =
        Provider.of<AreasProvider>(context, listen: false).selectedSubArea;

    Provider.of<DashboardProvider>(context, listen: false)
        .getDeliveriesSummaryData(selectedArea, selectedSubArea);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: AspectRatio(
        aspectRatio: 1.3,
        child: Column(
          children: [
            Card(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Deliveries Summary",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      const SizedBox(
                        height: 18,
                      ),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Consumer<DashboardProvider>(
                              builder: (context, provider, child) {
                            return PieChart(
                              PieChartData(
                                  pieTouchData: PieTouchData(
                                      touchCallback: (pieTouchResponse) {
                                    setState(() {
                                      if (pieTouchResponse.touchInput
                                              is FlLongPressEnd ||
                                          pieTouchResponse.touchInput
                                              is FlPanEnd) {
                                        touchedIndex = -1;
                                      } else {
                                        touchedIndex = pieTouchResponse
                                            .touchedSectionIndex;
                                      }
                                    });
                                  }),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                  sections: showingSections(
                                      provider.deliveriesSummaryData)),
                            );
                          }),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Indicator(
                            color: Colors.green,
                            text: 'Delivered',
                            isSquare: true,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Indicator(
                            color: Colors.orange,
                            text: 'Pending',
                            isSquare: true,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Indicator(
                            color: Colors.red,
                            text: 'In-Progress',
                            isSquare: true,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Indicator(
                            color: Colors.lightBlue,
                            text: 'Delivering',
                            isSquare: true,
                          ),
                          SizedBox(
                            height: 18,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 28,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(Map<String, double> data) {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;

      // var
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.red,
            value: data['inProgressCount'] ?? 0.0,
            title: data['inProgressCount'] != 0.0 ? data['inProgressCount'].toStringAsPrecision(2) : "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.lightBlue,
            value: data['deliveringCount'] ?? 0.0,
            title: data['deliveringCount'] != 0.0 ? data['deliveringCount'].toStringAsPrecision(2) : "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.green,
            value: data['deliveredCount'] ?? 0.0,
            title: data['deliveredCount'] != 0.0 ? data['deliveredCount'].toStringAsPrecision(2) : "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.orange,
            value: data['pendingCount'] ?? 0.0,
            title: data['pendingCount'] != 0.0 ? data['pendingCount'].toStringAsPrecision(2) : "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }
}
