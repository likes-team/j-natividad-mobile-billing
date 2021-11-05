import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:jnb_mobile/modules/deliveries/providers/deliveries_provider.dart';
import 'package:jnb_mobile/modules/offline_manager/services/failed_deliveries.dart';
import 'package:jnb_mobile/utilities/colors.dart';
import 'package:provider/provider.dart';

class DeliveringPage extends StatelessWidget {
  final failedDeliveriesService = FailedDeliveryService();

  _resendFailedDeliveries() async {
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
          await failedDeliveriesService.redeliverFailedDeliveries();
        } else {
          BotToast.showSimpleNotification(
            title: "No failed deliveries.",
            subTitle: "Press refresh button to check again.",
            backgroundColor: Colors.blue[200],
          );
        }
      }
    } on SocketException catch (_) {
      BotToast.showSimpleNotification(
        title: "No internet.",
        subTitle: "Please try to resend again later.",
        backgroundColor: Colors.yellow[200],
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<DeliveriesProvider>(context, listen: false).getDeliveringData();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Activity",
          style: TextStyle(
            color: AppColors.home,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: AppColors.home,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resendFailedDeliveries,
        child: Icon(Icons.schedule_send),
        backgroundColor: Colors.green,
        tooltip: "Redeliver",
      ),
      body: Center(
        child: Consumer<DeliveriesProvider>(
          builder: (context, provider, child) {
            if (provider.deliveringList.isEmpty) {
              return Text("Your failed deliveries will display here.");
            }

            return ListView.builder(
              itemCount: provider.deliveringList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.schedule_send),
                        title: Text(
                          provider.deliveringList[index].fullName,
                        ),
                        subtitle: Text(
                          provider.deliveringList[index].subscriberAddress,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(provider.deliveringList[index].status),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
