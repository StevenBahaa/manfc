import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @dashboardOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get dashboardOverviewTitle;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your factory sales and collections'**
  String get dashboardSubtitle;

  /// No description provided for @dashboardCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get dashboardCustomers;

  /// No description provided for @dashboardProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get dashboardProducts;

  /// No description provided for @dashboardInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get dashboardInvoices;

  /// No description provided for @dashboardOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get dashboardOutstanding;

  /// No description provided for @dashboardCollectionsSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Collections Snapshot'**
  String get dashboardCollectionsSnapshot;

  /// No description provided for @dashboardRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get dashboardRevenue;

  /// No description provided for @dashboardCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get dashboardCollected;

  /// No description provided for @dashboardOpenInvoices.
  ///
  /// In en, this message translates to:
  /// **'Open Invoices'**
  String get dashboardOpenInvoices;

  /// No description provided for @dashboardQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashboardQuickActions;

  /// No description provided for @dashboardRecentInvoices.
  ///
  /// In en, this message translates to:
  /// **'Recent Invoices'**
  String get dashboardRecentInvoices;

  /// No description provided for @dashboardViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get dashboardViewAll;

  /// No description provided for @dashboardNoInvoicesTitle.
  ///
  /// In en, this message translates to:
  /// **'No invoices yet'**
  String get dashboardNoInvoicesTitle;

  /// No description provided for @dashboardNoInvoicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first invoice to start tracking sales and collections.'**
  String get dashboardNoInvoicesSubtitle;

  /// No description provided for @dashboardGoToInvoices.
  ///
  /// In en, this message translates to:
  /// **'Go to Invoices'**
  String get dashboardGoToInvoices;

  /// No description provided for @dashboardTopOutstandingCustomers.
  ///
  /// In en, this message translates to:
  /// **'Top Outstanding Customers'**
  String get dashboardTopOutstandingCustomers;

  /// No description provided for @dashboardNoOutstandingTitle.
  ///
  /// In en, this message translates to:
  /// **'No outstanding balances'**
  String get dashboardNoOutstandingTitle;

  /// No description provided for @dashboardNoOutstandingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Great job. All customers are fully settled right now.'**
  String get dashboardNoOutstandingSubtitle;

  /// No description provided for @invoiceStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get invoiceStatusPaid;

  /// No description provided for @invoiceStatusPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get invoiceStatusPartial;

  /// No description provided for @invoiceStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get invoiceStatusCancelled;

  /// No description provided for @invoiceStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get invoiceStatusDraft;

  /// No description provided for @invoiceStatusUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get invoiceStatusUnpaid;

  /// No description provided for @dashboardInvoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice #{ref}'**
  String dashboardInvoiceNumber(Object ref);

  /// No description provided for @dashboardRemainingAmount.
  ///
  /// In en, this message translates to:
  /// **'Remaining: \${amount}'**
  String dashboardRemainingAmount(Object amount);

  /// No description provided for @productsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsTitle;

  /// No description provided for @productsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get productsSearchHint;

  /// No description provided for @productsTotalProducts.
  ///
  /// In en, this message translates to:
  /// **'Total Products'**
  String get productsTotalProducts;

  /// No description provided for @productsSavedLocally.
  ///
  /// In en, this message translates to:
  /// **'Saved locally'**
  String get productsSavedLocally;

  /// No description provided for @productsAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get productsAddProduct;

  /// No description provided for @productsAllProducts.
  ///
  /// In en, this message translates to:
  /// **'All Products'**
  String get productsAllProducts;

  /// No description provided for @productsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get productsEmptyTitle;

  /// No description provided for @productsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first product to start building invoices and tracking stock.'**
  String get productsEmptySubtitle;

  /// No description provided for @productsItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 items} =1{1 item} other{{count} items}}'**
  String productsItemCount(int count);

  /// No description provided for @productCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} created'**
  String productCreatedMessage(Object name);

  /// No description provided for @productUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} updated'**
  String productUpdatedMessage(Object name);

  /// No description provided for @productDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String productDeletedMessage(Object name);

  /// No description provided for @productAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get productAddTitle;

  /// No description provided for @productEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get productEditTitle;

  /// No description provided for @productDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the product details below.'**
  String get productDialogSubtitle;

  /// No description provided for @productDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetailsTitle;

  /// No description provided for @productDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a fixed-price product for invoices and customer orders.'**
  String get productDetailsSubtitle;

  /// No description provided for @productNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productNameLabel;

  /// No description provided for @productNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter product name'**
  String get productNameHint;

  /// No description provided for @productPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get productPriceLabel;

  /// No description provided for @productPriceHint.
  ///
  /// In en, this message translates to:
  /// **'Enter fixed price'**
  String get productPriceHint;

  /// No description provided for @productUsageInfo.
  ///
  /// In en, this message translates to:
  /// **'This product will be available later in invoice creation and customer billing.'**
  String get productUsageInfo;

  /// No description provided for @productSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get productSaveChanges;

  /// No description provided for @productCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create Product'**
  String get productCreateButton;

  /// No description provided for @productNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Product name is required'**
  String get productNameRequired;

  /// No description provided for @productNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Product name is too short'**
  String get productNameTooShort;

  /// No description provided for @productPriceRequired.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get productPriceRequired;

  /// No description provided for @productPriceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price'**
  String get productPriceInvalid;

  /// No description provided for @productPricePositive.
  ///
  /// In en, this message translates to:
  /// **'Price must be greater than 0'**
  String get productPricePositive;

  /// No description provided for @deleteProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get deleteProductTitle;

  /// No description provided for @deleteProductMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This action cannot be undone.'**
  String deleteProductMessage(Object name);

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonCurrency.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get commonCurrency;

  /// No description provided for @commonHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get commonHome;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @productFixedPrice.
  ///
  /// In en, this message translates to:
  /// **'Fixed price'**
  String get productFixedPrice;

  /// No description provided for @customersAllCustomers.
  ///
  /// In en, this message translates to:
  /// **'All Customers'**
  String get customersAllCustomers;

  /// No description provided for @customersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search customers'**
  String get customersSearchHint;

  /// No description provided for @customerDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Details'**
  String get customerDetailsTitle;

  /// No description provided for @customerOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get customerOverview;

  /// No description provided for @customerLedger.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get customerLedger;

  /// No description provided for @customerNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No activity for this customer yet'**
  String get customerNoActivity;

  /// No description provided for @customerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerNameLabel;

  /// No description provided for @customerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter customer name'**
  String get customerNameHint;

  /// No description provided for @customerPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get customerPhoneLabel;

  /// No description provided for @customerPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get customerPhoneHint;

  /// No description provided for @deleteCustomerTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Customer'**
  String get deleteCustomerTitle;

  /// No description provided for @deleteCustomerMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This action cannot be undone.'**
  String deleteCustomerMessage(Object name);

  /// No description provided for @invoicesAllInvoices.
  ///
  /// In en, this message translates to:
  /// **'All Invoices'**
  String get invoicesAllInvoices;

  /// No description provided for @invoicesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search invoices'**
  String get invoicesSearchHint;

  /// No description provided for @invoiceUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Invoice updated'**
  String get invoiceUpdatedMessage;

  /// No description provided for @invoiceItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice Items'**
  String get invoiceItemsTitle;

  /// No description provided for @invoiceGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get invoiceGrandTotal;

  /// No description provided for @invoicePaymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get invoicePaymentHistory;

  /// No description provided for @invoiceFormItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get invoiceFormItems;

  /// No description provided for @invoiceFormAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get invoiceFormAddItem;

  /// No description provided for @invoiceFormTotal.
  ///
  /// In en, this message translates to:
  /// **'Invoice Total'**
  String get invoiceFormTotal;

  /// No description provided for @invoiceFormCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get invoiceFormCustomer;

  /// No description provided for @invoiceFormProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get invoiceFormProduct;

  /// No description provided for @invoiceFormQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get invoiceFormQuantity;

  /// No description provided for @paymentAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Payment'**
  String get paymentAddTitle;

  /// No description provided for @paymentMethodCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodCash;

  /// No description provided for @paymentMethodBankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get paymentMethodBankTransfer;

  /// No description provided for @paymentMethodCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paymentMethodCard;

  /// No description provided for @paymentMethodOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get paymentMethodOther;

  /// No description provided for @paymentAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get paymentAmountLabel;

  /// No description provided for @paymentAmountHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get paymentAmountHint;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethodLabel;

  /// No description provided for @paymentNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get paymentNoteLabel;

  /// No description provided for @paymentNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Optional note'**
  String get paymentNoteHint;

  /// No description provided for @paymentDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get paymentDateLabel;

  /// No description provided for @invoiceDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice Date'**
  String get invoiceDateLabel;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize your app appearance and language'**
  String get settingsSubtitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsLightMode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsLightMode;

  /// No description provided for @settingsLightModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Always use light mode'**
  String get settingsLightModeDesc;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsDarkMode;

  /// No description provided for @settingsDarkModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Always use dark mode'**
  String get settingsDarkModeDesc;

  /// No description provided for @settingsSystemMode.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsSystemMode;

  /// No description provided for @settingsSystemModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Follow device settings'**
  String get settingsSystemModeDesc;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageEnglishDesc.
  ///
  /// In en, this message translates to:
  /// **'App language in English'**
  String get settingsLanguageEnglishDesc;

  /// No description provided for @settingsLanguageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get settingsLanguageArabic;

  /// No description provided for @settingsLanguageArabicDesc.
  ///
  /// In en, this message translates to:
  /// **'لغة التطبيق بالعربية'**
  String get settingsLanguageArabicDesc;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Factory Sales App'**
  String get appTitle;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get commonTotal;

  /// No description provided for @commonPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get commonPaid;

  /// No description provided for @commonRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get commonRemaining;

  /// No description provided for @commonQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get commonQuantity;

  /// No description provided for @commonUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get commonUnitPrice;

  /// No description provided for @commonStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get commonStatus;

  /// No description provided for @commonCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get commonCustomer;

  /// No description provided for @commonDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get commonDate;

  /// No description provided for @commonNoNote.
  ///
  /// In en, this message translates to:
  /// **'No note'**
  String get commonNoNote;

  /// No description provided for @productDeleted.
  ///
  /// In en, this message translates to:
  /// **'Product deleted'**
  String get productDeleted;

  /// No description provided for @errorProductNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Product name is required'**
  String get errorProductNameRequired;

  /// No description provided for @errorProductNameShort.
  ///
  /// In en, this message translates to:
  /// **'Product name is too short'**
  String get errorProductNameShort;

  /// No description provided for @errorProductPriceRequired.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get errorProductPriceRequired;

  /// No description provided for @errorProductPriceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price'**
  String get errorProductPriceInvalid;

  /// No description provided for @errorProductPriceZero.
  ///
  /// In en, this message translates to:
  /// **'Price must be greater than 0'**
  String get errorProductPriceZero;

  /// No description provided for @errorInvalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid payment amount'**
  String get errorInvalidAmount;

  /// No description provided for @errorAmountExceedsRemaining.
  ///
  /// In en, this message translates to:
  /// **'Payment cannot be greater than remaining amount'**
  String get errorAmountExceedsRemaining;

  /// No description provided for @savePaymentBtn.
  ///
  /// In en, this message translates to:
  /// **'Save Payment'**
  String get savePaymentBtn;

  /// No description provided for @invoicesTotalTitle.
  ///
  /// In en, this message translates to:
  /// **'Total Invoices'**
  String get invoicesTotalTitle;

  /// No description provided for @invoicesTotalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saved locally'**
  String get invoicesTotalSubtitle;

  /// No description provided for @invoicesRevenueTitle.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get invoicesRevenueTitle;

  /// No description provided for @invoicesRevenueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All invoices total'**
  String get invoicesRevenueSubtitle;

  /// No description provided for @invoicesCreateBtn.
  ///
  /// In en, this message translates to:
  /// **'Create Invoice'**
  String get invoicesCreateBtn;

  /// No description provided for @invoicesVisibleTitle.
  ///
  /// In en, this message translates to:
  /// **'Visible Invoices'**
  String get invoicesVisibleTitle;

  /// No description provided for @invoicesOutstandingTitle.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get invoicesOutstandingTitle;

  /// No description provided for @invoicesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No invoices found'**
  String get invoicesEmptyTitle;

  /// No description provided for @errorSelectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Please select a customer'**
  String get errorSelectCustomer;

  /// No description provided for @errorAddInvoiceItem.
  ///
  /// In en, this message translates to:
  /// **'Add at least one valid invoice item'**
  String get errorAddInvoiceItem;

  /// No description provided for @invoiceDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice Details'**
  String get invoiceDetailsTitle;

  /// No description provided for @invoiceAddPaymentBtn.
  ///
  /// In en, this message translates to:
  /// **'Add Payment'**
  String get invoiceAddPaymentBtn;

  /// No description provided for @invoiceItemsCount.
  ///
  /// In en, this message translates to:
  /// **'Items Count'**
  String get invoiceItemsCount;

  /// No description provided for @invoiceLineTotal.
  ///
  /// In en, this message translates to:
  /// **'Line Total'**
  String get invoiceLineTotal;

  /// No description provided for @errorCreateCustomerFirst.
  ///
  /// In en, this message translates to:
  /// **'Please create at least one customer first'**
  String get errorCreateCustomerFirst;

  /// No description provided for @errorCreateProductFirst.
  ///
  /// In en, this message translates to:
  /// **'Please create at least one product first'**
  String get errorCreateProductFirst;

  /// No description provided for @invoiceCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Invoice created'**
  String get invoiceCreatedMessage;

  /// No description provided for @invoiceDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Invoice deleted'**
  String get invoiceDeletedMessage;

  /// No description provided for @customersTotalTitle.
  ///
  /// In en, this message translates to:
  /// **'Total Customers'**
  String get customersTotalTitle;

  /// No description provided for @customersTotalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saved locally'**
  String get customersTotalSubtitle;

  /// No description provided for @customersSearchableTitle.
  ///
  /// In en, this message translates to:
  /// **'Searchable'**
  String get customersSearchableTitle;

  /// No description provided for @customersSearchableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Name and phone'**
  String get customersSearchableSubtitle;

  /// No description provided for @customersAddBtn.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get customersAddBtn;

  /// No description provided for @customersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No customers yet'**
  String get customersEmptyTitle;

  /// No description provided for @customerStatsInvoiced.
  ///
  /// In en, this message translates to:
  /// **'Invoiced'**
  String get customerStatsInvoiced;

  /// No description provided for @customerStatsPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get customerStatsPaid;

  /// No description provided for @customerStatsOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get customerStatsOutstanding;

  /// No description provided for @customerLedgerInvoiceCreated.
  ///
  /// In en, this message translates to:
  /// **'Invoice #{ref} created'**
  String customerLedgerInvoiceCreated(String ref);

  /// No description provided for @customerLedgerInvoiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Added to customer balance'**
  String get customerLedgerInvoiceDesc;

  /// No description provided for @customerLedgerPaymentReceived.
  ///
  /// In en, this message translates to:
  /// **'Payment received'**
  String get customerLedgerPaymentReceived;

  /// No description provided for @customerDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Customer deleted'**
  String get customerDeletedMessage;

  /// No description provided for @customerSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Customer saved'**
  String get customerSavedMessage;

  /// No description provided for @invoicesEmptySubtitleNew.
  ///
  /// In en, this message translates to:
  /// **'Create your first invoice to start tracking sales and payments.'**
  String get invoicesEmptySubtitleNew;

  /// No description provided for @invoicesEmptySubtitleSearch.
  ///
  /// In en, this message translates to:
  /// **'No invoices match the current search or selected filters.'**
  String get invoicesEmptySubtitleSearch;

  /// No description provided for @invoiceFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get invoiceFilterAll;

  /// No description provided for @invoiceFilterOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get invoiceFilterOutstanding;

  /// No description provided for @invoiceFilterPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get invoiceFilterPaid;

  /// No description provided for @invoiceFilterCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get invoiceFilterCancelled;

  /// No description provided for @customersEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first customer to start creating invoices and tracking balances.'**
  String get customersEmptySubtitle;

  /// No description provided for @commonItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String commonItemsCount(int count);

  /// No description provided for @commonSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get commonSaveChanges;

  /// No description provided for @invoiceEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Invoice'**
  String get invoiceEditTitle;

  /// No description provided for @productCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Product'**
  String get productCreateTitle;

  /// No description provided for @invoiceRefTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice #{ref}'**
  String invoiceRefTitle(String ref);

  /// No description provided for @invoiceNoPaymentsYet.
  ///
  /// In en, this message translates to:
  /// **'No payments yet'**
  String get invoiceNoPaymentsYet;

  /// No description provided for @customerEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get customerEditTitle;

  /// No description provided for @customerCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Customer'**
  String get customerCreateTitle;

  /// No description provided for @customerAddDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter the customer details below.'**
  String get customerAddDesc;

  /// No description provided for @errorCustomerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Customer name is required'**
  String get errorCustomerNameRequired;

  /// No description provided for @errorCustomerNameShort.
  ///
  /// In en, this message translates to:
  /// **'Customer name is too short'**
  String get errorCustomerNameShort;

  /// No description provided for @errorCustomerPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get errorCustomerPhoneRequired;

  /// No description provided for @errorCustomerPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get errorCustomerPhoneInvalid;

  /// No description provided for @statusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get statusDraft;

  /// No description provided for @statusUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get statusUnpaid;

  /// No description provided for @statusPartiallyPaid.
  ///
  /// In en, this message translates to:
  /// **'Partially Paid'**
  String get statusPartiallyPaid;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get statusUnknown;

  /// No description provided for @deleteInvoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Invoice'**
  String get deleteInvoiceTitle;

  /// No description provided for @deleteInvoiceMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete invoice #{ref}? This action cannot be undone.'**
  String deleteInvoiceMessage(String ref);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
