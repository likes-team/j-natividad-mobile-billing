import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:jnb_mobile/features/app/view/app.dart';
import 'package:jnb_mobile/areas.dart';
import 'package:jnb_mobile/delivery.dart';
import 'package:jnb_mobile/failed_delivery.dart';
import 'package:jnb_mobile/features/login/view/login_page.dart';
import 'package:jnb_mobile/modules/authentication/providers/user.dart';
import 'package:jnb_mobile/modules/dashboard/providers/dashboard_provider.dart';
import 'package:jnb_mobile/modules/deliveries/providers/areas_provider.dart';
import 'package:jnb_mobile/modules/deliveries/providers/deliveries_provider.dart';
import 'package:jnb_mobile/modules/location/models/user_location_model.dart';
import 'package:jnb_mobile/modules/location/services/location_service.dart';
import 'package:jnb_mobile/repositories/authentication_repository.dart';
import 'package:jnb_mobile/repositories/user_repository.dart';
import 'package:jnb_mobile/sub_areas.dart';
import 'package:jnb_mobile/utilities/betaTheme.dart';
import 'package:provider/provider.dart';
import 'package:jnb_mobile/modules/authentication/providers/authentication.dart';
import 'package:jnb_mobile/utilities/shared_preference.dart'
    show UserPreferences;
import 'package:jnb_mobile/modules/authentication/models/user.dart' show User;
import 'features/home/view/home.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DeliveryAdapter());
  Hive.registerAdapter(FailedDeliveryAdapter());
  Hive.registerAdapter(SubAreaAdapter());
  Hive.registerAdapter(AreaAdapter());
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App(
    authenticationRepository: AuthenticationRepository(),
    userRepository: UserRepository(),
  ));
}
