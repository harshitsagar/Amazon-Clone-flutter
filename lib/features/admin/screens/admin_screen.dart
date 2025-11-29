import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/admin/screens/analytics_screen.dart';
import 'package:amazon_clone/features/admin/screens/orders_screen.dart';
import 'package:amazon_clone/features/admin/screens/posts_screen.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    PostsScreen(),
    AnalyticsScreen(),
    OrdersScreen(),
  ];

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

              const Text(
                'Admin',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),

            ],
          ),
        ),
      ),

      body: pages[_page],

      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _page,
          selectedItemColor: GlobalVariables.selectedNavBarColor,
          unselectedItemColor: GlobalVariables.unselectedNavBarColor,
          backgroundColor: GlobalVariables.backgroundColor,
          iconSize: 28,
          onTap: (int index){
            setState(() {
              _page = index;
            });
          },
          items: [

            // Posts ...
            BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: _page == 0
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.backgroundColor,
                      width: bottomBarBorderWidth,
                    ),
                  ),
                ),
                child: Icon(
                  Icons.home_outlined,
                ),
              ),
              label: '',
            ),

            // Analytics .....
            BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: _page == 1
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.backgroundColor,
                      width: bottomBarBorderWidth,
                    ),
                  ),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                ),
              ),
              label: '',
            ),

            // Orders .....
            BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: _page == 2
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.backgroundColor,
                      width: bottomBarBorderWidth,
                    ),
                  ),
                ),
                child: Icon(
                  Icons.all_inbox_outlined,
                ),
              ),
              label: '',
            ),

          ]
      ),

    );
  }
}
