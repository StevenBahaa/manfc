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
  String get commonCurrency => '\$';

  @override
  String get commonHome => 'Home';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get productFixedPrice => 'Fixed price';

  @override
  String get customersAllCustomers => 'All Customers';

  @override
  String get customersSearchHint => 'Search customers';

  @override
  String get customerDetailsTitle => 'Customer Details';

  @override
  String get customerOverview => 'Overview';

  @override
  String get customerLedger => 'Ledger';

  @override
  String get customerNoActivity => 'No activity for this customer yet';

  @override
  String get customerNameLabel => 'Customer Name';

  @override
  String get customerNameHint => 'Enter customer name';

  @override
  String get customerPhoneLabel => 'Phone Number';

  @override
  String get customerPhoneHint => 'Enter phone number';

  @override
  String get deleteCustomerTitle => 'Delete Customer';

  @override
  String deleteCustomerMessage(Object name) {
    return 'Are you sure you want to delete \"$name\"? This action cannot be undone.';
  }

  @override
  String get invoicesAllInvoices => 'All Invoices';

  @override
  String get invoicesSearchHint => 'Search invoices';

  @override
  String get invoiceUpdatedMessage => 'Invoice updated';

  @override
  String get invoiceItemsTitle => 'Invoice Items';

  @override
  String get invoiceGrandTotal => 'Grand Total';

  @override
  String get invoicePaymentHistory => 'Payment History';

  @override
  String get invoiceFormItems => 'Items';

  @override
  String get invoiceFormAddItem => 'Add Item';

  @override
  String get invoiceFormTotal => 'Invoice Total';

  @override
  String get invoiceFormCustomer => 'Customer';

  @override
  String get invoiceFormProduct => 'Product';

  @override
  String get invoiceFormQuantity => 'Quantity';

  @override
  String get paymentAddTitle => 'Add Payment';

  @override
  String get paymentMethodCash => 'Cash';

  @override
  String get paymentMethodBankTransfer => 'Bank Transfer';

  @override
  String get paymentMethodCard => 'Card';

  @override
  String get paymentMethodOther => 'Other';

  @override
  String get paymentAmountLabel => 'Amount';

  @override
  String get paymentAmountHint => '0.00';

  @override
  String get paymentMethodLabel => 'Payment Method';

  @override
  String get paymentNoteLabel => 'Note';

  @override
  String get paymentNoteHint => 'Optional note';

  @override
  String get paymentDateLabel => 'Payment Date';

  @override
  String get invoiceDateLabel => 'Invoice Date';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Customize your app appearance and language';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLightMode => 'Light';

  @override
  String get settingsLightModeDesc => 'Always use light mode';

  @override
  String get settingsDarkMode => 'Dark';

  @override
  String get settingsDarkModeDesc => 'Always use dark mode';

  @override
  String get settingsSystemMode => 'System';

  @override
  String get settingsSystemModeDesc => 'Follow device settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageEnglishDesc => 'App language in English';

  @override
  String get settingsLanguageArabic => 'العربية';

  @override
  String get settingsLanguageArabicDesc => 'لغة التطبيق بالعربية';

  @override
  String get appTitle => 'Factory Sales App';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonTotal => 'Total';

  @override
  String get commonPaid => 'Paid';

  @override
  String get commonRemaining => 'Remaining';

  @override
  String get commonQuantity => 'Quantity';

  @override
  String get commonUnitPrice => 'Unit Price';

  @override
  String get commonStatus => 'Status';

  @override
  String get commonCustomer => 'Customer';

  @override
  String get commonDate => 'Date';

  @override
  String get commonNoNote => 'No note';

  @override
  String get productDeleted => 'Product deleted';

  @override
  String get errorProductNameRequired => 'Product name is required';

  @override
  String get errorProductNameShort => 'Product name is too short';

  @override
  String get errorProductPriceRequired => 'Price is required';

  @override
  String get errorProductPriceInvalid => 'Enter a valid price';

  @override
  String get errorProductPriceZero => 'Price must be greater than 0';

  @override
  String get errorInvalidAmount => 'Enter a valid payment amount';

  @override
  String get errorAmountExceedsRemaining => 'Payment cannot be greater than remaining amount';

  @override
  String get savePaymentBtn => 'Save Payment';

  @override
  String get invoicesTotalTitle => 'Total Invoices';

  @override
  String get invoicesTotalSubtitle => 'Saved locally';

  @override
  String get invoicesRevenueTitle => 'Total Revenue';

  @override
  String get invoicesRevenueSubtitle => 'All invoices total';

  @override
  String get invoicesCreateBtn => 'Create Invoice';

  @override
  String get invoicesVisibleTitle => 'Visible Invoices';

  @override
  String get invoicesOutstandingTitle => 'Outstanding';

  @override
  String get invoicesEmptyTitle => 'No invoices found';

  @override
  String get errorSelectCustomer => 'Please select a customer';

  @override
  String get errorAddInvoiceItem => 'Add at least one valid invoice item';

  @override
  String get invoiceDetailsTitle => 'Invoice Details';

  @override
  String get invoiceAddPaymentBtn => 'Add Payment';

  @override
  String get invoiceItemsCount => 'Items Count';

  @override
  String get invoiceLineTotal => 'Line Total';

  @override
  String get errorCreateCustomerFirst => 'Please create at least one customer first';

  @override
  String get errorCreateProductFirst => 'Please create at least one product first';

  @override
  String get invoiceCreatedMessage => 'Invoice created';

  @override
  String get invoiceDeletedMessage => 'Invoice deleted';

  @override
  String get customersTotalTitle => 'Total Customers';

  @override
  String get customersTotalSubtitle => 'Saved locally';

  @override
  String get customersSearchableTitle => 'Searchable';

  @override
  String get customersSearchableSubtitle => 'Name and phone';

  @override
  String get customersAddBtn => 'Add Customer';

  @override
  String get customersEmptyTitle => 'No customers yet';

  @override
  String get customerStatsInvoiced => 'Invoiced';

  @override
  String get customerStatsPaid => 'Paid';

  @override
  String get customerStatsOutstanding => 'Outstanding';

  @override
  String customerLedgerInvoiceCreated(String ref) {
    return 'Invoice #$ref created';
  }

  @override
  String get customerLedgerInvoiceDesc => 'Added to customer balance';

  @override
  String get customerLedgerPaymentReceived => 'Payment received';

  @override
  String get customerDeletedMessage => 'Customer deleted';

  @override
  String get customerSavedMessage => 'Customer saved';

  @override
  String get invoicesEmptySubtitleNew => 'Create your first invoice to start tracking sales and payments.';

  @override
  String get invoicesEmptySubtitleSearch => 'No invoices match the current search or selected filters.';

  @override
  String get invoiceFilterAll => 'All';

  @override
  String get invoiceFilterOutstanding => 'Outstanding';

  @override
  String get invoiceFilterPaid => 'Paid';

  @override
  String get invoiceFilterCancelled => 'Cancelled';

  @override
  String get customersEmptySubtitle => 'Add your first customer to start creating invoices and tracking balances.';

  @override
  String commonItemsCount(int count) {
    return '$count items';
  }

  @override
  String get commonSaveChanges => 'Save Changes';

  @override
  String get invoiceEditTitle => 'Edit Invoice';

  @override
  String get productCreateTitle => 'Create Product';

  @override
  String invoiceRefTitle(String ref) {
    return 'Invoice #$ref';
  }

  @override
  String get invoiceNoPaymentsYet => 'No payments yet';

  @override
  String get customerEditTitle => 'Edit Customer';

  @override
  String get customerCreateTitle => 'Create Customer';

  @override
  String get customerAddDesc => 'Enter the customer details below.';

  @override
  String get errorCustomerNameRequired => 'Customer name is required';

  @override
  String get errorCustomerNameShort => 'Customer name is too short';

  @override
  String get errorCustomerPhoneRequired => 'Phone number is required';

  @override
  String get errorCustomerPhoneInvalid => 'Enter a valid phone number';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusUnpaid => 'Unpaid';

  @override
  String get statusPartiallyPaid => 'Partially Paid';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusUnknown => 'Unknown';

  @override
  String get deleteInvoiceTitle => 'Delete Invoice';

  @override
  String deleteInvoiceMessage(String ref) {
    return 'Are you sure you want to delete invoice #$ref? This action cannot be undone.';
  }
}
