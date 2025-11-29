import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/admin/widgets/category_products.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {

  final AdminServices adminServices = AdminServices();
  int? totalSales;
  List<Sales>? earnings;

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    totalSales = earningData['totalEarnings'];
    earnings = earningData['sales'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null ? const Loader() : Column(
      children: [

        SizedBox(height: 20,),

        Text(
          'TotalEarnings: \$$totalSales',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
          ),
        ),

        Container(
          height: 250,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          margin: EdgeInsets.symmetric(vertical: 20),
          child: CategoryProductsChart(
            data: earnings!,
          ),
        ),
        
      ],
    );
  }
}
