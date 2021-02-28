import 'dart:io';
import 'package:dio/dio.dart';
import 'package:jnb_mobile/modules/offline_manager/interceptors/dio_connectivity_request_retrier.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final DioConnectivityRequesetRetrier requesetRetrier;

  RetryOnConnectionChangeInterceptor({this.requesetRetrier});

  @override
  Future onError(DioError err) async {
    if (_shouldRetry(err)) {
      try {
        return requesetRetrier.scheduleRequestRetry(err.request);
      } catch (e) {
        return e;
      }
    }

    return err;
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType.DEFAULT &&
        err.error != null &&
        err.error is SocketException;
  }
}
