import 'package:flutter/material.dart';
import '../../../utilities/colors.dart' show MyColors;

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  @override
  final Size preferredSize;

  AppBarComponent({Key key, this.title})
      : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  Widget sortDialogWidget() {
    return AlertDialog(
      title: Text("Filter"),
      content: Container(
        height: 200,
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            ListTile(
              title: Text("Area"),
              subtitle: DropdownButton<String>(
                  // value: filter.getFilterPersonality(),
                  onChanged: (String newValue) {
                    // filter.setFilterPersonality(newValue);
                  },
                  items: [
                    'All',
                    // localization.filterPersonalityCranky,
                    // localization.filterPersonalityJock,
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              title: Text("Sub Area"),
              subtitle: DropdownButton<String>(
                  // value: filter.getFilterPersonality(),
                  onChanged: (String newValue) {
                    // filter.setFilterPersonality(newValue);
                  },
                  items: [
                    'All',
                    // localization.filterPersonalityCranky,
                    // localization.filterPersonalityJock,
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _showSortDialog() {
      showDialog(
          context: context,
          builder: (_) {
            return sortDialogWidget();
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
