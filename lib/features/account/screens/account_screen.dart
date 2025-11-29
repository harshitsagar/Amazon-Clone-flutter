import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/account/widgets/custom_appbar.dart';
import 'package:amazon_clone/features/account/widgets/orders.dart';
import 'package:amazon_clone/features/account/widgets/top_buttons.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/amazon_in.png',
                  width: 150,
                  height: 45,
                  color: Colors.black,
                ),
              ),

              Container(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                      ),
                    ),

                    Icon(
                      Icons.search,
                      color: Colors.black,
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [

          CustomAppbar(),

          SizedBox(height: 20,),

          TopButtons(),

          SizedBox(height: 20,),

          Orders(),

        ],
      )
    );
  }
}
