import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:jnb_mobile/modules/offline_manager/multipart_extended.dart';

class DioConnectivityRequesetRetrier {
  final Dio dio;
  final Connectivity connectivity;
  final BuildContext context;

  DioConnectivityRequesetRetrier({
    @required this.dio,
    @required this.connectivity,
    this.context,
  });

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    StreamSubscription streamSubscription;
    final responseCompleter = Completer<Response>();

    streamSubscription =
        connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        streamSubscription.cancel();

        if (requestOptions.data is FormData) {
          FormData formData = FormData();

          formData.fields.addAll(requestOptions.data.fields);

          for (MapEntry mapFile in requestOptions.data.files) {
            formData.files.add(MapEntry(
                mapFile.key,
                MultipartFileExtended.fromFileSync(
                    mapFile.value.filePath, //fixed!
                    filename: mapFile.value.filename)));
          }

          requestOptions.data = formData;
        }

        responseCompleter.complete(
          dio.request(
            requestOptions.path,
            cancelToken: requestOptions.cancelToken,
            data: requestOptions.data,
            onReceiveProgress: requestOptions.onReceiveProgress,
            onSendProgress: requestOptions.onSendProgress,
            queryParameters: requestOptions.queryParameters,
            options: requestOptions,
          ),
        );

        BotToast.showSimpleNotification(
            title:
                "Pending deliveries are delivered successfully!"); // popup a notification toast;

      }
    });

    return responseCompleter.future;
  }
}
