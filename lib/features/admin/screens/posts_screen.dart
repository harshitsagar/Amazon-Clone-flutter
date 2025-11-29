import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {

  List<Product>? products;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  void fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  void navigateToAddProduct(){
    Navigator.pushNamed(
        context,
        AddProductScreen.routeName
    ).then((value) {
      // This will be called when returning from AddProductScreen .....
      fetchAllProducts();
    });
  }

  void deleteProduct(Product product, int index) {

    adminServices.deleteProduct(
        context: context,
        product: product,
        onSuccess: () {
          products!.removeAt(index);
          setState(() {});
        }
    );

  }

  void _showDeleteConfirmationDialog(Product product, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Delete Product",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          content: Text(
            "Are you sure you want to delete \"${product.name}\" ?",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                  // fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                deleteProduct(product, index); // Proceed with deletion
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: Text(
                "Yes",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return products == null ? Loader() : Scaffold(

      body: products!.isEmpty ? Center(
        child: Text(
          'No products available\nTap the + button to add your first product!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
          ),
        ),
      ) : GridView.builder(
          itemCount: products!.length,
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.95, // Adjust this value to control item height
          ),
          itemBuilder: (context, index) {
            final productData = products![index];
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [

                  SizedBox(height: 10),

                  SizedBox(
                    height: 140,
                    child: SingleProduct(
                        image: productData.images[0],
                    ),
                  ),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
              
                      SizedBox(width: 10,),
              
                      Expanded(
                          child: Text(
                            productData.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                      ),

                      IconButton(
                          onPressed: () => _showDeleteConfirmationDialog(productData, index),
                          icon: Icon(Icons.delete_outline)
                      ),

                    ],
                  ),
              
                ],
              ),
            );
          }
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        onPressed: navigateToAddProduct,
        tooltip: 'Add a Product',
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}