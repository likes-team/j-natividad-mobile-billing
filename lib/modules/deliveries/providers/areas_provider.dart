import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:jnb_mobile/areas.dart';
import 'package:jnb_mobile/sub_areas.dart';
import 'package:jnb_mobile/utilities/shared_preference.dart';
import 'package:jnb_mobile/utilities/urls.dart';

class AreasProvider with ChangeNotifier {
  String _areasBoxName = "sub_areas";

  List _areasList = <Area>[];

  List get areaList => _areasList;

  String _selectedArea = "ALL";

  // ignore: unnecessary_getters_setters
  String get selectedArea => _selectedArea;

  // ignore: unnecessary_getters_setters
  set selectedArea(String area) {
    _selectedArea = area;
    updateSubAreasList();
    notifyListeners();
  }

  String _selectedSubArea = "ALL";

  String get selectedSubArea => _selectedSubArea;

  set selectedSubArea(String subArea) {
    _selectedSubArea = subArea;

    notifyListeners();
  }

  List<SubArea> _subAreasList = [
    SubArea(subAreaID: 0, subAreaName: "ALL", subAreaDescription: "ALL")
  ];

  List<SubArea> get subAreasList => _subAreasList;

  updateSubAreasList() {
    var selectedAreaIndex =
        _areasList.indexWhere((area) => area.areaName == _selectedArea);

    _subAreasList.clear();

    if (selectedArea == "ALL") {
      selectedSubArea = "ALL";

      _subAreasList.insert(0,
          SubArea(subAreaID: 0, subAreaName: "ALL", subAreaDescription: "ALL"));
      return;
    }

    _subAreasList = List<SubArea>.from(_areasList[selectedAreaIndex].subAreas);
    _subAreasList.insert(0,
        SubArea(subAreaID: 0, subAreaName: "ALL", subAreaDescription: "ALL"));

    selectedSubArea = "ALL";

    print(_subAreasList);
  }

  getAreas() async {
    var box = await Hive.openBox<Area>(_areasBoxName);

    var messenger = UserPreferences().getUser();

    return messenger.then((user) async {
      String url = AppUrls.areasURL + user.userID.toString() + "/areas";

      try {
        final response = await http.get(url);

        if (response.statusCode != 200) {
          return Future.value(false);
        }
        await putData(json.decode(response.body));
      } catch (SocketException) {
        print("Delivery Provider: Socket error");
      }

      _areasList = box.values.toList();

      notifyListeners();
    });
  }

  putData(data) async {
    var box = await Hive.openBox<Area>(_areasBoxName);

    await box.clear();

    Iterable jsonList = data;

    var areas = List<Area>.from(jsonList.map((model) {
      return Area(
        areaID: model['area_id'],
        areaName: model['area_name'],
        areaDescription: model['area_description'],
        subAreas: List<SubArea>.from(
          model['sub_areas'].map((model1) {
            return SubArea(
              subAreaID: model1['sub_area_id'],
              subAreaName: model1['sub_area_name'],
              subAreaDescription: model1['sub_area_description'],
            );
          }),
        ),
      );
      // return model;
    }));

    areas.insert(
        0,
        Area(
          areaID: 0,
          areaName: "ALL",
          areaDescription: "ALL",
        ));

    for (var d in areas) {
      box.add(d);
    }
  }
}
