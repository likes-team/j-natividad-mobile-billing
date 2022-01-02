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

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DeliveryAdapter());
  Hive.registerAdapter(FailedDeliveryAdapter());
  Hive.registerAdapter(SubAreaAdapter());
  Hive.registerAdapter(AreaAdapter());
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.openBox<FailedDelivery>(AppGlobals.failedDeliveriesBoxName);
  await Hive.openBox<Delivery>(AppGlobals.deliveriesBoxName);

  runApp(App(
    authenticationRepository: AuthenticationRepository(),
    userRepository: UserRepository(),
    deliveryRepository: DeliveryRepository(),
  ));
}
