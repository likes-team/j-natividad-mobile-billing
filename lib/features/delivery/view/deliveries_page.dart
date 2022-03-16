import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:jnb_mobile/features/delivery/bloc/deliver/deliver_cubit.dart';
import 'package:jnb_mobile/features/delivery/bloc/delivery_cubit.dart';
import 'package:jnb_mobile/features/delivery/view/components/delivery_tile_component.dart';
import 'package:hive/hive.dart';
import 'package:jnb_mobile/delivery.dart';
import 'package:jnb_mobile/features/delivery/view/components/qr_scanner_modal.dart';
import 'package:jnb_mobile/utilities/colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class DeliveriesPage extends StatefulWidget {
  DeliveriesPage({Key key}) : super(key: key);

  @override
  _DeliveriesPageState createState() => _DeliveriesPageState();
}

class _DeliveriesPageState extends State with SingleTickerProviderStateMixin {
  DeliveryCubit _deliveryCubit;
  TextEditingController _searchController = TextEditingController();
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animationIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeInOut;
  double _fabHeight = 56.0;

  @override
  void initState() {
    super.initState();

    // Get blocs instances
    _deliveryCubit = BlocProvider.of<DeliveryCubit>(context);

    // Load initial data
    _deliveryCubit.fetchDeliveries();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });
    _animationIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(begin: AppColors.secondary, end: AppColors.primary).animate(
        CurvedAnimation(
            parent: _animationController, curve: Interval(0.0, 1.0, curve: Curves.linear)));
    _translateButton = Tween<double>(begin: _fabHeight, end: -14.0).animate(CurvedAnimation(
        parent: _animationController, curve: Interval(0.0, 0.75, curve: Curves.linear)));
    Future.delayed(Duration(seconds: 2));
  }

  void _onRefreshDeliveries() async {
    _deliveryCubit.fetchDeliveries();
  }

  void _search(String query) {
    _deliveryCubit.search(contractNo: query);
  }

  Widget _buttonScanQR() {
    return Container(
      child: FloatingActionButton(
        mini: true,
      onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return QrScannerModal();
            },
          );
        },
        child: Icon(Icons.qr_code_scanner_rounded),
        tooltip: 'Scan QR',
      ),
    );
  }

  Widget _buttonRefresh() {
    return Container(
      child: FloatingActionButton(
        mini: true,
        onPressed: () => _onRefreshDeliveries(),
        child: Icon(Icons.refresh),
        tooltip: 'Refresh deliveries',
      ),
    );
  }

  Widget _buttonToggle() {
    return Container(
      child: FloatingActionButton(
        mini: true,
        onPressed: _animate,
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animationIcon,
        ),
        tooltip: 'Search Group',
      ),
    );
  }
  
  void _animate() {
    if (!isOpened) {
      _animationController.forward();
    } else
      _animationController.reverse();
    isOpened = !isOpened;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeliverCubit, DeliverState>(
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
            } else if (state.deliverStatus == DeliverStatus.failed) {
              showTopSnackBar(
                context,
                CustomSnackBar.error(
                  message: state.statusMessage,
                ),
              );
            }
          },
        ),
        BlocListener<DeliveryCubit, DeliveryState>(
          listenWhen: (previous, current) {
            return previous.deliveriesStatus != current.deliveriesStatus;
          },
          listener: (context, state) {
            if (state.deliveriesStatus == DeliveriesStatus.error) {
              showTopSnackBar(
                context,
                CustomSnackBar.error(
                  message: state.statusMessage,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Transform(
              transform: Matrix4.translationValues(0.0, _translateButton.value * 1.7, 0.0),
              child: _buttonScanQR(),
            ),
            Transform(
              transform: Matrix4.translationValues(0.0, _translateButton.value * 0.85, 0.0),
              child: _buttonRefresh(),
            ),
            // Transform(
            //   transform: Matrix4.translationValues(0.0, _translateButton.value * 0.85, 0.0),
            //   child: buttonSearchGroup(),
            // ),
            _buttonToggle(),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _onRefreshDeliveries,
        //   child: Icon(Icons.refresh),
        //   backgroundColor: Colors.green,
        // ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300],
                      ),
                    )),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: TextField(
                          onChanged: (text) => _search(text),
                          controller: _searchController,
                          style: TextStyle(fontSize: 16.0),
                          decoration: InputDecoration(
                              hintText: "Search by contract no.",
                              prefixIcon: Icon(
                                Icons.search,
                                size: 20.0,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _searchController.text = "";
                      _search("");
                    }, 
                    child: Text("Clear"))
            ],
          ),
        ),
        body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              labelStyle: TextStyle(fontSize: 12),
              labelColor: AppColors.home,
                  tabs: [
                    Tab(text: "IN-PROGRESS",),
                    Tab(text: "PENDING",),
                    Tab(text: "DELIVERED",),
                  ],
                ),
        Expanded(
          child: TabBarView(
              children: [
                InProgressTab(),
                PendingTab(),
                DeliveredTab(),
              ],
            ),
        ),
          ],
        ),
          ),
        ),
    );
  }
}

class InProgressTab extends StatelessWidget {
  const InProgressTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DeliveryCubit _deliveryCubit = BlocProvider.of<DeliveryCubit>(context);

    return Container(
      child: Center(
        child: BlocBuilder<DeliveryCubit, DeliveryState>(
          builder: (context, state) {
            if (state.deliveriesStatus == DeliveriesStatus.success ||
                state.deliveriesStatus == DeliveriesStatus.error) {
              if (state.inProgressList == null ||
                  state.inProgressList.length == 0) {
                return Text("No deliveries yet");
              }

              return ListView.builder(
                itemCount: state.inProgressList.length,
                itemBuilder: (context, index) {
                  final delivery = state.inProgressList[index];
                  return DeliveryTile(
                      onTap: () {
                        _deliveryCubit.getDelivery(delivery.id);
                        Navigator.pushNamed(context, '/delivery');
                      },
                      title: delivery.fullName,
                      subtitle:
                          delivery.areaName + " - " + delivery.subAreaName,
                      subtitle2: delivery.subscriberAddress,
                      subtitle3: delivery.status,
                      subtitle4: delivery.contractNo ?? "");
                },
              );
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class PendingTab extends StatelessWidget {
  const PendingTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DeliveryCubit _deliveryCubit = BlocProvider.of<DeliveryCubit>(context);

    return Container(
      child: Center(
        child: BlocBuilder<DeliveryCubit, DeliveryState>(
          builder: (context, state) {
            if (state.deliveriesStatus == DeliveriesStatus.success ||
                state.deliveriesStatus == DeliveriesStatus.error) {
              if (state.pendingList == null ||
                  state.pendingList.length == 0) {
                return Text("No deliveries yet");
              }

              return ListView.builder(
                itemCount: state.pendingList.length,
                itemBuilder: (context, index) {
                  final delivery = state.pendingList[index];
                  return DeliveryTile(
                      onTap: () {
                        _deliveryCubit.getDelivery(delivery.id);
                        Navigator.pushNamed(context, '/delivery');
                      },
                      title: delivery.fullName,
                      subtitle:
                          delivery.areaName + " - " + delivery.subAreaName,
                      subtitle2: delivery.subscriberAddress,
                      subtitle3: delivery.status,
                      subtitle4: delivery.contractNo ?? "");
                },
              );
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class DeliveredTab extends StatelessWidget {
  const DeliveredTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DeliveryCubit _deliveryCubit = BlocProvider.of<DeliveryCubit>(context);

    return Container(
      child: Center(
        child: BlocBuilder<DeliveryCubit, DeliveryState>(
          builder: (context, state) {
            if (state.deliveriesStatus == DeliveriesStatus.success ||
                state.deliveriesStatus == DeliveriesStatus.error) {
              if (state.deliveredList == null ||
                  state.deliveredList.length == 0) {
                return Text("No deliveries yet");
              }

              return ListView.builder(
                itemCount: state.deliveredList.length,
                itemBuilder: (context, index) {
                  final delivery = state.deliveredList[index];
                  return DeliveryTile(
                      onTap: () {
                        _deliveryCubit.getDelivery(delivery.id);
                        Navigator.pushNamed(context, '/delivery');
                      },
                      title: delivery.fullName,
                      subtitle:
                          delivery.areaName + " - " + delivery.subAreaName,
                      subtitle2: delivery.subscriberAddress,
                      subtitle3: delivery.status,
                      subtitle4: delivery.contractNo ?? "");
                },
              );
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
