import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../features/customers/presentation/screens/customers_list_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/invoices/presentation/screens/invoices_list_screen.dart';
import '../../features/products/presentation/screens/products_list_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../controllers/app_settings_controller.dart';
import '../theme/app_colors.dart';
import 'package:manfc/l10n/app_localizations.dart';

class MainShell extends StatefulWidget {
  final AppSettingsController appSettingsController;

  const MainShell({super.key, required this.appSettingsController});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final GlobalKey<DashboardScreenState> _dashboardKey = GlobalKey();
  final GlobalKey<ProductsListScreenState> _productsKey = GlobalKey();
  final GlobalKey<CustomersListScreenState> _customersKey = GlobalKey();
  final GlobalKey<InvoicesListScreenState> _invoicesKey = GlobalKey();

  void _goToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
    _refreshTab(index);
  }

  void _refreshTab(int index) {
    if (index == 0) {
      _dashboardKey.currentState?.loadDashboard();
    } else if (index == 1) {
      _productsKey.currentState?.loadProducts();
    } else if (index == 2) {
      _customersKey.currentState?.loadCustomers();
    } else if (index == 3) {
      _invoicesKey.currentState?.loadInvoices();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final l10n = AppLocalizations.of(context)!;

    final screens = [
      DashboardScreen(key: _dashboardKey, onNavigateToTab: _goToTab),
      ProductsListScreen(key: _productsKey),
      CustomersListScreen(key: _customersKey),
      InvoicesListScreen(key: _invoicesKey),
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
            _refreshTab(index);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(CupertinoIcons.house),
              selectedIcon: const Icon(CupertinoIcons.house_fill),
              label: l10n.commonHome,
            ),
            NavigationDestination(
              icon: const Icon(CupertinoIcons.cube_box),
              selectedIcon: const Icon(CupertinoIcons.cube_box_fill),
              label: l10n.productsTitle,
            ),
            NavigationDestination(
              icon: const Icon(CupertinoIcons.person_2),
              selectedIcon: const Icon(CupertinoIcons.person_2_fill),
              label: l10n.dashboardCustomers,
            ),
            NavigationDestination(
              icon: const Icon(CupertinoIcons.doc_text),
              selectedIcon: const Icon(CupertinoIcons.doc_text_fill),
              label: l10n.dashboardInvoices,
            ),
            NavigationDestination(
              icon: const Icon(CupertinoIcons.settings),
              selectedIcon: const Icon(CupertinoIcons.settings_solid),
              label: l10n.settingsTitle,
            ),
          ],
        ),
      ),
    );
  }
}
