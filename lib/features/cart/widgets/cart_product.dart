import 'package:amazon_clone/features/cart/services/cart_services.dart';
import 'package:amazon_clone/features/product_details/services/product_details_services.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({super.key, required this.index});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {

  final ProductDetailsServices productDetailsServices = ProductDetailsServices();
  final CartServices cartServices = CartServices();

  void increaseQuantity(Product product) {
    productDetailsServices.addToCart(
        context: context,
        product: product
    );
  }

  void decreaseQuantity(Product product) {
    cartServices.removeFromCart(
        context: context,
        product: product
    );
  }

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart[widget.index];
    final product = Product.fromMap(productCart['product']);
    final quantity = productCart['quantity'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFFf8f9fb),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 0.5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [

              Image.network(
                product.images[0],
                fit: BoxFit.contain,
                height: 135,
                width: 135,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      width: 235,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Container(
                      width: 235,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        '\$${product.price}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Prime image
                          Image.asset(
                            'assets/prime_logo.png', // your image path
                            height: 25,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 2),

                          Text(
                            'Tomorrow',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                          children: [
                            TextSpan(
                              text: "FREE delivery ",
                              style: GoogleFonts.notoSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                letterSpacing: 0.2,
                                height: 1.2, // similar line height
                              ),
                            ),
                            TextSpan(
                              text: "Tomorrow 10 am - 12 pm. ",
                              style: GoogleFonts.notoSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: 235,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      child: Text(
                        'In Stock',
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        maxLines: 2,
                      ),
                    ),

                    /*
                    Container(
                      width: 235,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      child: Text(
                        '10 days Service Centre Replacement',
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                      ),
                    ),

                     */

                    /*
                    Container(
                      width: 235,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        '\$30 Cashback applied. Buy with other items in cart.',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                      ),
                    ),

                     */

                  ],
                ),
              )
            ],
          ),

          SizedBox(height: 8,),

          Row(
            children: [

              // Quantity Box
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber, width: 2.5),
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => decreaseQuantity(product),
                      child: Icon(
                        quantity == 1 ? Icons.delete_outline : Icons.remove,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        quantity.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () => increaseQuantity(product),
                        child: Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.black
                        ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 40),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Text(
                  'Delete',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Text(
                  'Save for later',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}
