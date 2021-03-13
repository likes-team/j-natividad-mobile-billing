import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:jnb_mobile/modules/deliveries/providers/areas_provider.dart';
import 'package:jnb_mobile/modules/location_updater/pages/update_page.dart';
import 'package:jnb_mobile/modules/offline_manager/services/failed_deliveries.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:flushbar/flushbar.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:jnb_mobile/modules/authentication/models/user.dart' show User;
import 'package:jnb_mobile/utilities/shared_preference.dart';
import 'package:jnb_mobile/modules/deliveries/providers/deliveries_provider.dart';
import 'package:jnb_mobile/delivery.dart';

class LocationUpdaterPage extends StatefulWidget {
  @override
  _LocationUpdaterPageState createState() => _LocationUpdaterPageState();
}

class _LocationUpdaterPageState extends State<LocationUpdaterPage> {
  Future<User> messenger;

  DeliveriesProvider deliveryModel;

  List<Delivery> futureDeliveries;

  Box box;

  bool checkFailedDeliveries = true;

  bool isLoading = true;

  final failedDeliveriesService = FailedDeliveryService();

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    messenger = UserPreferences().getUser();

    Provider.of<DeliveriesProvider>(context, listen: false)
        .getDeliveries()
        .then((value) {
      isLoading = false;
    }).catchError((error) {
      print(error);
    });

    Provider.of<AreasProvider>(context, listen: false).getAreas();
  }

  sendFailedDeliveries() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var failedDeliveries =
            await failedDeliveriesService.getFailedDeliveries();

        if (failedDeliveries.length > 0) {
          BotToast.showSimpleNotification(
              title:
                  "Redelivering ${failedDeliveries.length} failed deliveries... ",
              backgroundColor: Colors.blue[200]);
          var result =
              await failedDeliveriesService.redeliverFailedDeliveries();
          return result;
        } else {
          BotToast.showSimpleNotification(
              title: "No failed deliveries...",
              backgroundColor: Colors.blue[200]);
        }
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
    return true;
  }

  refreshDeliveries() async {
    var selectedArea =
        Provider.of<AreasProvider>(context, listen: false).selectedArea;

    var selectedSubArea =
        Provider.of<AreasProvider>(context, listen: false).selectedSubArea;

    var result = await sendFailedDeliveries();
    try {
      final networkResult = await InternetAddress.lookup('google.com');
      if (networkResult.isNotEmpty && networkResult[0].rawAddress.isNotEmpty) {
        if (result) {
          Provider.of<DeliveriesProvider>(context, listen: false)
              .refreshDeliveries(area: selectedArea, subArea: selectedSubArea);
          Flushbar(
            title: "Refreshed Successfully!",
            message: "Success to update deliveries",
            duration: Duration(seconds: 3),
          ).show(context);
        }
      }
    } on SocketException catch (_) {
      Flushbar(
        title: "No Internet!",
        message: "Failed to update deliveries",
        duration: Duration(seconds: 3),
      ).show(context);
    }
  }

  void filterSearchResults(String query) {
    Provider.of<DeliveriesProvider>(context, listen: false)
        .searchDeliveries(query.toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: refreshDeliveries,
        child: Icon(Icons.refresh),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                final bool connected = connectivity != ConnectivityResult.none;

                return new Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      height: 24.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        color:
                            connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                        child: Center(
                          child: Text("${connected ? 'ONLINE' : 'OFFLINE'}"),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 25),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          onChanged: (value) {
                            filterSearchResults(value);
                          },
                          controller: editingController,
                          decoration: InputDecoration(
                              labelText: "Search",
                              hintText: "Search",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)))),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 100),
                      child: Center(
                        child: Consumer<DeliveriesProvider>(
                          builder: (context, provider, child) {
                            if (isLoading) {
                              return CircularProgressIndicator();
                            }

                            if (provider.deliveriesList.isEmpty) {
                              return Text("No deliveries yet");
                            }

                            return ListView.builder(
                              itemCount: provider.deliveriesList.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.edit_location),
                                        title: Text(
                                          provider
                                              .deliveriesList[index].fullName,
                                        ),
                                        subtitle: Text(
                                          provider.deliveriesList[index]
                                              .subscriberAddress,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UpdatePage(
                                                delivery: provider
                                                        .deliveriesList[
                                                    index], // Ipasa ang data
                                                hiveIndex: index,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
              child: SizedBox(), //Hindi ito makikita
            ),
          ),
        ],
      ),
    );
  }
}
