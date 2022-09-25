import 'package:flutter/material.dart';
import 'package:jnb_mobile/utilities/color_utility.dart';

class ExpandedButton extends StatelessWidget {
  const ExpandedButton({
    Key? key,
    this.title = 'Demo',
    this.borderRadius = 10,
    this.onTap,
    this.onLongTap,
    this.buttonColor = Colors.white,
    this.titleColor = Colors.black,
    this.titleAlignment = Alignment.center,
    this.titleFontSize = 14,
    this.expanded = true,
    this.elevation,
  }) : super(key: key);
  final String title;
  final Color buttonColor;
  final Color titleColor;
  final double borderRadius;
  final VoidCallback? onTap;
  final VoidCallback? onLongTap;
  final Alignment titleAlignment;
  final double titleFontSize;
  final bool expanded;
  final double? elevation;

  //----- Button Settings for your specific project -----//
  //----------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return expanded
        ? SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onTap,
              onLongPress: onLongTap,
              style: TextButton.styleFrom(
                elevation: elevation ?? 0,
                padding: const EdgeInsets.only(top: 0, bottom: 0, right: 20, left: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                backgroundColor: buttonColor,
              ),
              child: Align(
                alignment: titleAlignment,
                child: Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color:Colors.white),
                ),
              ),
            ),
          )
        : TextButton(
            onPressed: onTap,
            onLongPress: onLongTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(top: 15, bottom: 15, right: 20, left: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              backgroundColor: AppColors.primary,
            ),
            child: Align(
              alignment: titleAlignment,
              child: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white),
              ),
            ),
          );
  }
}
