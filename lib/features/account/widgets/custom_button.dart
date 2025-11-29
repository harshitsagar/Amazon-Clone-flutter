import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const CustomButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0),
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.only(left: 20, right: 20),
            backgroundColor: Colors.black12.withOpacity(0.08),
            side: BorderSide(color: Colors.black.withOpacity(0.07), width: 2),
          ),
          onPressed: onTap,
          child: Text(
            text,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal
            ),
          ),
        ),
      ),
    );
  }
}
