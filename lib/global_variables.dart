import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:jnb_mobile/models/user_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

ValueNotifier<String> globalAppBarTitle = ValueNotifier<String>('Deliveries');
ValueNotifier<User> globalCurrentUser = ValueNotifier<User>(User.fromJson({}));
Db? globalMongoDB;
String globalFailedDeliveriesBoxName = "failed_deliveries";
String globalDeliveriesBoxName = "deliveries";
late Directory globalAppImagesDirectory;