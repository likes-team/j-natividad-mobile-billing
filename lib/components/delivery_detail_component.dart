import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jnb_mobile/blocs/deliver/deliver_cubit.dart';
import 'package:jnb_mobile/blocs/deliveries/delivery_cubit.dart';
import 'package:jnb_mobile/components/app_dropdown_component.dart';
import 'package:jnb_mobile/pages/image_viewer_page.dart';
import 'package:jnb_mobile/utilities/color_utility.dart';
import 'package:photo_view/photo_view.dart';

class DeliveryDetailComponent extends StatelessWidget {
  // final Delivery delivery;
  final File? deliveryPhoto;

  DeliveryDetailComponent({Key? key, this.deliveryPhoto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deliverCubit = BlocProvider.of<DeliverCubit>(context);

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 20,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(0),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 10, left: 15),
              child: const Text(
                "Delivery Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            BlocBuilder<DeliveriesCubit, DeliveryState>(
              builder: (context, state) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: ListTile(
                    title: Text(state.selectedDelivery!.status == "DELIVERING"
                        ? "CAPTURED/SAVED"
                        : state.selectedDelivery!.status!),
                    subtitle: const Text("Status"),
                    leading: const Icon(Icons.history_edu),
                  ),
                );
              },
            ),
            BlocBuilder<DeliveriesCubit, DeliveryState>(
              builder: (context, state) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: ListTile(
                    title: AppDropdownComponent(
                      selectedValue: state.selectedDelivery?.remarks ?? 'N/A',
                      listValue: const [
                        'N/A',
                        'MOVE OUT/TRANSFER',
                        'INSUFFICIENT/WRONG ADDRESS',
                        'ABANDON',
                        'MERALCO ADDRESS',
                        'REFUSE TO ACCEPT',
                      ],
                      borderColor: AppColors.secondary,
                      onChanged: state.selectedDelivery!.status == "IN-PROGRESS"
                       ? (value) => deliverCubit.updateRemarks(value!)
                       : null
                    ),
                    subtitle: const Text("Remarks"),
                    leading: const Icon(Icons.history_edu),
                  ),
                );
              },
            ),
            BlocBuilder<DeliveriesCubit, DeliveryState>(
              builder: (context, state) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: ListTile(
                    title: deliveryPhoto == null &&
                            state.selectedDelivery!.status == "IN-PROGRESS"
                        ? Text(_getPhotoDetailMessage(
                            status: state.selectedDelivery!.status,
                            deliveryPhoto: deliveryPhoto))
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageViewerPage(
                                            deliveryPhoto: deliveryPhoto,
                                            delivery: state.selectedDelivery,
                                          )));
                            },
                            child: const Text(
                              "Click to view captured image",
                              style: TextStyle(color: AppColors.primary),
                            )),
                    subtitle: const Text("Captured Photo"),
                    leading: const Icon(Icons.image),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getPhotoDetailMessage({String? status, File? deliveryPhoto}) {
    if (deliveryPhoto == null) {
      return "No captured photo yet";
    }

    return "";
  }
}
