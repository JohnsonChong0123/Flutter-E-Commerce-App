import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/themes/app_colors.dart';

class NavBarScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const NavBarScreen({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: navigationShell.currentIndex == 2 ? Colors.red : AppColor.green,
        unselectedItemColor: AppColor.placeholder,
        selectedLabelStyle: TextStyle(
          color: navigationShell.currentIndex == 2 ? Colors.red : AppColor.green,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        showUnselectedLabels: false,
        showSelectedLabels: true,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          _onTap(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: AppColor.placeholder, size: 25),
            activeIcon: Icon(Icons.home, color: AppColor.green, size: 25),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              color: AppColor.placeholder,
              size: 25,
            ),
            activeIcon: Icon(
              Icons.shopping_cart,
              color: AppColor.green,
              size: 25,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: AppColor.placeholder, size: 25),
            activeIcon: Icon(Icons.favorite, color: Colors.red, size: 25),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_box,
              color: AppColor.placeholder,
              size: 25,
            ),
            activeIcon: Icon(
              Icons.account_box,
              color: AppColor.green,
              size: 25,
            ),
            label: 'Account',
          ),
        ],
      ),
      floatingActionButton: navigationShell.currentIndex == 1
          ? null
          : FloatingActionButton(
              mini: true,
              backgroundColor: AppColor.green,
              onPressed: () {
                // TODO: Navigate to the chatbot screen
              },
              child: const Icon(Icons.smart_toy_outlined, color: Colors.white),
            ),
    );
  }
}
