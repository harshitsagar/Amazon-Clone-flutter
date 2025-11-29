import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart
        .map((e) => sum+=e['quantity']*e['product']['price'] as int)
        .toList();

    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            'Shopping Cart',
            style: GoogleFonts.notoSans(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            color: Colors.grey.shade400,
            height: 0.5,
          ),

          Row(
            children: [

              Text(
                'Subtotal ',
                style: GoogleFonts.notoSansAnatolianHieroglyphs(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),

              Text(
                '\$$sum',
                style: GoogleFonts.notoSansAnatolianHieroglyphs(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

            ],
          ),

          SizedBox(height: 8,),

          Row(
            children: [

              Text(
                'EMI Available ',
                style: GoogleFonts.notoSansAnatolianHieroglyphs(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),

              Text(
                'Details',
                style: GoogleFonts.notoSansAnatolianHieroglyphs(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.blueAccent,
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}
