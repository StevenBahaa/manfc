import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_responsive.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/app_scaffold.dart';
import '../../../customers/data/datasources/customer_local_datasource.dart';
import '../../../customers/domain/entities/customer_entity.dart';
import '../../../invoices/data/datasources/invoice_local_datasource.dart';
import '../../../invoices/domain/entities/invoice_entity.dart';
import '../../../invoices/presentation/screens/invoice_details_screen.dart';
import '../../../invoices/presentation/screens/invoices_list_screen.dart';
import '../../../payments/data/datasources/payment_local_data_source.dart';
import '../../../payments/domain/entities/payment_entity.dart';
import '../../../products/data/datasources/product_local_datasource.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../../app/widgets/app_empty_state.dart';
import '../../../../core/utils/currency_formatter.dart';
import 'package:manfc/l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  final void Function(int index) onNavigateToTab;

  const DashboardScreen({super.key, required this.onNavigateToTab});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final CustomerLocalDataSource _customerLocalDataSource =
      CustomerLocalDataSource();
  final ProductLocalDataSource _productLocalDataSource =
      ProductLocalDataSource();
  final InvoiceLocalDataSource _invoiceLocalDataSource =
      InvoiceLocalDataSource();
  final PaymentLocalDataSource _paymentLocalDataSource =
      PaymentLocalDataSource.instance;

  bool _isLoading = true;

  List<CustomerEntity> _customers = [];
  List<ProductEntity> _products = [];
  List<InvoiceEntity> _invoices = [];
  List<PaymentEntity> _payments = [];

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    setState(() => _isLoading = true);

    final customers = await _customerLocalDataSource.getAllCustomers();
    final products = await _productLocalDataSource.getAllProducts();
    final invoices = await _invoiceLocalDataSource.getAllInvoices();
    final payments = await _paymentLocalDataSource.getAllPayments();

    if (!mounted) return;

    setState(() {
      _customers = customers;
      _products = products;
      _invoices = invoices;
      _payments = payments;
      _isLoading = false;
    });
  }

  double get _totalRevenue {
    return _invoices.fold<double>(
      0,
      (sum, invoice) => sum + invoice.totalAmount,
    );
  }

  double get _totalOutstanding {
    return _invoices.fold<double>(
      0,
      (sum, invoice) => sum + invoice.remainingAmount,
    );
  }

  double get _totalCollected {
    return _payments.fold<double>(0, (sum, payment) => sum + payment.amount);
  }

  int get _openInvoicesCount {
    return _invoices.where((invoice) => invoice.remainingAmount > 0).length;
  }

  List<InvoiceEntity> get _recentInvoices {
    final list = [..._invoices];
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list.take(4).toList();
  }

  List<_CustomerOutstandingItem> get _topOutstandingCustomers {
    final Map<String, _CustomerOutstandingItem> grouped = {};

    for (final invoice in _invoices) {
      if (invoice.remainingAmount <= 0) continue;

      final current = grouped[invoice.customerId];
      if (current == null) {
        grouped[invoice.customerId] = _CustomerOutstandingItem(
          customerId: invoice.customerId,
          customerName: invoice.customerName,
          amount: invoice.remainingAmount,
        );
      } else {
        grouped[invoice.customerId] = _CustomerOutstandingItem(
          customerId: current.customerId,
          customerName: current.customerName,
          amount: current.amount + invoice.remainingAmount,
        );
      }
    }

    final result = grouped.values.toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return result.take(5).toList();
  }

  int _gridCount(BuildContext context) {
    if (AppResponsive.isExpanded(context)) return 4;
    if (AppResponsive.isMedium(context)) return 2;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final textStyles = AppTextStyles.create(
      primaryText: palette.textPrimary,
      secondaryText: palette.textSecondary,
      tertiaryText: palette.textTertiary,
      buttonText: palette.textOnPrimary,
    );

    return AppScaffold(
      title: l10n.dashboardOverviewTitle,
      useLargeTitle: true,
      trailing: IconButton(
        onPressed: loadDashboard,
        icon: Icon(CupertinoIcons.refresh, color: palette.iconPrimary),
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadDashboard,
              child: ListView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                children: [
                  Text(
                    l10n.dashboardSubtitle,
                    style: textStyles.body.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  GridView.count(
                    crossAxisCount: _gridCount(context),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: AppResponsive.isCompact(context)
                        ? 1.35
                        : 1.5,
                    children: [
                      _DashboardStatCard(
                        title: l10n.dashboardCustomers,
                        value: '${_customers.length}',
                        icon: CupertinoIcons.person_2_fill,
                      ),
                      _DashboardStatCard(
                        title: l10n.dashboardProducts,
                        value: '${_products.length}',
                        icon: CupertinoIcons.cube_box_fill,
                      ),
                      _DashboardStatCard(
                        title: l10n.dashboardInvoices,
                        value: '${_invoices.length}',
                        icon: CupertinoIcons.doc_text_fill,
                      ),
                      _DashboardStatCard(
                        title: l10n.dashboardOutstanding,
                        value: CurrencyFormatter.formatCompact(_totalOutstanding, l10n),
                        icon: CupertinoIcons.exclamationmark_circle_fill,
                        highlight: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    l10n.dashboardCollectionsSnapshot,
                    style: textStyles.title3,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.cardPadding),
                    decoration: BoxDecoration(
                      color: palette.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: palette.border),
                    ),
                    child: Column(
                      children: [
                        _SnapshotRow(
                          label: l10n.dashboardRevenue,
                          value: CurrencyFormatter.format(_totalRevenue, l10n),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _SnapshotRow(
                          label: l10n.dashboardCollected,
                          value: CurrencyFormatter.format(_totalCollected, l10n),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _SnapshotRow(
                          label: l10n.dashboardOutstanding,
                          value: CurrencyFormatter.format(_totalOutstanding, l10n),
                          emphasize: true,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _SnapshotRow(
                          label: l10n.dashboardOpenInvoices,
                          value: '$_openInvoicesCount',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(l10n.dashboardQuickActions, style: textStyles.title3),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      _QuickActionCard(
                        title: l10n.dashboardCustomers,
                        icon: CupertinoIcons.person_add_solid,
                        width: AppResponsive.isCompact(context)
                            ? (MediaQuery.of(context).size.width -
                                      (AppSpacing.lg * 2) -
                                      AppSpacing.md) /
                                  2
                            : 180,
                        onTap: () => widget.onNavigateToTab(2),
                      ),
                      _QuickActionCard(
                        title: l10n.dashboardProducts,
                        icon: CupertinoIcons.cube_box,
                        width: AppResponsive.isCompact(context)
                            ? (MediaQuery.of(context).size.width -
                                      (AppSpacing.lg * 2) -
                                      AppSpacing.md) /
                                  2
                            : 180,
                        onTap: () => widget.onNavigateToTab(1),
                      ),
                      _QuickActionCard(
                        title: l10n.dashboardInvoices,
                        icon: CupertinoIcons.doc_text,
                        width: AppResponsive.isCompact(context)
                            ? (MediaQuery.of(context).size.width -
                                      (AppSpacing.lg * 2) -
                                      AppSpacing.md) /
                                  2
                            : 180,
                        onTap: () => widget.onNavigateToTab(3),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Text(
                        l10n.dashboardRecentInvoices,
                        style: textStyles.title3,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const InvoicesListScreen(),
                            ),
                          );
                        },
                        child: Text(l10n.dashboardViewAll),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_recentInvoices.isEmpty)
                    AppEmptyState(
                      icon: CupertinoIcons.doc_text,
                      title: l10n.dashboardNoInvoicesTitle,
                      subtitle: l10n.dashboardNoInvoicesSubtitle,
                      actionLabel: l10n.dashboardGoToInvoices,
                      onActionTap: () => widget.onNavigateToTab(3),
                    )
                  else
                    ..._recentInvoices.map(
                      (invoice) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: _RecentInvoiceCard(
                          invoice: invoice,
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    InvoiceDetailsScreen(invoice: invoice),
                              ),
                            );
                            await loadDashboard();
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    l10n.dashboardTopOutstandingCustomers,
                    style: textStyles.title3,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_topOutstandingCustomers.isEmpty)
                    AppEmptyState(
                      icon: CupertinoIcons.check_mark_circled_solid,
                      title: l10n.dashboardNoOutstandingTitle,
                      subtitle: l10n.dashboardNoOutstandingSubtitle,
                    )
                  else
                    ..._topOutstandingCustomers.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: _OutstandingCustomerCard(item: item),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
    );
  }
}

class _CustomerOutstandingItem {
  final String customerId;
  final String customerName;
  final double amount;

  const _CustomerOutstandingItem({
    required this.customerId,
    required this.customerName,
    required this.amount,
  });
}

class _DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool highlight;

  const _DashboardStatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final bgColor = highlight ? palette.cardBlueSoft : palette.surface;
    final borderColor = highlight ? palette.primary : palette.border;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: palette.primary, size: 22),
          const Spacer(),
          Text(
            title,
            style: TextStyle(color: palette.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SnapshotRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;

  const _SnapshotRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: palette.textSecondary, fontSize: 14),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: emphasize ? palette.primary : palette.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final double width;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: palette.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: palette.primary, size: 24),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentInvoiceCard extends StatelessWidget {
  final InvoiceEntity invoice;
  final VoidCallback onTap;

  const _RecentInvoiceCard({required this.invoice, required this.onTap});

  String _statusLabel(AppLocalizations l10n) {
    switch (invoice.status) {
      case 'paid':
        return l10n.invoiceStatusPaid;
      case 'partially_paid':
        return l10n.invoiceStatusPartial;
      case 'cancelled':
        return l10n.invoiceStatusCancelled;
      case 'draft':
        return l10n.invoiceStatusDraft;
      case 'unpaid':
      default:
        return l10n.invoiceStatusUnpaid;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final ref = invoice.id.length >= 6
        ? invoice.id.substring(invoice.id.length - 6)
        : invoice.id;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 8,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Text(
                    invoice.customerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  CurrencyFormatter.format(invoice.totalAmount, l10n),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.dashboardInvoiceNumber(ref),
                    style: TextStyle(
                      color: palette.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  _statusLabel(l10n),
                  style: TextStyle(
                    color: palette.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.dashboardRemainingAmount(
                CurrencyFormatter.format(invoice.remainingAmount, l10n),
              ),
              style: TextStyle(color: palette.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutstandingCustomerCard extends StatelessWidget {
  final _CustomerOutstandingItem item;

  const _OutstandingCustomerCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: palette.cardBlueSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              CupertinoIcons.person_fill,
              color: palette.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              item.customerName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: palette.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            CurrencyFormatter.format(item.amount, l10n),
            style: TextStyle(
              color: palette.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
