import 'dart:io';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';
import 'package:jnb_mobile/delivery.dart';
import 'package:jnb_mobile/failed_delivery.dart';
import 'package:jnb_mobile/models/user_model.dart';
import 'package:jnb_mobile/models/user_location_model.dart';
import 'package:jnb_mobile/models/multipart_extended.dart';
import 'package:jnb_mobile/utilities/shared_preference.dart';
import 'package:jnb_mobile/utilities/urls.dart';
import 'package:path/path.dart';

class DeliveryRepository {
  final Dio _dio = Dio();

  Future<List<Delivery>> fetchDeliveries() async{
    final User currentUser = await UserPreferences.getUser();
    final String deliveriesUrl = AppUrls.deliveriesURL +
          "?query=by_messenger&messenger_id=" + currentUser.id;

    try{
      final response = await _dio.get(deliveriesUrl);

      if (response.statusCode != 200) {
        throw Exception("Failed fetching deliveries");
      }

      final responseData = response.data['data'];
      print("Deliveries response data: ");
      print(responseData);
      return List<Delivery>.from(responseData.map((model) => Delivery.fromJson(model)));
    } on SocketException catch(_){
      throw SocketException("No internet, failed fetching deliveries");
    } catch (_){
      throw Exception("Error fetching deliveries, app will display stored data");
    }
  }

  Future<dynamic> deliver({Delivery delivery, File image, UserLocation userLocation}) async{
    final User currentUser = await UserPreferences.getUser();

    final DateTime dateTimeNow = new DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTimeNow);
    final String imageName = image.path.split('/').last;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (!result.isNotEmpty && !result[0].rawAddress.isNotEmpty) {
        throw Exception("No Internet");
      }

      final FormData formData = FormData.fromMap({
        'delivery_id': delivery.id,
        'messenger_id': currentUser.id,
        'subscriber_id': delivery.subscriberID,
        'date_mobile_delivery': formattedDate.toString(),
        'latitude': userLocation.latitude.toString(),
        'longitude': userLocation.longitude.toString(),
        'accuracy': userLocation.accuracy.toString(),
        "file": MultipartFileExtended.fromFileSync(
          image.path,
          filename: imageName,
        ),
      });
      return _dio.post(AppUrls.deliverURL, data: formData);
    } on SocketException catch (err) {
      throw err;
    } on Exception catch(err){
      throw err;
    }
  }


  Future<dynamic> redeliver({FailedDelivery failedDelivery}) async{
    final User currentUser = await UserPreferences.getUser();

    try {
      final result = await InternetAddress.lookup('google.com');
      if (!result.isNotEmpty && !result[0].rawAddress.isNotEmpty) {
        throw Exception("No Internet");
      }

      final String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(failedDelivery.dateMobileDelivery);
      final FormData formData = FormData.fromMap({
        'delivery_id': failedDelivery.id,
        'messenger_id': currentUser.id,
        'subscriber_id': failedDelivery.subscriberID,
        'date_mobile_delivery': formattedDate.toString(),
        'latitude': failedDelivery.latitude.toString(),
        'longitude': failedDelivery.longitude.toString(),
        'accuracy': failedDelivery.accuracy.toString(),
        "file": MultipartFileExtended.fromFileSync(
          failedDelivery.imagePath,
          filename: failedDelivery.fileName,
        ),
      });
      return _dio.post(AppUrls.deliverURL, data: formData);
    } on SocketException catch (err) {
      throw err;
    } on Exception catch(err){
      throw err;
    }
  }

  Future<dynamic> updateLocation({@required String subscriberId, @required UserLocation userLocation}) async{
    final User currentUser = await UserPreferences.getUser();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (!result.isNotEmpty && !result[0].rawAddress.isNotEmpty) {
        throw Exception("No Internet");
      }

      final Map<String, dynamic> postData = {
        "latitude": userLocation.latitude.toString(),
        "longitude": userLocation.longitude.toString(),
        "accuracy": userLocation.accuracy.toString(),
        "messenger_id": currentUser.id,
        "subscriber_id": subscriberId,
      };
      return _dio.post(AppUrls.updateLocationURL, data: postData);
    } on SocketException catch (err) {
      throw err;
    } on Exception catch(err){
      throw err;
    }
  }

}