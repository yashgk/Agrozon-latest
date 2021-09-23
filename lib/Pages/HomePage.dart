import 'package:agrozon/AppConstants/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:agrozon/Pages/Screens/StorePage.dart';
import 'package:agrozon/Pages/Screens/AccountPage.dart';
import 'package:agrozon/Pages/Screens/FavouritePage.dart';
import 'package:agrozon/Pages/Screens/OrderPage.dart';
import 'package:agrozon/CommonWidgets/CustomAppBar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<Widget> screenList;

  void initTabs() async {
    setState(() {
      screenList = [
        StorePage(),
        OrderPage(),
        FavouritePage(),
        AccountPage(),
      ];
    });
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    initTabs();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(),
      body: Container(
        child: screenList.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            label: 'Store',
            activeIcon: Icon(Icons.store),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Orders',
              activeIcon: Icon(Icons.shopping_cart)),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              label: 'Favourites',
              activeIcon: Icon(Icons.favorite)),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Account',
              activeIcon: Icon(Icons.account_circle)),
        ],
        currentIndex: selectedIndex,
        backgroundColor: AppColors.darkGreyColor,
        showUnselectedLabels: true,
        selectedItemColor: AppColors.whiteColor,
        unselectedItemColor: AppColors.darkSlateGreyColor,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) => onItemTapped(index),
      ),
    );
  }
}
