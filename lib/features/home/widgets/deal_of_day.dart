import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({super.key});

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {

  Product? product;
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchDealOfDay();
  }

  void fetchDealOfDay() async {
    product = await homeServices.fetchDealOfDay(context: context);
    setState(() {});
  }

  void navigateToDetailScreen() {
    Navigator.pushNamed(context, ProductDetailsScreen.routeName, arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return product==null
        ? Loader() : product!.name.isEmpty
        ? const SizedBox() : GestureDetector(
          onTap: navigateToDetailScreen,
          child: Column(
            children: [

              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 10, top: 15, bottom: 10),
                child: Text(
                  'Deal of the Day',
                  style: GoogleFonts.notoSansAnatolianHieroglyphs(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // 1.......
              Image.network(
                product!.images[0],
                height: 235,
                fit: BoxFit.fitHeight,
              ),

              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  product!.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.notoSansAnatolianHieroglyphs(
                    fontSize: 16,
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 10, top: 5, right: 40),
                child: Text(
                  '\$${product!.price}',
                  style: GoogleFonts.notoSansAnatolianHieroglyphs(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 10,),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: product!.images.map((e)=> Image.network(
                    e,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  )).toList(),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 5).copyWith(left: 15),
                alignment: Alignment.topLeft,
                child: Text(
                  'See all deals',
                  style: TextStyle(
                    color: Colors.cyan[800],
                  ),
                ),
              ),

            ],
              ),
        );
  }
}
