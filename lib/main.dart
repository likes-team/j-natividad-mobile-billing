import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jnb_mobile/features/app/view/app.dart';
import 'package:jnb_mobile/areas.dart';
import 'package:jnb_mobile/delivery.dart';
import 'package:jnb_mobile/failed_delivery.dart';
import 'package:jnb_mobile/repositories/authentication_repository.dart';
import 'package:jnb_mobile/repositories/delivery_repository.dart';
import 'package:jnb_mobile/repositories/user_repository.dart';
import 'package:jnb_mobile/sub_areas.dart';
import 'package:jnb_mobile/utilities/globals.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DeliveryAdapter());
  Hive.registerAdapter(FailedDeliveryAdapter());
  Hive.registerAdapter(SubAreaAdapter());
  Hive.registerAdapter(AreaAdapter());
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.openBox<FailedDelivery>(AppGlobals.failedDeliveriesBoxName);
  await Hive.openBox<Delivery>(AppGlobals.deliveriesBoxName);

  AppGlobals.appImagesDirectory = await _createFolder();

  runApp(App(
    authenticationRepository: AuthenticationRepository(),
    userRepository: UserRepository(),
    deliveryRepository: DeliveryRepository(),
  ));
}

Future<Directory> _createFolder() async {
  final folderName = "jnatividaddelivery";
  Directory appDocumentsDirectory = await getExternalStorageDirectory(); // 1
  final appDocumentsPath = Directory("${appDocumentsDirectory.path}/$folderName"); // 2
  print(appDocumentsPath.path);
  // final path = Directory("storage/emulated/0/$folderName");
  var status = await Permission.storage.status;

  if (!status.isGranted) {
    await Permission.storage.request();
  }

  if ((await appDocumentsPath.exists())) {
    return appDocumentsPath;
  } else {
    appDocumentsPath.create();
    return appDocumentsPath;
  }
}