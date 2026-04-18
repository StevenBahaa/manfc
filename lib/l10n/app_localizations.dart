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
