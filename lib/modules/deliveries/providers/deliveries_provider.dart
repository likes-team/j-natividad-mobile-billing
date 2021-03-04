import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:jnb_mobile/delivery.dart';
import 'package:jnb_mobile/utilities/shared_preference.dart';
import 'package:jnb_mobile/utilities/urls.dart' show AppUrls;

class DeliveriesProvider with ChangeNotifier {
  String _deliveriesBoxName = 'deliveries';

  List _deliveriesList = <Delivery>[];

  List get deliveriesList => _deliveriesList;

  Future<bool> getDeliveries() async {
    var box = await Hive.openBox<Delivery>(_deliveriesBoxName);

    var messenger = UserPreferences().getUser();

    return messenger.then((user) async {
      String url = AppUrls.deliveriesURL +
          "?query=by_messenger&messenger_id=" +
          user.userID.toString();

      try {
        final response = await http.get(url);

        if (response.statusCode != 200) {
          return Future.value(false);
        }
        await putData(json.decode(response.body)['deliveries']);
      } catch (SocketException) {
        print("Delivery Provider: Socket error");
      }

      _deliveriesList = box.values.toList();

      notifyListeners();

      return Future.value(true);
    });
  }

  refreshDeliveries() async {
    var box = await Hive.openBox<Delivery>(_deliveriesBoxName);

    var messenger = UserPreferences().getUser();

    return messenger.then((user) async {
      String url = AppUrls.deliveriesURL +
          "?query=by_messenger&messenger_id=" +
          user.userID.toString();

      try {
        final response = await http.get(url);

        if (response.statusCode != 200) {
          return [];
        }
        await putData(json.decode(response.body)['deliveries']);
      } catch (SocketException) {
        print("Delivery Provider: Socket error");
        return [];
      }

      _deliveriesList = box.values.toList();
      notifyListeners();
    });
  }

  searchDeliveries(String searchValue) async {
    if (searchValue.isEmpty) {
      var box = await Hive.openBox<Delivery>(_deliveriesBoxName);
      _deliveriesList = box.values.toList();

      notifyListeners();
      return;
    }
    List<Delivery> searchedDeliveriesList = List<Delivery>();

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

    for (var d in deliveries) {
      box.add(d);
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

  updateItem(int index, Delivery delivery) {
    final box = Hive.box<Delivery>(_deliveriesBoxName);

    box.putAt(index, delivery);

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
