import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/address/screens/address_screen.dart';
import 'package:amazon_clone/features/cart/widgets/cart_product.dart';
import 'package:amazon_clone/features/cart/widgets/cart_subtotal.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void navigateToAddress(int sum) {
    Navigator.pushNamed(context, AddressScreen.routeName, arguments: sum.toString());
  }

  @override
  Widget build(BuildContext context) {

    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart
        .map((e) => sum+=e['quantity']*e['product']['price'] as int)
        .toList();

    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide:
                          BorderSide(color: Colors.black38, width: 1),
                        ),
                        hintText: 'Search Amazon.in',
                        hintStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.mic, color: Colors.black, size: 25),
              ),

            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        // physics: const ClampingScrollPhysics(),
        child: Column(
          children: [

            const AddressBox(),

            CartSubtotal(),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
            //   child: CustomButton(
            //       text: 'Proceed to Buy (${user.cart.length} items)',
            //       onTap: () => navigateToAddress(sum),
            //       color: Color(0xFFfed813),
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
              child: CustomButton(
                text: 'Proceed to Buy (${user.cart.length} items)',
                onTap: () {
                  if (user.cart.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('🛒 Your cart is empty! Add items to proceed.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                        backgroundColor: Colors.black,
                        duration: Duration(seconds: 4),
                      ),
                    );
                  } else {
                    navigateToAddress(sum);
                  }
                },
                color: Color(0xFFfed813),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                color: Colors.grey.shade400,
                height: 0.5,
              ),
            ),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: user.cart.length,
              itemBuilder: (context, index) {
                return CartProduct(index: index);
              },
            ),

          ],
        ),
      ),

    );
  }
}
