import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manfc/app/widgets/app_empty_state.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_responsive.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/app_primary_button.dart';
import '../../../../app/widgets/app_scaffold.dart';
import '../../../../app/widgets/app_search_field.dart';
import '../../../../app/widgets/app_stat_card.dart';
import '../../data/datasources/customer_local_datasource.dart';
import '../../data/models/customer_model.dart';
import '../../domain/entities/customer_entity.dart';
import 'package:manfc/l10n/app_localizations.dart';

import '../widgets/add_edit_customer_dialog.dart';
import '../widgets/customer_card.dart';
import '../widgets/delete_customer_dialog.dart';
import 'customer_details_screen.dart';

class CustomersListScreen extends StatefulWidget {
  const CustomersListScreen({super.key});

  @override
  State<CustomersListScreen> createState() => CustomersListScreenState();
}

class CustomersListScreenState extends State<CustomersListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final CustomerLocalDataSource _localDataSource = CustomerLocalDataSource();

  List<CustomerEntity> _allCustomers = [];
  bool _isLoading = true;
  String _query = '';

  List<CustomerEntity> get _filteredCustomers {
    if (_query.trim().isEmpty) return _allCustomers;

    final q = _query.toLowerCase().trim();

    return _allCustomers.where((customer) {
      return customer.name.toLowerCase().contains(q) ||
          customer.phone.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    setState(() => _isLoading = true);

    final customers = await _localDataSource.getAllCustomers();

    if (!mounted) return;

    setState(() {
      _allCustomers = customers;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _query = value;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  int _gridCount(BuildContext context) {
    if (AppResponsive.isExpanded(context)) return 3;
    if (AppResponsive.isMedium(context)) return 2;
    return 1;
  }

  double _gridChildAspectRatio(BuildContext context) {
    if (AppResponsive.isExpanded(context)) return 1.55;
    if (AppResponsive.isMedium(context)) return 1.45;
    return 2.0;
  }

  Future<void> _openAddCustomerDialog() async {
    final result = await showDialog<CustomerEntity>(
      context: context,
      builder: (_) => const AddEditCustomerDialog(),
    );

    if (result == null) return;

    await _localDataSource.insertCustomer(CustomerModel.fromEntity(result));
    await loadCustomers();

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    _showMessage(l10n.customerSavedMessage);
  }

  Future<void> _openEditCustomerDialog(CustomerEntity customer) async {
    final updated = await showDialog<CustomerEntity>(
      context: context,
      builder: (_) => AddEditCustomerDialog(customer: customer),
    );

    if (updated == null) return;

    await _localDataSource.updateCustomer(CustomerModel.fromEntity(updated));
    await loadCustomers();

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    _showMessage(l10n.customerSavedMessage);
  }

  Future<void> _confirmDeleteCustomer(CustomerEntity customer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteCustomerDialog(customerName: customer.name),
    );

    if (confirmed != true) return;

    await _localDataSource.deleteCustomer(customer.id);
    await loadCustomers();

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    _showMessage(l10n.customerDeletedMessage);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final textStyles = AppTextStyles.create(
      primaryText: palette.textPrimary,
      secondaryText: palette.textSecondary,
      tertiaryText: palette.textTertiary,
      buttonText: palette.textOnPrimary,
    );

    final customers = _filteredCustomers;
    final totalCustomers = _allCustomers.length;

    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      title: l10n.dashboardCustomers,
      useLargeTitle: true,
      trailing: IconButton(
        onPressed: loadCustomers,
        icon: Icon(CupertinoIcons.refresh, color: palette.iconPrimary),
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSearchField(
                    controller: _searchController,
                    hintText: l10n.customersSearchHint,
                    onChanged: _onSearchChanged,
                    onClear: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: AppStatCard(
                          title: l10n.customersTotalTitle,
                          value: '$totalCustomers',
                          subtitle: l10n.customersTotalSubtitle,
                          icon: CupertinoIcons.person_2_fill,
                          tone: AppStatCardTone.blue,
                          compact: true,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppStatCard(
                          title: l10n.customersSearchableTitle,
                          value: totalCustomers == 0 ? '0%' : '100%',
                          subtitle: l10n.customersSearchableSubtitle,
                          icon: CupertinoIcons.search,
                          tone: AppStatCardTone.green,
                          compact: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppPrimaryButton(
                    text: l10n.customersAddBtn,
                    prefixIcon: const Icon(CupertinoIcons.add),
                    onPressed: _openAddCustomerDialog,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Text(l10n.customersAllCustomers, style: textStyles.title3),
                      const Spacer(),
                      Text(
                        l10n.commonItemsCount(customers.length),
                        style: textStyles.footnote.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (customers.isEmpty)
                    AppEmptyState(
                      icon: CupertinoIcons.person_2,
                      title: l10n.customersEmptyTitle,
                      subtitle: l10n.customersEmptySubtitle,
                      actionLabel: l10n.customersAddBtn,
                      onActionTap: _openAddCustomerDialog,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.cardPadding,
                        vertical: AppSpacing.xl,
                      ),
                    )
                  else
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: customers.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _gridCount(context),
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        childAspectRatio: _gridChildAspectRatio(context),
                      ),
                      itemBuilder: (context, index) {
                        final customer = customers[index];

                        return CustomerCard(
                          customer: customer,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    CustomerDetailsScreen(customer: customer),
                              ),
                            );
                          },
                          onEdit: () => _openEditCustomerDialog(customer),
                          onDelete: () => _confirmDeleteCustomer(customer),
                        );
                      },
                    ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
    );
  }
}
