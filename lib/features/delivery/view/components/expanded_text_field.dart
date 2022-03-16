import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpandedTextField extends StatelessWidget {
  ExpandedTextField({
    Key key,
    this.hintText,
    this.textColor,
    this.bgColor,
    this.inputFormat,
    this.controller,
    this.styleHint,
    this.style,
  }) : super(key: key);

  final String hintText;
  final Color textColor;
  final Color bgColor;
  final TextEditingController controller;
  final TextEditingController _internalIontroller = TextEditingController();
  final List<TextInputFormatter> inputFormat;
  final TextStyle styleHint;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        inputFormatters: inputFormat,
        autocorrect: false,
        textCapitalization: TextCapitalization.words,
        expands: true,
        style: style,
        keyboardType: TextInputType.multiline,
        controller: controller ?? _internalIontroller,
        maxLines: null,
        decoration: InputDecoration(
          fillColor: Colors.grey[100],
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText ?? '',
          hintStyle: styleHint,
          contentPadding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
        ),
      ),
    );
  }
}
