import 'package:flutter/material.dart';

class FullButtonComponent extends StatelessWidget {
  final Icon icon;
  final String label;
  final Function()? onPressed;

  final buttonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    backgroundColor: Colors.red[400]
  );

  FullButtonComponent({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: buttonStyle,
        icon: icon,
        label: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            label,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
