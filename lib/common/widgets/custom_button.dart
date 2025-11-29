import 'package:amazon_clone/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(
        text,
        style: GoogleFonts.notoSans(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? GlobalVariables.secondaryColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}