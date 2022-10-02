import 'package:flutter/material.dart';
import 'package:jnb_mobile/models/delivery.dart';
import 'package:jnb_mobile/utilities/color_utility.dart';
// import 'package:jnb_mobile/modules/deliveries/models/delivery.dart';

class SubscriberDetailComponent extends StatelessWidget {
  final Delivery? delivery;

  SubscriberDetailComponent({Key? key, required this.delivery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 10),
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
                "Subscriber Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: ListTile(
                title: Text(delivery!.fullName),
                subtitle: const Text("Name"),
                leading: const Icon(Icons.person),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: ListTile(
                title: Text(
                  delivery!.subscriberAddress ?? "No address",
                  style: const TextStyle(fontSize: 13),
                ),
                subtitle: const Text("Address"),
                leading: const Icon(Icons.location_city),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: ListTile(
                title: Text(delivery!.areaName!),
                subtitle: const Text("Area"),
                leading: const Icon(Icons.location_city),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: ListTile(
                title: Text(delivery!.subAreaName!),
                subtitle: const Text("Sub Area"),
                leading: const Icon(Icons.location_city),
              ),
            ),
            delivery!.subscriberEmail == "" 
            ? const SizedBox()
            : Container(
              alignment: Alignment.centerLeft,
              child: ListTile(
                title: Text(delivery!.subscriberEmail ?? 'No email address'),
                subtitle: const Text("Email Address"),
                leading: const Icon(Icons.email),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: ListTile(
                title: Text(
                    delivery!.coordinates ??
                        'No location, please update location first!',
                    style: TextStyle(
                        color: delivery!.coordinates == null
                            ? Colors.red
                            : Colors.green)),
                subtitle: const Text("Location"),
                leading: const Icon(Icons.pin_drop),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
