import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClassicTextField extends StatelessWidget {
  ClassicTextField({
    Key key,
    this.hintText,
    this.textInputType,
    this.onChange,
    this.inputFormat,
    this.prefixText,
    this.controller,
    this.enable = true,
    this.textAlign,
    this.hintStyle,
    this.style,
  }) : super(key: key);
  final String hintText;
  final TextInputType textInputType;
  final Function(String) onChange;
  final String prefixText;
  final TextEditingController controller;
  final bool enable;
  final TextAlign textAlign;
  final TextStyle hintStyle;
  final TextStyle style;

  final List<TextInputFormatter> inputFormat;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        enabled: enable,
        inputFormatters: inputFormat,
        onChanged: onChange,
        style: style,
        controller: controller,
        keyboardType: textInputType ?? TextInputType.name,
        textAlign: textAlign ?? TextAlign.left,
        decoration: InputDecoration(
          isDense: true,
          prefixText: prefixText,
          prefixStyle: hintStyle,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText ?? '',
          contentPadding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        ),
      ),
    );
  }
}
