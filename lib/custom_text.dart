import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatefulWidget {
  const CustomText(
    this.text, {
    Key? key,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.color,
  }) : super(key: key);

  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final Color? color;

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      textAlign: widget.textAlign,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
        color: widget.color,
      )),
    );
  }
}
