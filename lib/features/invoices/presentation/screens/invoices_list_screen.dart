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
import '../../../../core/utils/currency_formatter.dart';
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
import 'package:manfc/l10n/app_localizations.dart';

enum InvoiceListFilter { all, outstanding, paid, cancelled }

class InvoicesListScreen extends StatefulWidget {
  const InvoicesListScreen({super.key});

  @override
  State<InvoicesListScreen> createState() => InvoicesListScreenState();
}

class InvoicesListScreenState extends State<InvoicesListScreen> {
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
    loadInvoices();
  }

  Future<void> loadInvoices() async {
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

    final l10n = AppLocalizations.of(context)!;
    if (customers.isEmpty) {
      _showMessage(l10n.errorCreateCustomerFirst);
      return;
    }

    if (products.isEmpty) {
      _showMessage(l10n.errorCreateProductFirst);
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

    await loadInvoices();

    if (!mounted) return;
    _showMessage(l10n.invoiceCreatedMessage);
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
    await loadInvoices();

    if (!mounted) return;
    _showMessage(AppLocalizations.of(context)!.invoiceDeletedMessage);
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

    final l10n = AppLocalizations.of(context)!;
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
      title: AppLocalizations.of(context)!.dashboardInvoices,
      useLargeTitle: true,
      trailing: IconButton(
        onPressed: loadInvoices,
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
                    hintText: l10n.invoicesSearchHint,
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
                          title: l10n.invoicesTotalTitle,
                          value: '${_allInvoices.length}',
                          subtitle: l10n.invoicesTotalSubtitle,
                          icon: CupertinoIcons.doc_text_fill,
                          tone: AppStatCardTone.blue,
                          compact: true,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppStatCard(
                          title: l10n.invoicesRevenueTitle,
                          value: CurrencyFormatter.formatCompact(totalRevenue, l10n),
                          subtitle: l10n.invoicesRevenueSubtitle,
                          icon: CupertinoIcons.money_dollar_circle_fill,
                          tone: AppStatCardTone.green,
                          compact: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppPrimaryButton(
                    text: l10n.invoicesCreateBtn,
                    prefixIcon: const Icon(CupertinoIcons.add),
                    onPressed: _openCreateInvoiceDialog,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChipItem(
                          label: l10n.invoiceFilterAll,
                          isSelected: _selectedFilter == InvoiceListFilter.all,
                          onTap: () {
                            setState(() {
                              _selectedFilter = InvoiceListFilter.all;
                            });
                          },
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _FilterChipItem(
                          label: l10n.invoiceFilterOutstanding,
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
                          label: l10n.invoiceFilterPaid,
                          isSelected: _selectedFilter == InvoiceListFilter.paid,
                          onTap: () {
                            setState(() {
                              _selectedFilter = InvoiceListFilter.paid;
                            });
                          },
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _FilterChipItem(
                          label: l10n.invoiceFilterCancelled,
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
                            title: l10n.invoicesVisibleTitle,
                            value: '${invoices.length}',
                          ),
                        ),
                        Container(width: 1, height: 42, color: palette.border),
                        Expanded(
                          child: _InvoicesSummaryItem(
                            title: l10n.invoicesOutstandingTitle,
                            value: CurrencyFormatter.format(_filteredOutstandingTotal, l10n),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context)!.invoicesAllInvoices, style: textStyles.title3),
                      const Spacer(),
                      Text(
                        l10n.commonItemsCount(invoices.length),
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
                      title: l10n.invoicesEmptyTitle,
                      subtitle: _allInvoices.isEmpty
                          ? l10n.invoicesEmptySubtitleNew
                          : l10n.invoicesEmptySubtitleSearch,
                      actionLabel: _allInvoices.isEmpty
                          ? l10n.invoicesCreateBtn
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

                            await loadInvoices();
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
