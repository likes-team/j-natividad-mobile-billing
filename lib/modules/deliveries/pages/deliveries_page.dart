import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';
import 'package:jnb_mobile/modules/deliveries/models/delivery.dart';
import 'package:jnb_mobile/modules/authentication/models/user.dart' show User;
import 'package:jnb_mobile/utilities/shared_preference.dart';
import 'package:jnb_mobile/utilities/urls.dart' show AppUrls;
import 'package:jnb_mobile/modules/deliveries/pages/deliver_page.dart'
    show DeliverPage;

class DeliveriesPage extends StatefulWidget {
  DeliveriesPage({Key key}) : super(key: key);

  @override
  _DeliveriesPageState createState() => _DeliveriesPageState();
}

class _DeliveriesPageState extends State {
  Future<User> messenger;

  Future<List<Delivery>> futureDeliveries;

  Box box;

  @override
  void initState() {
    super.initState();
    futureDeliveries = getDeliveries();
    messenger = UserPreferences().getUser();
  }

  Future<List<Delivery>> getDeliveries() async {
    await openBox();

    return messenger.then((user) async {
      String url = AppUrls.deliveriesURL +
          "?query=by_messenger&messenger_id=" +
          user.userID.toString();

      List<Delivery> deliveries;

      try {
        final response = await http.get(url);

        if (response.statusCode != 200) {
          Flushbar(
            title: "System Error!",
            message: "Failed to load deliveries",
            duration: Duration(seconds: 3),
          ).show(context);

          return [];
        }

        await putData(json.decode(response.body)['deliveries']);
      } catch (SocketException) {
        Flushbar(
          title: "No Internet!",
          message: "Failed to load deliveries",
          duration: Duration(seconds: 3),
        ).show(context);
      }

      Iterable myMap = box.toMap().values.toList();

      if (myMap.isEmpty) {
        return [];
      }

      deliveries =
          List<Delivery>.from(myMap.map((model) => Delivery.fromJson(model)));

      return deliveries;
    });
  }

  refreshDeliveries() async {
    setState(() {
      futureDeliveries = getDeliveries();
    });

    Flushbar(
      title: "Refreshed Successfully!",
      message: "Success to update deliveries",
      duration: Duration(seconds: 3),
    ).show(context);
  }

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('data');
    return;
  }

  Future putData(data) async {
    await box.clear();

    for (var d in data) {
      box.add(d);
    }
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
                      margin: EdgeInsets.only(top: 20),
                      child: Center(
                        child: FutureBuilder<List<Delivery>>(
                          future: futureDeliveries,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            snapshot.data[index].fullName,
                                          ),
                                          subtitle: Text(
                                            snapshot
                                                .data[index].subscriberAddress,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing:
                                              Text(snapshot.data[index].status),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DeliverPage(
                                                  delivery: snapshot.data[
                                                      index], // Ipasa ang data
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
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }

                            return CircularProgressIndicator();
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
