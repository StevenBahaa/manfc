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
import '../../data/datasources/product_local_datasource.dart';
import '../../data/models/product_model.dart';
import '../../domain/entities/product_entity.dart';
import '../widgets/add_edit_product_dialog.dart';
import '../widgets/delete_product_dialog.dart';
import '../widgets/product_card.dart';
import 'package:manfc/l10n/app_localizations.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductLocalDataSource _localDataSource = ProductLocalDataSource();

  List<ProductEntity> _allProducts = [];
  bool _isLoading = true;
  String _query = '';

  List<ProductEntity> get _filteredProducts {
    if (_query.trim().isEmpty) return _allProducts;

    final q = _query.toLowerCase().trim();
    return _allProducts
        .where((product) => product.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);

    final products = await _localDataSource.getAllProducts();

    if (!mounted) return;

    setState(() {
      _allProducts = products;
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
    if (AppResponsive.isExpanded(context)) return 1.45;
    if (AppResponsive.isMedium(context)) return 1.35;
    return 1.9;
  }

  Future<void> _openAddProductDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<ProductEntity>(
      context: context,
      builder: (_) => const AddEditProductDialog(),
    );

    if (result == null) return;

    await _localDataSource.insertProduct(ProductModel.fromEntity(result));

    await _loadProducts();

    if (!mounted) return;
    _showMessage(l10n.productCreatedMessage(result.name));
  }

  Future<void> _openEditProductDialog(ProductEntity product) async {
    final l10n = AppLocalizations.of(context)!;
    final updated = await showDialog<ProductEntity>(
      context: context,
      builder: (_) => AddEditProductDialog(product: product),
    );

    if (updated == null) return;

    await _localDataSource.updateProduct(ProductModel.fromEntity(updated));

    await _loadProducts();

    if (!mounted) return;
    _showMessage(l10n.productUpdatedMessage(updated.name));
  }

  Future<void> _confirmDeleteProduct(ProductEntity product) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteProductDialog(productName: product.name),
    );

    if (confirmed != true) return;

    await _localDataSource.deleteProduct(product.id);

    await _loadProducts();

    if (!mounted) return;
    _showMessage(l10n.productUpdatedMessage(product.name));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

    final products = _filteredProducts;
    final totalProducts = _allProducts.length;

    final averagePrice = _allProducts.isEmpty
        ? 0.0
        : _allProducts.map((e) => e.price).reduce((a, b) => a + b) /
              _allProducts.length;

    return AppScaffold(
      title: l10n.productsTitle,
      useLargeTitle: true,
      trailing: IconButton(
        onPressed: _loadProducts,
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
                    hintText: l10n.productsSearchHint,
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
                          title: l10n.productsTotalProducts,
                          value: '${products.length}',
                          subtitle: l10n.productsSavedLocally,
                          icon: CupertinoIcons.cube_box_fill,
                          tone: AppStatCardTone.blue,
                          compact: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppPrimaryButton(
                    text: l10n.productsAddProduct,
                    prefixIcon: const Icon(CupertinoIcons.add),
                    onPressed: _openAddProductDialog,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Text(l10n.productsAllProducts, style: textStyles.title3),
                      const Spacer(),
                      Text(
                        l10n.productsItemCount(products.length),
                        style: textStyles.footnote.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (products.isEmpty)
                    AppEmptyState(
                      icon: CupertinoIcons.cube_box,
                      title: l10n.productsEmptyTitle,
                      subtitle: l10n.productsEmptySubtitle,
                      actionLabel: l10n.productsAddProduct,
                      onActionTap: _openAddProductDialog,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.cardPadding,
                        vertical: AppSpacing.xl,
                      ),
                    )
                  else
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _gridCount(context),
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        childAspectRatio: _gridChildAspectRatio(context),
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return ProductCard(
                          product: product,
                          onTap: () {
                            // existing product details navigation if you have it
                          },
                          onEdit: () => _openEditProductDialog(product),
                          onDelete: () => _confirmDeleteProduct(product),
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
