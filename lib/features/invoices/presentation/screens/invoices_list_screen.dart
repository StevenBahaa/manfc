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
import '../../../customers/data/datasources/customer_local_datasource.dart';
import '../../../customers/domain/entities/customer_entity.dart';
import '../../../products/data/datasources/product_local_datasource.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../data/datasources/invoice_local_datasource.dart';
import '../../data/models/invoice_item_model.dart';
import '../../data/models/invoice_model.dart';
import '../../domain/entities/invoice_entity.dart';
import '../widgets/delete_invoice_dialog.dart';
import '../widgets/invoice_card.dart';
import 'invoice_details_screen.dart';
import 'invoice_form_screen.dart';

enum InvoiceListFilter { all, outstanding, paid, cancelled }

class InvoicesListScreen extends StatefulWidget {
  const InvoicesListScreen({super.key});

  @override
  State<InvoicesListScreen> createState() => _InvoicesListScreenState();
}

class _InvoicesListScreenState extends State<InvoicesListScreen> {
  final TextEditingController _searchController = TextEditingController();

  final InvoiceLocalDataSource _invoiceLocalDataSource =
      InvoiceLocalDataSource();
  final CustomerLocalDataSource _customerLocalDataSource =
      CustomerLocalDataSource();
  final ProductLocalDataSource _productLocalDataSource =
      ProductLocalDataSource();

  List<InvoiceEntity> _allInvoices = [];
  bool _isLoading = true;
  String _query = '';

  InvoiceListFilter _selectedFilter = InvoiceListFilter.all;

  List<InvoiceEntity> get _filteredInvoices {
    final q = _query.toLowerCase().trim();

    final filtered = _allInvoices.where((invoice) {
      final invoiceRef = invoice.id.length > 6
          ? invoice.id.substring(invoice.id.length - 6).toLowerCase()
          : invoice.id.toLowerCase();

      final matchesSearch =
          q.isEmpty ||
          invoice.customerName.toLowerCase().contains(q) ||
          invoiceRef.contains(q);

      final matchesFilter = switch (_selectedFilter) {
        InvoiceListFilter.all => true,
        InvoiceListFilter.outstanding => invoice.remainingAmount > 0,
        InvoiceListFilter.paid => invoice.status == 'paid',
        InvoiceListFilter.cancelled => invoice.status == 'cancelled',
      };

      return matchesSearch && matchesFilter;
    }).toList();

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return filtered;
  }

  double get _filteredOutstandingTotal {
    return _filteredInvoices.fold<double>(
      0,
      (sum, invoice) => sum + invoice.remainingAmount,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    setState(() => _isLoading = true);

    final invoices = await _invoiceLocalDataSource.getAllInvoices();

    if (!mounted) return;

    setState(() {
      _allInvoices = invoices;
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
    if (AppResponsive.isExpanded(context)) return 1.42;
    if (AppResponsive.isMedium(context)) return 1.34;
    return 1.75;
  }

  Future<void> _openCreateInvoiceDialog() async {
    final List<CustomerEntity> customers = await _customerLocalDataSource
        .getAllCustomers();
    final List<ProductEntity> products = await _productLocalDataSource
        .getAllProducts();

    if (!mounted) return;

    if (customers.isEmpty) {
      _showMessage('Please create at least one customer first');
      return;
    }

    if (products.isEmpty) {
      _showMessage('Please create at least one product first');
      return;
    }

    final invoice = await Navigator.of(context).push<InvoiceEntity>(
      MaterialPageRoute(
        builder: (_) =>
            InvoiceFormScreen(customers: customers, products: products),
      ),
    );

    if (invoice == null) return;

    await _invoiceLocalDataSource.insertInvoice(
      InvoiceModel(
        id: invoice.id,
        customerId: invoice.customerId,
        customerName: invoice.customerName,
        totalAmount: invoice.totalAmount,
        paidAmount: invoice.paidAmount,
        remainingAmount: invoice.remainingAmount,
        status: invoice.status,
        createdAt: invoice.createdAt,
        items: invoice.items.map(InvoiceItemModel.fromEntity).toList(),
      ),
    );

    await _loadInvoices();

    if (!mounted) return;
    _showMessage('Invoice created');
  }

  Future<void> _confirmDeleteInvoice(InvoiceEntity invoice) async {
    final ref = invoice.id.length > 6
        ? invoice.id.substring(invoice.id.length - 6)
        : invoice.id;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteInvoiceDialog(invoiceId: ref),
    );

    if (confirmed != true) return;

    await _invoiceLocalDataSource.deleteInvoice(invoice.id);
    await _loadInvoices();

    if (!mounted) return;
    _showMessage('Invoice deleted');
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

    final invoices = _filteredInvoices;
    final totalRevenue = _allInvoices.fold<double>(
      0,
      (sum, item) => sum + item.totalAmount,
    );

    return AppScaffold(
      title: 'Invoices',
      useLargeTitle: true,
      trailing: IconButton(
        onPressed: _loadInvoices,
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
                    hintText: 'Search invoices',
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
                          title: 'Total Invoices',
                          value: '${_allInvoices.length}',
                          subtitle: 'Saved locally',
                          icon: CupertinoIcons.doc_text_fill,
                          tone: AppStatCardTone.blue,
                          compact: true,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppStatCard(
                          title: 'Total Revenue',
                          value: '\$${totalRevenue.toStringAsFixed(0)}',
                          subtitle: 'All invoices total',
                          icon: CupertinoIcons.money_dollar_circle_fill,
                          tone: AppStatCardTone.green,
                          compact: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppPrimaryButton(
                    text: 'Create Invoice',
                    prefixIcon: const Icon(CupertinoIcons.add),
                    onPressed: _openCreateInvoiceDialog,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChipItem(
                          label: 'All',
                          isSelected: _selectedFilter == InvoiceListFilter.all,
                          onTap: () {
                            setState(() {
                              _selectedFilter = InvoiceListFilter.all;
                            });
                          },
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _FilterChipItem(
                          label: 'Outstanding',
                          isSelected:
                              _selectedFilter == InvoiceListFilter.outstanding,
                          onTap: () {
                            setState(() {
                              _selectedFilter = InvoiceListFilter.outstanding;
                            });
                          },
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _FilterChipItem(
                          label: 'Paid',
                          isSelected: _selectedFilter == InvoiceListFilter.paid,
                          onTap: () {
                            setState(() {
                              _selectedFilter = InvoiceListFilter.paid;
                            });
                          },
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _FilterChipItem(
                          label: 'Cancelled',
                          isSelected:
                              _selectedFilter == InvoiceListFilter.cancelled,
                          onTap: () {
                            setState(() {
                              _selectedFilter = InvoiceListFilter.cancelled;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.cardPadding),
                    decoration: BoxDecoration(
                      color: palette.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: palette.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _InvoicesSummaryItem(
                            title: 'Visible Invoices',
                            value: '${invoices.length}',
                          ),
                        ),
                        Container(width: 1, height: 42, color: palette.border),
                        Expanded(
                          child: _InvoicesSummaryItem(
                            title: 'Outstanding',
                            value:
                                '\$${_filteredOutstandingTotal.toStringAsFixed(2)}',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Text('All Invoices', style: textStyles.title3),
                      const Spacer(),
                      Text(
                        '${invoices.length} item${invoices.length == 1 ? '' : 's'}',
                        style: textStyles.footnote.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (invoices.isEmpty)
                    AppEmptyState(
                      icon: CupertinoIcons.doc_text,
                      title: 'No invoices found',
                      subtitle: _allInvoices.isEmpty
                          ? 'Create your first invoice to start tracking sales and payments.'
                          : 'No invoices match the current search or selected filters.',
                      actionLabel: _allInvoices.isEmpty
                          ? 'Create Invoice'
                          : null,
                      onActionTap: _allInvoices.isEmpty
                          ? _openCreateInvoiceDialog
                          : null,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.cardPadding,
                        vertical: AppSpacing.xl,
                      ),
                    )
                  else
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: invoices.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _gridCount(context),
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        childAspectRatio: _gridChildAspectRatio(context),
                      ),
                      itemBuilder: (context, index) {
                        final invoice = invoices[index];

                        return InvoiceCard(
                          invoice: invoice,
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    InvoiceDetailsScreen(invoice: invoice),
                              ),
                            );

                            await _loadInvoices();
                          },
                          onDelete: () => _confirmDeleteInvoice(invoice),
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

class _FilterChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? palette.primary : palette.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? palette.primary : palette.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? palette.textOnPrimary : palette.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _InvoicesSummaryItem extends StatelessWidget {
  final String title;
  final String value;

  const _InvoicesSummaryItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: palette.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
