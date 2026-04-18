import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../features/customers/presentation/screens/customers_list_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/invoices/presentation/screens/invoices_list_screen.dart';
import '../../features/products/presentation/screens/products_list_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../controllers/app_settings_controller.dart';
import '../theme/app_colors.dart';

class MainShell extends StatefulWidget {
  final AppSettingsController appSettingsController;

  const MainShell({super.key, required this.appSettingsController});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _goToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final screens = [
      DashboardScreen(onNavigateToTab: _goToTab),
      const ProductsListScreen(),
      const CustomersListScreen(),
      const InvoicesListScreen(),
      SettingsScreen(controller: widget.appSettingsController),
    ];

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: IndexedStack(index: _currentIndex, children: screens),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: palette.surface,
          indicatorColor: palette.cardBlueSoft,
          elevation: 0,
          height: 74,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(CupertinoIcons.house),
              selectedIcon: Icon(CupertinoIcons.house_fill),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.cube_box),
              selectedIcon: Icon(CupertinoIcons.cube_box_fill),
              label: 'Products',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.person_2),
              selectedIcon: Icon(CupertinoIcons.person_2_fill),
              label: 'Customers',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.doc_text),
              selectedIcon: Icon(CupertinoIcons.doc_text_fill),
              label: 'Invoices',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.settings),
              selectedIcon: Icon(CupertinoIcons.settings_solid),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
