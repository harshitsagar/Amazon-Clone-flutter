import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/stars.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/product_details/services/product_details_services.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  int _current = 0;
  final ProductDetailsServices productDetailsServices = ProductDetailsServices();
  double avgRating = 0;
  double myRating = 0;

  @override
  void initState() {
    super.initState();

    double totalRating = 0;
    for(int i = 0; i < widget.product.rating!.length; i++) {
      totalRating += widget.product.rating![i].rating;
      if(widget.product.rating![i].userId == Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.product.rating![i].rating;
      }
    }

    if(totalRating != 0) {
      avgRating = totalRating / widget.product.rating!.length;
    }

  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void addToCart() {
    productDetailsServices.addToCart(
        context: context,
        product: widget.product,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final isAdmin = user.type == 'admin';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CarouselSlider(
                  items: widget.product.images.map((i) => Builder(
                    builder: (BuildContext context) => Image.network(i, fit: BoxFit.cover, height: 200),
                  )).toList(),
                  options: CarouselOptions(
                    height: 220,
                    autoPlay: false,
                    autoPlayInterval: Duration(seconds: 3),
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  )
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  SizedBox(width: 50,),

                  // Sliding indicator .....
                  widget.product.images.length > 1
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.product.images.asMap().entries.map((entry) {
                      return Container(
                        width: 10,
                        height: 10,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == entry.key
                              ? Colors.orange
                              : Colors.grey.withOpacity(0.5),
                        ),
                      );
                    }).toList(),
                  ) : SizedBox(),

                  Row(
                    children: [

                      Icon(
                          Icons.favorite_outline,
                          color: Colors.black,
                          size: 25
                      ),
                      const SizedBox(width: 10,),
                      Icon(
                          Icons.share_outlined,
                          color: Colors.black,
                          size: 25
                      ),

                    ],
                  ),

                ],
              ),
            ),

            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product name wrapped in Expanded to take available space
                  Expanded(
                    child: Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis, // Add ellipsis if text is too long
                      maxLines: 2, // Allow up to 2 lines for the product name
                    ),
                  ),

                  const SizedBox(width: 10), // Add some spacing between name and stars

                  // Stars widget - doesn't need expansion as it has fixed size
                  Stars(rating: avgRating, size: 16,),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,),
              child: Text(
                widget.product.description,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: RichText(
                  text: TextSpan(
                      text: 'Deal Price: ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    children: [
                      TextSpan(
                          text: '\$${widget.product.price}',
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.red,
                              fontWeight: FontWeight.w500
                          ),
                      ),
                    ]
                  ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: RichText(
                text: TextSpan(
                    text: 'Buy now & pay next month at 0% interest ',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold
                    ),
                    children: [
                      TextSpan(
                        text: 'with Amazon Pay Later',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade500,
                            // fontWeight: FontWeight.w700
                        ),
                      ),
                      TextSpan(
                        text: '\nActivate now >',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ]
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Prime image
                  Image.asset(
                    'assets/prime_logo.png', // your image path
                    height: 30,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 4),

                  // "Today" blue container
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1c9cfd),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Today',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              )
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
              child: Text(
                'Inclusive of all taxes',
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                  height: 1.2, // similar line height
                ),
              )
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              color: Colors.grey.shade400,
              height: 1.5,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children:  [
                      Image.asset(
                        'assets/discount.png',
                        height: 30,
                        width: 30,
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "See all offers & discounts",
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          letterSpacing: 0.2,
                          height: 1.2, // similar line height
                        ),
                      ),
                    ],
                  ),
                  Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                      size: 30
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              color: Colors.grey.shade400,
              height: 1.5,
            ),

            SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                  children: [
                    TextSpan(
                      text: "FREE delivery ",
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        letterSpacing: 0.2,
                        height: 1.2, // similar line height
                      ),
                    ),
                    TextSpan(
                      text: "Tomorrow 6 am - 8 pm. ",
                      style: GoogleFonts.notoSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: 0.2,
                        height: 1.2, // similar line height
                      ),
                    ),
                    TextSpan(
                      text: "Order within 21 mins. ",
                      style: GoogleFonts.notoSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent.shade700,
                        letterSpacing: 0.2,
                        height: 1.2, // similar line height
                      ),
                    ),

                    TextSpan(
                      text: "Details",
                      style: GoogleFonts.notoSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue.shade700,
                        decorationThickness: 1.5,
                        letterSpacing: 0.2,
                        height: 1.2,
                      ),
                    ),

                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            // Delivery address
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.black,
                    size: 24,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "Delivery to ${user.name} - ${user.address} New Delhi 110063",
                      style: TextStyle(
                        color: Colors.blueAccent.shade700,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),

            // Stock info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Text(
                "In stock",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ),

            SizedBox(height: 6),

            // Cashback info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.lightGreenAccent.shade700,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "Upto ₹120 cashback",
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        height: 1.2, // similar line height
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "₹30 per unit on buying 2+",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20,),

            if (!isAdmin)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: CustomButton(
                    text: 'Add to Cart',
                    color: Color(0xFFfed813),
                    onTap: addToCart,
                ),
              ),

            if (!isAdmin)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: CustomButton(
                    text: 'Buy Now',
                    // color: Color(0xFFffa51d),
                    onTap: () {}
                ),
              ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Text(
                    'Ships from',
                    style: GoogleFonts.notoSansAnatolianHieroglyphs(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(width: 70,),

                  Text(
                    'Amazon',
                    style: GoogleFonts.notoSansAnatolianHieroglyphs(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Text(
                    'Sold by',
                    style: GoogleFonts.notoSansAnatolianHieroglyphs(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(width: 96,),

                  Expanded(
                    child: Text(
                      'Clicktech Retail Private Ltd',
                      style: GoogleFonts.notoSansAnatolianHieroglyphs(
                        fontSize: 14,
                        color: Colors.blueAccent.shade700,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Text(
                    'Payment',
                    style: GoogleFonts.notoSansAnatolianHieroglyphs(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(width: 85,),

                  Expanded(
                    child: Text(
                      'Credit/Debit cards, UPI',
                      style: GoogleFonts.notoSansAnatolianHieroglyphs(
                        fontSize: 14,
                        color: Colors.blueAccent.shade700,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 30,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Gift-wrap available',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Add to Wish List',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              color: Colors.grey.shade400,
              height: 1.9,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Shop with confidence',
                style: GoogleFonts.notoSansAnatolianHieroglyphs(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Image.asset(
                    'assets/replacement_logo.png',
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover,
                  ),

                  SizedBox(width: 8,),

                  Expanded(
                    child: Text(
                      '10 days Service Centre Replacement',
                      style: GoogleFonts.notoSansAnatolianHieroglyphs(
                        fontSize: 14,
                        color: Colors.blueAccent.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),

                  SizedBox(width: 50,),

                  Icon(
                    Icons.local_shipping,
                    size: 24,
                  ),

                  SizedBox(width: 8,),

                  Expanded(
                    child: Text(
                      'Free Delivery',
                      style: GoogleFonts.notoSansAnatolianHieroglyphs(
                        fontSize: 14,
                        color: Colors.blueAccent.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Icon(
                    Icons.verified_user_outlined,
                    size: 24,
                  ),

                  SizedBox(width: 8,),

                  Expanded(
                    child: Text(
                      '1 Year Warranty',
                      style: GoogleFonts.notoSansAnatolianHieroglyphs(
                        fontSize: 15,
                        color: Colors.blueAccent.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),

                  SizedBox(width: 50,),

                  Icon(
                    Icons.payments_outlined,
                    size: 24,
                  ),

                  SizedBox(width: 8,),

                  Expanded(
                    child: Text(
                      'Pay on Delivery',
                      style: GoogleFonts.notoSansAnatolianHieroglyphs(
                        fontSize: 14,
                        color: Colors.blueAccent.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Icon(
                    Icons.emoji_events,
                    size: 24,
                  ),

                  SizedBox(width: 8,),

                  Expanded(
                    child: Text(
                      'Top Brand',
                      style: GoogleFonts.notoSansAnatolianHieroglyphs(
                        fontSize: 15,
                        color: Colors.blueAccent.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),

                  SizedBox(width: 30,),

                  Icon(
                    Icons.local_shipping_outlined,
                    size: 24,
                  ),

                  SizedBox(width: 8,),

                  Expanded(
                    child: Text(
                      'Amazon Delivered',
                      style: GoogleFonts.notoSansAnatolianHieroglyphs(
                        fontSize: 14,
                        color: Colors.blueAccent.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Icon(
                    Icons.lock_outline,
                    size: 24,
                  ),

                  SizedBox(width: 8,),

                  Expanded(
                    child: Text(
                      'Secure transaction',
                      style: GoogleFonts.notoSansAnatolianHieroglyphs(
                        fontSize: 15,
                        color: Colors.blueAccent.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),

                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              color: Colors.grey.shade400,
              height: 1.9,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Rate this product',
                style: GoogleFonts.notoSansAnatolianHieroglyphs(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),

            if (!isAdmin)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: RatingBar.builder(
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: GlobalVariables.secondaryColor,
                    ),
                    onRatingUpdate: (rating) {
                      productDetailsServices.rateProduct(
                          context: context,
                          product: widget.product,
                          rating: rating
                      );
                    },
                    initialRating: myRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4),
                ),
              ),

            SizedBox(height: 40),

          ],
        ),
      ),

    );
  }
}
