import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:jnb_mobile/features/delivery/bloc/delivery_cubit.dart';
import 'package:jnb_mobile/features/delivery/view/components/delivery_tile_component.dart';
import 'package:hive/hive.dart';
import 'package:jnb_mobile/delivery.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class DeliveriesPage extends StatefulWidget {
  DeliveriesPage({Key key}) : super(key: key);

  @override
  _DeliveriesPageState createState() => _DeliveriesPageState();
}

class _DeliveriesPageState extends State {
  DeliveryCubit _deliveryCubit;
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Get blocs instances
    _deliveryCubit = BlocProvider.of<DeliveryCubit>(context);

    // Load initial data
    _deliveryCubit.fetchDeliveries();
  }


  void _onRefreshDeliveries() async {
    _deliveryCubit.fetchDeliveries();
  }

  void _search(String query) {
    // var selectedArea =
    //     Provider.of<AreasProvider>(context, listen: false).selectedArea;

    // var selectedSubArea =
    //     Provider.of<AreasProvider>(context, listen: false).selectedSubArea;

    // Provider.of<DeliveriesProvider>(context, listen: false)
    //     .searchDeliveries(query.toUpperCase(), selectedArea, selectedSubArea);

    // _deliveryCubit.
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeliveryCubit, DeliveryState>(
      listener: (context, state) {
        if (state.deliverStatus == DeliverStatus.delivering) {
          showTopSnackBar(
            context,
            CustomSnackBar.info(
              message: state.statusMessage,
            ),
          );
        } else if (state.deliverStatus == DeliverStatus.delivered) {
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: state.statusMessage,
            ),
          );
        } else if (state.deliverStatus == DeliverStatus.failed || state.deliveriesStatus == DeliveriesStatus.error) {
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message: state.statusMessage,
            ),
          );
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _onRefreshDeliveries,
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
                  final bool connected =
                      connectivity != ConnectivityResult.none;

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
                            enabled: false,
                            onChanged: (value) {
                              _search(value);
                            },
                            controller: editingController,
                            decoration: InputDecoration(
                                labelText: "Search",
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.0)))),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Center(
                          child: BlocBuilder<DeliveryCubit, DeliveryState>(
                            builder: (context, state) {
                              if (state.deliveriesStatus ==
                                  DeliveriesStatus.success || state.deliveriesStatus ==
                                  DeliveriesStatus.error) {
                                if (state.deliveriesList == null ||
                                    state.deliveriesList.length == 0) {
                                  return Text("No deliveries yet");
                                }

                                return ListView.builder(
                                  itemCount: state.deliveriesList.length,
                                  itemBuilder: (context, index) {
                                    final delivery =
                                        state.deliveriesList[index];
                                    return DeliveryTile(
                                      onTap: () {
                                              _deliveryCubit
                                                  .getDelivery(delivery.id);
                                              Navigator.pushNamed(
                                                  context, '/delivery');
                                      },
                                      title: delivery.fullName,
                                      subtitle: delivery.areaName + " - " + delivery.subAreaName,
                                      subtitle2: delivery.subscriberAddress,
                                      subtitle3: delivery.status,
                                      subtitle4: ""
                                    );
                                
                                  },
                                );
                              }

                              return CircularProgressIndicator();
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
                child: SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
