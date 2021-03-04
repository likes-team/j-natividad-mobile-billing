import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:jnb_mobile/delivery.dart';
import 'package:jnb_mobile/failed_delivery.dart';
import 'package:jnb_mobile/modules/offline_manager/multipart_extended.dart';
import 'package:jnb_mobile/utilities/urls.dart';

class FailedDeliveryService {
  Box box;

  String _boxName = "failed_deliveries";

  addFailedDelivery({
    Delivery delivery,
    int messengerID,
    DateTime dateMobileDelivery,
    String imagePath,
    String latitude,
    String longitude,
    String accuracy,
    String imageName,
  }) async {
    box = await Hive.openBox<FailedDelivery>(_boxName);

    FailedDelivery failedDelivery = FailedDelivery(
      id: delivery.id,
      messengerID: messengerID,
      subscriberID: delivery.subscriberID,
      dateMobileDelivery: dateMobileDelivery,
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      imagePath: imagePath,
      fileName: imageName,
    );

    box.put(failedDelivery.id, failedDelivery);
  }

  Future<List<FailedDelivery>> getFailedDeliveries() async {
    box = await Hive.openBox<FailedDelivery>(_boxName);

    return box.values.toList();
  }

  Future<bool> redeliverFailedDeliveries() async {
    box = await Hive.openBox<FailedDelivery>(_boxName);

    var failedDeliveriesMap = box.toMap();

    Dio dio = Dio();
    int _successCounter = 0;
    int _errorCounter = 0;

    failedDeliveriesMap.forEach((key, value) {
      String formattedDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(value.dateMobileDelivery);

      FormData formData = new FormData.fromMap({
        'delivery_id': value.id,
        'messenger_id': value.messengerID,
        'subscriber_id': value.subscriberID,
        'date_mobile_delivery': formattedDate.toString(),
        'latitude': value.latitude,
        'longitude': value.longitude,
        'accuracy': value.accuracy,
        "file": MultipartFileExtended.fromFileSync(
          value.imagePath,
          filename: value.fileName,
        ),
      });

      Future.delayed(Duration(milliseconds: 1000), () async {
        await dio.post(AppUrls.deliverURL, data: formData).then((response) {
          _successCounter += 1;

          removeFailedDelivery(value);

          BotToast.showSimpleNotification(
              title: "$_successCounter deliveries, Delivered Succesfully!");
        }).catchError((error) {
          _errorCounter += 1;
          BotToast.showSimpleNotification(
              title: "$_errorCounter deliveries, Delivered Succesfully!");
        });
      });
    });

    return Future.value(true);
  }

  removeFailedDelivery(FailedDelivery delivery) async {
    box = await Hive.openBox<FailedDelivery>(_boxName);

    box.delete(delivery.id);
  }
}
