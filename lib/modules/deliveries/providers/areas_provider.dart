import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jnb_mobile/areas.dart';

class SubAreasProvider with ChangeNotifier {
  String _areasBoxName = "sub_areas";

  List _areasList = <Area>[];

  List get areaList => _areasList;

  getAreas() async {
    // var box = await Hive.openBox<Area>()
  }
}
