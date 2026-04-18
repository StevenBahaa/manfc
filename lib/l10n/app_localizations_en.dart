// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboardOverviewTitle => 'Overview';

  @override
  String get dashboardSubtitle => 'Track your factory sales and collections';

  @override
  String get dashboardCustomers => 'Customers';

  @override
  String get dashboardProducts => 'Products';

  @override
  String get dashboardInvoices => 'Invoices';

  @override
  String get dashboardOutstanding => 'Outstanding';

  @override
  String get dashboardCollectionsSnapshot => 'Collections Snapshot';

  @override
  String get dashboardRevenue => 'Revenue';

  @override
  String get dashboardCollected => 'Collected';

  @override
  String get dashboardOpenInvoices => 'Open Invoices';

  @override
  String get dashboardQuickActions => 'Quick Actions';

  @override
  String get dashboardRecentInvoices => 'Recent Invoices';

  @override
  String get dashboardViewAll => 'View All';

  @override
  String get dashboardNoInvoicesTitle => 'No invoices yet';

  @override
  String get dashboardNoInvoicesSubtitle => 'Create your first invoice to start tracking sales and collections.';

  @override
  String get dashboardGoToInvoices => 'Go to Invoices';

  @override
  String get dashboardTopOutstandingCustomers => 'Top Outstanding Customers';

  @override
  String get dashboardNoOutstandingTitle => 'No outstanding balances';

  @override
  String get dashboardNoOutstandingSubtitle => 'Great job. All customers are fully settled right now.';

  @override
  String get invoiceStatusPaid => 'Paid';

  @override
  String get invoiceStatusPartial => 'Partial';

  @override
  String get invoiceStatusCancelled => 'Cancelled';

  @override
  String get invoiceStatusDraft => 'Draft';

  @override
  String get invoiceStatusUnpaid => 'Unpaid';

  @override
  String dashboardInvoiceNumber(Object ref) {
    return 'Invoice #$ref';
  }

  @override
  String dashboardRemainingAmount(Object amount) {
    return 'Remaining: \$$amount';
  }

  @override
  String get productsTitle => 'Products';

  @override
  String get productsSearchHint => 'Search products';

  @override
  String get productsTotalProducts => 'Total Products';

  @override
  String get productsSavedLocally => 'Saved locally';

  @override
  String get productsAddProduct => 'Add Product';

  @override
  String get productsAllProducts => 'All Products';

  @override
  String get productsEmptyTitle => 'No products yet';

  @override
  String get productsEmptySubtitle => 'Add your first product to start building invoices and tracking stock.';

  @override
  String productsItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: '0 items',
    );
    return '$_temp0';
  }

  @override
  String productCreatedMessage(Object name) {
    return '$name created';
  }

  @override
  String productUpdatedMessage(Object name) {
    return '$name updated';
  }

  @override
  String productDeletedMessage(Object name) {
    return '$name deleted';
  }

  @override
  String get productAddTitle => 'Add Product';

  @override
  String get productEditTitle => 'Edit Product';

  @override
  String get productDialogSubtitle => 'Enter the product details below.';

  @override
  String get productDetailsTitle => 'Product Details';

  @override
  String get productDetailsSubtitle => 'Add a fixed-price product for invoices and customer orders.';

  @override
  String get productNameLabel => 'Product Name';

  @override
  String get productNameHint => 'Enter product name';

  @override
  String get productPriceLabel => 'Price';

  @override
  String get productPriceHint => 'Enter fixed price';

  @override
  String get productUsageInfo => 'This product will be available later in invoice creation and customer billing.';

  @override
  String get productSaveChanges => 'Save Changes';

  @override
  String get productCreateButton => 'Create Product';

  @override
  String get productNameRequired => 'Product name is required';

  @override
  String get productNameTooShort => 'Product name is too short';

  @override
  String get productPriceRequired => 'Price is required';

  @override
  String get productPriceInvalid => 'Enter a valid price';

  @override
  String get productPricePositive => 'Price must be greater than 0';

  @override
  String get deleteProductTitle => 'Delete Product';

  @override
  String deleteProductMessage(Object name) {
    return 'Are you sure you want to delete \"$name\"? This action cannot be undone.';
  }

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get productFixedPrice => 'Fixed price';
}
