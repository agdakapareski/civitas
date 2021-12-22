import 'package:flutter/material.dart';

class Colour {
  static Color green = const Color(0xFF1CBC9B);
  static Color blue = const Color(0xFF3498DA);
  static Color purple = const Color(0xFF9B59B6);
  static Color yellow = const Color(0xFFF1C50D);
  static Color red = const Color(0xFFE74C3B);
  static Color black = const Color(0xFF2D3E4F);
}

class ActivityButton extends StatefulWidget {
  const ActivityButton({
    Key? key,
    this.child,
    this.color,
    this.onTap,
  }) : super(key: key);

  final Color? color;
  final Widget? child;
  final void Function()? onTap;

  @override
  _ActivityButtonState createState() => _ActivityButtonState();
}

class _ActivityButtonState extends State<ActivityButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: widget.color ?? Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        width: 108,
        height: 108,
        child: widget.child,
      ),
    );
  }
}

colorChanges(String activity) {
  if (activity == 'Di Kantor') {
    return Colour.green;
  } else if (activity == 'Visit Customer') {
    return Colour.blue;
  } else if (activity == 'Di Workshop') {
    return Colour.purple;
  } else if (activity == 'Istirahat') {
    return Colour.yellow;
  } else if (activity == 'Izin') {
    return Colour.red;
  } else if (activity == 'Dinas di Luar') {
    return Colour.black;
  } else {
    return Colors.green[900];
  }
}
