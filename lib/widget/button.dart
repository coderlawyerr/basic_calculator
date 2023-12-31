import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    super.key,
    this.color,
    this.textColor,
    required this.buttonText,
    this.onTap,
    this.onDoubleTap,
  });

  final color;
  final textColor;
  final String buttonText;
  final Function()? onTap;
  final Function()? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: color,
          shadowColor: Colors.white,
        ),
        onPressed: onTap,
        onLongPress: onDoubleTap,
        child: Center(
            child: Text(
          buttonText,
          style: TextStyle(
              color: textColor, fontSize: 25, fontWeight: FontWeight.w500),
        )),
      ),
    );
  }
}
