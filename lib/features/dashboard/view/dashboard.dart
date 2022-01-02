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
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: AspectRatio(
        aspectRatio: 1.3,
        child: BlocBuilder<DeliveryCubit, DeliveryState>(
          builder: (context, state) {
            int inProgressCount = 0;
            int deliveringCount = 0;
            int pendingCount = 0;
            int deliveredCount = 0;

            for(var delivery in state.deliveriesList){
              if(delivery.status == "IN-PROGRESS"){
                inProgressCount++;
              } else if(delivery.status == "DELIVERING"){
                deliveringCount++;
              } else if(delivery.status == "DELIVERED"){
                deliveredCount++;
              } else if(delivery.status == "PENDING"){
                pendingCount++;
              }
            }

            return Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.stop),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: inProgressCount.toString(),
                                  style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text: '  In-Progress',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal))
                              ]),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.file_upload),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: deliveringCount.toString(),
                                  style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text: '  Delivering',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal))
                              ]),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.pending),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: pendingCount.toString(),
                                  style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text: '  Pending',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal))
                              ]),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.check_box),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: deliveredCount.toString(),
                                  style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text: '  Delivered',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal))
                              ]),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
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
