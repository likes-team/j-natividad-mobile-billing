import 'package:flutter/material.dart';

class AppDropdownComponent extends StatefulWidget {
  const AppDropdownComponent(
      {Key? key,
      required this.selectedValue,
      this.listValue,
      this.hintText,
      this.onChanged,
      this.borderColor})
      : super(key: key);

  final String selectedValue;
  final List<String>? listValue;
  final String? hintText;
  final Function(String?)? onChanged;
  final Color? borderColor;

  @override
  _AppDropdownComponentState createState() => _AppDropdownComponentState();
}

class _AppDropdownComponentState extends State<AppDropdownComponent> {
  String value = '';

  selectedValueHandler() {
    if (widget.selectedValue != '' || widget.selectedValue != null) {
      value = widget.selectedValue;
    }
  }

  @override
  void initState() {
    selectedValueHandler();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: widget.borderColor!)),
      padding: EdgeInsets.only(right: 10.0, left: 10.0),
      child: DropdownButton<String>(
        isExpanded: false,
        hint: widget.selectedValue == ''
            ? Container(
                child: Text(
                  widget.hintText!,
                ),
              )
            : Text(
                widget.selectedValue,
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
        onChanged: widget.onChanged,
        underline: Container(color: Colors.transparent, height: 1.0),
        items: widget.listValue!.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(fontSize: 14.0, color: Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }
}
