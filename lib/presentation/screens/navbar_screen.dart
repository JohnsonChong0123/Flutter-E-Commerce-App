import '/core/extensions/theme_extensions.dart';
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
        selectedItemColor: 
        // navigationShell.currentIndex == 2
        //     ? Colors.red
        //     : 
            context.colorScheme.primary,
        unselectedItemColor: AppColor.placeholder,
        selectedLabelStyle: TextStyle(
          color: 
          // navigationShell.currentIndex == 2
          //     ? Colors.red
          //     : 
              context.colorScheme.primary,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        showUnselectedLabels: false,
        showSelectedLabels: true,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          _onTap(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home, color: AppColor.placeholder, size: 25),
            activeIcon: Icon(Icons.home, color: context.colorScheme.primary, size: 25),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: const Icon(
              Icons.search,
              color: AppColor.placeholder,
              size: 25,
            ),
            activeIcon: Icon(Icons.search, color: context.colorScheme.primary, size: 25),
            label: 'Search',
          ),

          BottomNavigationBarItem(
            icon: const Icon(
              Icons.shopping_cart,
              color: AppColor.placeholder,
              size: 25,
            ),
            activeIcon: Icon(Icons.shopping_cart, color: context.colorScheme.primary, size: 25),
            label: 'Cart',
          ),

          BottomNavigationBarItem(
            icon: const Icon(
              Icons.person,
              color: AppColor.placeholder,
              size: 25,
            ),
            activeIcon: Icon(
              Icons.person,
              color: context.colorScheme.primary,
              size: 25,
            ),
            label: 'Profile',
          ),
        ],
      ),
      // floatingActionButton: navigationShell.currentIndex == 1
      //     ? null
      //     : FloatingActionButton(
      //         mini: true,
      //         backgroundColor: AppColor.green,
      //         onPressed: () {
      //           // TODO: Navigate to the chatbot screen
      //         },
      //         child: const Icon(Icons.smart_toy_outlined, color: Colors.white),
      //       ),
    );
  }
}
