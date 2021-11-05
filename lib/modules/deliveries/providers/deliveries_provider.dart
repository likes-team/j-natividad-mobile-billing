import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:jnb_mobile/delivery.dart';
import 'package:jnb_mobile/modules/offline_manager/services/failed_deliveries.dart';
import 'package:jnb_mobile/utilities/shared_preference.dart';
import 'package:jnb_mobile/utilities/urls.dart' show AppUrls;

class DeliveriesProvider with ChangeNotifier {
  String _deliveriesBoxName = 'deliveries';

  List _deliveriesList = <Delivery>[];

  List get deliveriesList => _deliveriesList;

  Delivery _selectedDelivery;

  Delivery get selectedDelivery => _selectedDelivery;

  List _deliveringList = <Delivery>[];

  List<Delivery> get deliveringList => _deliveringList;

  final FailedDeliveryService failedDeliveriesService = FailedDeliveryService();

  selectDelivery(String id) {
    var box = Hive.box<Delivery>(_deliveriesBoxName);

    _selectedDelivery = box.get(id);

    notifyListeners();
  }

  Future<bool> getDeliveries() async {
    var box = await Hive.openBox<Delivery>(_deliveriesBoxName);

    var messenger = UserPreferences.getUser();

    return messenger.then((user) async {
      String url = AppUrls.deliveriesURL +
          "?query=by_messenger&messenger_id=" +
          user.id;

      try {
        final response = await http.get(url);

        if (response.statusCode != 200) {
          return Future.value(false);
        }
        await putData(json.decode(response.body)['deliveries']);
      } on SocketException catch (_) {
        print("Delivery Provider: Socket error");
      } catch (e) {
        throw e;
      }

      _deliveriesList = box.values.toList();

      notifyListeners();

      return Future.value(true);
    });
  }

  getDeliveringData() async {
    var box = await Hive.openBox<Delivery>(_deliveriesBoxName);

    _deliveringList = box.values
        .where((delivery) => delivery.status == "DELIVERING")
        .toList();

    notifyListeners();
  }

  refreshDeliveries({@required String area, @required String subArea}) async {
    var box = await Hive.openBox<Delivery>(_deliveriesBoxName);

    var messenger = UserPreferences.getUser();

    return messenger.then((user) async {
      String url = AppUrls.deliveriesURL +
          "?query=by_messenger&messenger_id=" +
          user.id.toString();

      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          await putData(json.decode(response.body)['deliveries']);
        }
      } catch (SocketException) {
        print("Error Occured: Socket Exception");
      }

      if (area != "ALL") {
        _deliveriesList =
            box.values.where((delivery) => delivery.areaName == area).toList();

        if (subArea != "ALL") {
          _deliveriesList = _deliveriesList
              .where((delivery) => delivery.subAreaName == subArea)
              .toList();
        }

        notifyListeners();
        return null;
      }

      _deliveriesList = box.values.toList();

      notifyListeners();
    });
  }

  searchDeliveries(String searchValue, String area, String subArea) async {
    if (searchValue.isEmpty) {
      var box = await Hive.openBox<Delivery>(_deliveriesBoxName);

      if (area != "ALL") {
        _deliveriesList =
            box.values.where((delivery) => delivery.areaName == area).toList();

        if (subArea != "ALL") {
          _deliveriesList = _deliveriesList
              .where((delivery) => delivery.subAreaName == subArea)
              .toList();
        }

        notifyListeners();
        return null;
      }

      _deliveriesList = box.values.toList();

      notifyListeners();
      return;
    }
    List<Delivery> searchedDeliveriesList = [];

    _deliveriesList.forEach((item) {
      print(item.subscriberLname);
      if (item.subscriberLname.contains(searchValue)) {
        searchedDeliveriesList.add(item);
      }
    });

    _deliveriesList = searchedDeliveriesList;
    notifyListeners();
  }

  Future putData(data) async {
    var box = await Hive.openBox<Delivery>(_deliveriesBoxName);

    await box.clear();

    Iterable jsonList = data;
    var deliveries =
        List<Delivery>.from(jsonList.map((model) => Delivery.fromJson(model)));

    List<String> failedDeliveriesIds =
        await failedDeliveriesService.getFailedDeliveriesIds();

    // TODO: gumawa nalang isang button na may count of failed deliveries
    if (failedDeliveriesIds.length == 0) {
      for (var delivery in deliveries) {
        box.put(delivery.id, delivery);
      }

      return;
    }

    for (var delivery in deliveries) {
      if (failedDeliveriesIds.contains(delivery.id) &&
          delivery.status == "IN-PROGRESS") {
        delivery.status = "DELIVERING";
        box.put(delivery.id, delivery);

        continue;
      }

      box.put(delivery.id, delivery);
    }
  }

  addItem(Delivery delivery) async {
    var box = await Hive.openBox<Delivery>(_deliveriesBoxName);

    box.add(delivery);

    notifyListeners();
  }

  getItem() async {
    final box = await Hive.openBox<Delivery>(_deliveriesBoxName);

    _deliveriesList = box.values.toList();

    notifyListeners();
  }

  updateItem(Delivery delivery, String area, String subArea) {
    final box = Hive.box<Delivery>(_deliveriesBoxName);

    box.put(delivery.id, delivery);

    if (area != "ALL") {
      _deliveriesList =
          box.values.where((delivery) => delivery.areaName == area).toList();

      if (subArea != "ALL") {
        _deliveriesList = _deliveriesList
            .where((delivery) => delivery.subAreaName == subArea)
            .toList();
      }

      notifyListeners();
      return null;
    }

    _deliveriesList = box.values.toList();

    notifyListeners();
  }

  deleteItem(int index) {
    final box = Hive.box<Delivery>(_deliveriesBoxName);

    box.deleteAt(index);

    getItem();

    notifyListeners();
  }
}
