import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jnb_mobile/delivery.dart';

class DashboardProvider with ChangeNotifier {
  String _deliveriesBoxName = 'deliveries';

  Map<String, double> _deliveriesSummaryData;
  Map<String, double> get deliveriesSummaryData => _deliveriesSummaryData;

  getDeliveriesSummaryData(String area, String subArea) async {
    Box<Delivery> box = Hive.box(_deliveriesBoxName);

    List<Delivery> _deliveriesList = [];

    int deliveredCount, pendingCount, inProgressCount, deliveringCount;

    if (area != "ALL") {
      _deliveriesList =
          box.values.where((delivery) => delivery.areaName == area).toList();

      if (subArea != "ALL") {
        _deliveriesList = _deliveriesList
            .where((delivery) => delivery.subAreaName == subArea)
            .toList();
      }
    } else {
      _deliveriesList = box.values.toList();
    }

    deliveredCount = _deliveriesList
        .where((delivery) => delivery.status == "DELIVERED")
        .length;

    pendingCount = _deliveriesList
        .where((delivery) => delivery.status == "PENDING")
        .length;

    inProgressCount = _deliveriesList
        .where((delivery) => delivery.status == "IN-PROGRESS")
        .length;

    deliveringCount = _deliveriesList
        .where((delivery) => delivery.status == "DELIVERING")
        .length;

    _deliveriesSummaryData = {
      "deliveredCount": deliveredCount.toDouble(),
      "pendingCount": pendingCount.toDouble(),
      "inProgressCount": inProgressCount.toDouble(),
      "deliveringCount": deliveringCount.toDouble(),
    };

    // notifyListeners();
  }
}
