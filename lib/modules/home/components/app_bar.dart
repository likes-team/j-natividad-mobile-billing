import 'package:flutter/material.dart';
import 'package:jnb_mobile/areas.dart';
import 'package:jnb_mobile/modules/deliveries/pages/delivering_page.dart';
import 'package:jnb_mobile/modules/deliveries/providers/areas_provider.dart';
import 'package:jnb_mobile/modules/deliveries/providers/deliveries_provider.dart';
import 'package:jnb_mobile/sub_areas.dart';
import 'package:provider/provider.dart';
import '../../../utilities/colors.dart' show MyColors;

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  @override
  final Size preferredSize;

  AppBarComponent({Key key, this.title})
      : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  _confirmFilter(context) {
    var area = Provider.of<AreasProvider>(context, listen: false).selectedArea;
    var subArea =
        Provider.of<AreasProvider>(context, listen: false).selectedSubArea;

    Provider.of<DeliveriesProvider>(context, listen: false)
        .refreshDeliveries(area: area, subArea: subArea);

    Navigator.pop(context, false);
  }

  Widget sortDialogWidget(areas, subAreas, context) {
    return AlertDialog(
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () => _confirmFilter(context),
        )
      ],
      title: Text("Filter"),
      content: Container(
        height: 200,
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Consumer<AreasProvider>(
              builder: (context, provider, child) {
                return ListTile(
                    title: Text("Area"),
                    subtitle: DropdownButton<String>(
                        value: provider.selectedArea,
                        onChanged: (String newValue) {
                          provider.selectedArea = newValue;
                        },
                        items:
                            areas.map<DropdownMenuItem<String>>((Area value) {
                          return DropdownMenuItem<String>(
                            value: value.areaName,
                            child: Text(value.areaName),
                          );
                        }).toList()));
              },
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Consumer<AreasProvider>(
                builder: (context, provider, _) {
                  return ListTile(
                    title: Text("Sub Area"),
                    subtitle: DropdownButton<String>(
                        value: provider.selectedSubArea,
                        onChanged: (String newValue) {
                          provider.selectedSubArea = newValue;
                        },
                        isExpanded: true,
                        items: provider.subAreasList
                            .map<DropdownMenuItem<String>>((SubArea value) {
                          return DropdownMenuItem<String>(
                            value: value.subAreaName,
                            child: Text(value.subAreaName),
                          );
                        }).toList()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _gotoDeliveringPage(BuildContext context) {
    Navigator.push(
        (context), MaterialPageRoute(builder: (context) => DeliveringPage()));
  }

  @override
  Widget build(BuildContext context) {
    var areas = Provider.of<AreasProvider>(context).areaList;
    var subAreas = Provider.of<AreasProvider>(context).subAreasList;

    _showSortDialog() {
      showDialog(
          context: context,
          builder: (_) {
            return sortDialogWidget(areas, subAreas, context);
          });
    }

    return AppBar(
      iconTheme: IconThemeData(color: MyColors.home),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(
          color: MyColors.home,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        if (title == "Deliveries")
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => _gotoDeliveringPage(context),
              child: Icon(
                Icons.schedule_send,
                size: 26.0,
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: _showSortDialog,
            child: Icon(
              Icons.sort,
              size: 26.0,
            ),
          ),
        ),
      ],
    );
  }
}
