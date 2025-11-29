import 'dart:io';
import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  final AdminServices adminServices = AdminServices();

  String category = 'Mobiles';
  List<File> images = [];
  final _addProductFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  List<String> productCategories = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion'
  ];

  void sellProduct() async { // Add async here
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      setState(() {
        _isLoading = true; // Start loading
      });

      try {
        await adminServices.sellProducts( // Add await here
            context: context,
            name: productNameController.text,
            description: descriptionController.text,
            price: double.parse(priceController.text),
            quantity: double.parse(quantityController.text),
            category: category,
            images: images
        );
      } catch (e) {
        // Handle any errors here if needed
        print('Error selling product: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // Stop loading in finally block
          });
        }
      }
    }
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

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
          title: Text(
              'Add Product',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600
              )
          ),
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                  key: _addProductFormKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
                    child: Column(
                      children: [

                        images.isNotEmpty
                            ? CarouselSlider(
                            items: images.map((i) => Builder(
                              builder: (BuildContext context) => Image.file(i, fit: BoxFit.cover, height: 200),
                            )).toList(),
                            options: CarouselOptions(
                              height: 200,
                              autoPlay: false,
                              autoPlayInterval: Duration(seconds: 3),
                              viewportFraction: 1,
                            )
                        ) : GestureDetector(
                          onTap: selectImages,
                          child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(10),
                              dashPattern: [10,4],
                              strokeCap: StrokeCap.round,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    SizedBox(height: 15,),
                                    Text(
                                      'Select Product Images',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[400],
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ),
                        ),

                        const SizedBox(height: 30,),

                        CustomTextfield(
                            controller: productNameController,
                            hintText: 'Product Name'
                        ),

                        const SizedBox(height: 10,),

                        CustomTextfield(
                            controller: descriptionController,
                            hintText: 'Description',
                            maxLines: 7
                        ),

                        const SizedBox(height: 10,),

                        CustomTextfield(
                            controller: priceController,
                            hintText: 'Price'
                        ),

                        const SizedBox(height: 10,),

                        CustomTextfield(
                            controller: quantityController,
                            hintText: 'Quantity'
                        ),

                        const SizedBox(height: 10,),

                        SizedBox(
                          width: double.infinity,
                          child: DropdownButton(
                            // isExpanded: true,
                            value: category,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            underline: SizedBox.shrink(),
                            items: productCategories.map<DropdownMenuItem<String>>((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                category = newValue!;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 10,),

                        CustomButton(
                          text: 'Sell',
                          onTap: sellProduct,
                        ),

                        SizedBox(height: 20,),

                      ],
                    ),
                  )
              ),
      ),

    );
  }
}
