import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jnb_mobile/areas.dart';
import 'package:jnb_mobile/features/delivery_filter/bloc/cubit/delivery_filter_cubit.dart';
import 'package:jnb_mobile/features/delivery/view/failed_deliveries_page.dart';
import 'package:jnb_mobile/sub_areas.dart';
import 'package:jnb_mobile/utilities/colors.dart';
import 'package:provider/provider.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  @override
  final Size preferredSize;

  AppBarComponent({Key key, this.title})
      : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  void _confirmFilter(context) {
    final selectedArea = BlocProvider.of<DeliveryFilterCubit>(context).state.selectedArea;
    final selectedSubArea = BlocProvider.of<DeliveryFilterCubit>(context).state.selectedSubArea;

    // Provider.of<DeliveriesProvider>(context, listen: false)
    //     .refreshDeliveries(area: selectedArea, subArea: selectedSubArea);

    Navigator.pop(context, false);
  }

  Widget sortDialogWidget(BuildContext context) {
    final DeliveryFilterCubit deliveryFilterCubit = BlocProvider.of<DeliveryFilterCubit>(context);

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
            BlocBuilder<DeliveryFilterCubit, DeliveryFilterState>(
              builder: (context, state) {
                return ListTile(
                    title: Text("Area"),
                    subtitle: DropdownButton<String>(
                        value: state.selectedArea ?? '',
                        onChanged: (String newValue) {
                          deliveryFilterCubit.selectArea(newValue);
                        },
                        items: state.areaList == null 
                          ? [DropdownMenuItem<String>(
                            value: "",
                            child: Text("No areas loaded"))]
                          : state.areaList.map<DropdownMenuItem<String>>((Area value) {
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
              child: BlocBuilder<DeliveryFilterCubit, DeliveryFilterState>(
                builder: (context, state) {
                  return ListTile(
                    title: Text("Sub Area"),
                    subtitle: DropdownButton<String>(
                        value: state.selectedSubArea ?? '',
                        onChanged: (String newValue) {
                          deliveryFilterCubit.selectSubArea(newValue);
                        },
                        isExpanded: true,
                        items: state.subAreaList == null 
                          ? [DropdownMenuItem<String>(
                            value: "",
                            child: Text("No sub areas loaded"))]
                          : state.subAreaList.map<DropdownMenuItem<String>>((SubArea value) {
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

  _showFilterDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (_) {
            return sortDialogWidget(context);
          });
    }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: AppColors.home),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.home,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () => _showFilterDialog(context),
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
