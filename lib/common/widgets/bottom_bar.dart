import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/account/screens/account_screen.dart';
import 'package:amazon_clone/features/cart/screens/cart_screen.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/bottom-bar';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    HomeScreen(),
    AccountScreen(),
    CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final userCartLen = context.watch<UserProvider>().user.cart.length;
    return Scaffold(

      body: pages[_page],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
            elevation: 10,
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

              // HOME ...
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

              // profile .....
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
                    Icons.person_outline_outlined,
                  ),
                ),
                label: '',
              ),

              // Cart .....
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
                  child: badges.Badge(
                    position: badges.BadgePosition.topEnd(top: -14, end: -2),
                    badgeContent: Text(userCartLen.toString()),
                    badgeStyle: const badges.BadgeStyle(
                      elevation: 0,
                      badgeColor: Colors.white,
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                    ),
                  ),
                ),
                label: '',
              ),

            ]
        ),
      ),

    );
  }
}
