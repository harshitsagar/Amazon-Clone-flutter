import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Row(
          children: [

            CustomButton(
                text: 'Your Orders',
                onTap: () {},
            ),

            CustomButton(
                text: 'Turn Seller',
                onTap: () {},
            ),

          ],
        ),

        SizedBox(height: 20,),

        Row(
          children: [

            CustomButton(
                text: 'Log Out',
                onTap: () => AccountServices().logOut(context),
            ),

            CustomButton(
                text: 'Your Wish List',
                onTap: () {},
            ),

          ],
        ),

      ],
    );
  }
}
