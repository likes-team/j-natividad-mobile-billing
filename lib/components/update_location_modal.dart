import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jnb_mobile/blocs/deliveries/delivery_cubit.dart';
import 'package:jnb_mobile/blocs/location/location_cubit.dart';
import 'package:jnb_mobile/blocs/update_location/update_location_cubit.dart';
import 'package:jnb_mobile/components/expanded_button.dart';
import 'package:jnb_mobile/models/user_location_model.dart';
import 'package:jnb_mobile/utilities/color_utility.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UpdateLocationModal extends StatefulWidget {
  const UpdateLocationModal({Key? key}) : super(key: key);

  @override
  _UpdateLocationModalState createState() => _UpdateLocationModalState();
}

class _UpdateLocationModalState extends State<UpdateLocationModal> {
  late UpdateLocationCubit _updateLocationCubit;
  late DeliveriesCubit _deliveryCubit;
  late LocationCubit _locationCubit;

  @override
  void initState() {
    super.initState();

    // Get bloc instance
    _updateLocationCubit = BlocProvider.of<UpdateLocationCubit>(context);
    _deliveryCubit = BlocProvider.of<DeliveriesCubit>(context);
    _locationCubit = BlocProvider.of<LocationCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateLocationCubit, UpdateLocationState>(
      listener: (context, state) {
        if(state.updateLocationStatus == UpdateLocationStatus.success){
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: state.statusMessage!,
            ),
          );
          Navigator.pop(context);
        } else if(state.updateLocationStatus == UpdateLocationStatus.updating){
          showTopSnackBar(
            context,
            CustomSnackBar.info(
              message: state.statusMessage!,
            ),
          );
        }
      },
      child: AlertDialog(
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        scrollable: true,
        content: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text('Update Sub\'s Location'),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                      ))
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(1, 1, 1, 1),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlocBuilder<DeliveriesCubit, DeliveryState>(
                              builder: (context, state) {
                                return Text(
                                  state.selectedDelivery!.fullName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<DeliveriesCubit, DeliveryState>(
                                builder: (context, state) {
                                  return Text(
                                    state.selectedDelivery!.subAreaName!,
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              BlocBuilder<DeliveriesCubit, DeliveryState>(
                                builder: (context, state) {
                                  return Text(
                                    "Current location: " +
                                        state.selectedDelivery!.coordinates!,
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              BlocBuilder<LocationCubit, UserLocation?>(
                                builder: (context, state) {
                                  return Text(
                                    "New location: ${state?.fullLocation}",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: BlocBuilder<UpdateLocationCubit, UpdateLocationState>(
                    builder: (context, state) {
                      if (state.updateLocationStatus ==
                          UpdateLocationStatus.updating) {
                        return CircularProgressIndicator();
                      }
                      return ExpandedButton(
                        buttonColor: AppColors.primary,
                        borderRadius: 20,
                        expanded: true,
                        elevation: 1,
                        title: 'Confirm Update',
                        titleFontSize: 14,
                        onTap: () async {
                          if (_updateLocationCubit.state.updateLocationStatus !=
                              UpdateLocationStatus.updating) {
                            await _updateLocationCubit.updateLocation(
                              delivery: _deliveryCubit.state.selectedDelivery!,
                              userLocation: _locationCubit.state!,
                            );
                          }
                        },
                        titleAlignment: Alignment.center,
                        titleColor: Colors.white,
                      );
                    },
                  )),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
