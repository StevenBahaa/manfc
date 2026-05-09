// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get dashboardOverviewTitle => 'نظرة عامة';

  @override
  String get dashboardSubtitle => 'تابع مبيعات المصنع والتحصيلات';

  @override
  String get dashboardCustomers => 'العملاء';

  @override
  String get dashboardProducts => 'المنتجات';

  @override
  String get dashboardInvoices => 'الفواتير';

  @override
  String get dashboardOutstanding => 'المستحق';

  @override
  String get dashboardCollectionsSnapshot => 'ملخص التحصيلات';

  @override
  String get dashboardRevenue => 'الإيراد';

  @override
  String get dashboardCollected => 'تم تحصيله';

  @override
  String get dashboardOpenInvoices => 'الفواتير المفتوحة';

  @override
  String get dashboardQuickActions => 'إجراءات سريعة';

  @override
  String get dashboardRecentInvoices => 'أحدث الفواتير';

  @override
  String get dashboardViewAll => 'عرض الكل';

  @override
  String get dashboardNoInvoicesTitle => 'لا توجد فواتير بعد';

  @override
  String get dashboardNoInvoicesSubtitle => 'أنشئ أول فاتورة لبدء متابعة المبيعات والتحصيلات.';

  @override
  String get dashboardGoToInvoices => 'اذهب إلى الفواتير';

  @override
  String get dashboardTopOutstandingCustomers => 'أعلى العملاء المستحق عليهم';

  @override
  String get dashboardNoOutstandingTitle => 'لا توجد أرصدة مستحقة';

  @override
  String get dashboardNoOutstandingSubtitle => 'عمل رائع، جميع العملاء قاموا بالسداد بالكامل حالياً.';

  @override
  String get invoiceStatusPaid => 'مدفوعة';

  @override
  String get invoiceStatusPartial => 'مدفوعة جزئياً';

  @override
  String get invoiceStatusCancelled => 'ملغاة';

  @override
  String get invoiceStatusDraft => 'مسودة';

  @override
  String get invoiceStatusUnpaid => 'غير مدفوعة';

  @override
  String dashboardInvoiceNumber(Object ref) {
    return 'فاتورة #$ref';
  }

  @override
  String dashboardRemainingAmount(Object amount) {
    return 'المتبقي: \$$amount';
  }

  @override
  String get productsTitle => 'المنتجات';

  @override
  String get productsSearchHint => 'ابحث عن المنتجات';

  @override
  String get productsTotalProducts => 'إجمالي المنتجات';

  @override
  String get productsSavedLocally => 'محفوظة محليًا';

  @override
  String get productsAddProduct => 'إضافة منتج';

  @override
  String get productsAllProducts => 'كل المنتجات';

  @override
  String get productsEmptyTitle => 'لا توجد منتجات بعد';

  @override
  String get productsEmptySubtitle => 'أضف أول منتج لبدء إنشاء الفواتير ومتابعة المخزون.';

  @override
  String productsItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر',
      many: '$count عنصرًا',
      few: '$count عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
      zero: '0 عنصر',
    );
    return '$_temp0';
  }

  @override
  String productCreatedMessage(Object name) {
    return 'تم إنشاء $name';
  }

  @override
  String productUpdatedMessage(Object name) {
    return 'تم تحديث $name';
  }

  @override
  String productDeletedMessage(Object name) {
    return 'تم حذف $name';
  }

  @override
  String get productAddTitle => 'إضافة منتج';

  @override
  String get productEditTitle => 'تعديل المنتج';

  @override
  String get productDialogSubtitle => 'أدخل تفاصيل المنتج بالأسفل.';

  @override
  String get productDetailsTitle => 'تفاصيل المنتج';

  @override
  String get productDetailsSubtitle => 'أضف منتجًا بسعر ثابت لاستخدامه في الفواتير وطلبات العملاء.';

  @override
  String get productNameLabel => 'اسم المنتج';

  @override
  String get productNameHint => 'أدخل اسم المنتج';

  @override
  String get productPriceLabel => 'السعر';

  @override
  String get productPriceHint => 'أدخل السعر الثابت';

  @override
  String get productUsageInfo => 'سيكون هذا المنتج متاحًا لاحقًا أثناء إنشاء الفواتير وفوترة العملاء.';

  @override
  String get productSaveChanges => 'حفظ التغييرات';

  @override
  String get productCreateButton => 'إنشاء المنتج';

  @override
  String get productNameRequired => 'اسم المنتج مطلوب';

  @override
  String get productNameTooShort => 'اسم المنتج قصير جدًا';

  @override
  String get productPriceRequired => 'السعر مطلوب';

  @override
  String get productPriceInvalid => 'أدخل سعرًا صحيحًا';

  @override
  String get productPricePositive => 'يجب أن يكون السعر أكبر من 0';

  @override
  String get deleteProductTitle => 'حذف المنتج';

  @override
  String deleteProductMessage(Object name) {
    return 'هل أنت متأكد أنك تريد حذف \"$name\"؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonCurrency => 'ج.م';

  @override
  String get commonHome => 'الرئيسية';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonEdit => 'تعديل';

  @override
  String get productFixedPrice => 'سعر ثابت';

  @override
  String get customersAllCustomers => 'جميع العملاء';

  @override
  String get customersSearchHint => 'ابحث عن العملاء';

  @override
  String get customerDetailsTitle => 'تفاصيل العميل';

  @override
  String get customerOverview => 'نظرة عامة';

  @override
  String get customerLedger => 'كشف الحساب';

  @override
  String get customerNoActivity => 'لا يوجد نشاط لهذا العميل بعد';

  @override
  String get customerNameLabel => 'اسم العميل';

  @override
  String get customerNameHint => 'أدخل اسم العميل';

  @override
  String get customerPhoneLabel => 'رقم الهاتف';

  @override
  String get customerPhoneHint => 'أدخل رقم الهاتف';

  @override
  String get deleteCustomerTitle => 'حذف العميل';

  @override
  String deleteCustomerMessage(Object name) {
    return 'هل أنت متأكد أنك تريد حذف \"$name\"؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get invoicesAllInvoices => 'جميع الفواتير';

  @override
  String get invoicesSearchHint => 'ابحث عن الفواتير';

  @override
  String get invoiceUpdatedMessage => 'تم تحديث الفاتورة';

  @override
  String get invoiceItemsTitle => 'عناصر الفاتورة';

  @override
  String get invoiceGrandTotal => 'المبلغ الإجمالي';

  @override
  String get invoicePaymentHistory => 'سجل المدفوعات';

  @override
  String get invoiceFormItems => 'العناصر';

  @override
  String get invoiceFormAddItem => 'إضافة عنصر';

  @override
  String get invoiceFormTotal => 'إجمالي الفاتورة';

  @override
  String get invoiceFormCustomer => 'العميل';

  @override
  String get invoiceFormProduct => 'المنتج';

  @override
  String get invoiceFormQuantity => 'الكمية';

  @override
  String get paymentAddTitle => 'إضافة دفعة';

  @override
  String get paymentMethodCash => 'نقدي';

  @override
  String get paymentMethodBankTransfer => 'تحويل بنكي';

  @override
  String get paymentMethodCard => 'بطاقة';

  @override
  String get paymentMethodOther => 'أخرى';

  @override
  String get paymentAmountLabel => 'المبلغ';

  @override
  String get paymentAmountHint => '0.00';

  @override
  String get paymentMethodLabel => 'طريقة الدفع';

  @override
  String get paymentNoteLabel => 'ملاحظة';

  @override
  String get paymentNoteHint => 'ملاحظة اختيارية';

  @override
  String get paymentDateLabel => 'تاريخ الدفع';

  @override
  String get invoiceDateLabel => 'تاريخ الفاتورة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsSubtitle => 'خصص مظهر التطبيق واللغة';

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get settingsLightMode => 'فاتح';

  @override
  String get settingsLightModeDesc => 'تشغيل الوضع الفاتح دائمًا';

  @override
  String get settingsDarkMode => 'داكن';

  @override
  String get settingsDarkModeDesc => 'تشغيل الوضع الداكن دائمًا';

  @override
  String get settingsSystemMode => 'حسب الجهاز';

  @override
  String get settingsSystemModeDesc => 'اتبع إعدادات الجهاز';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageEnglishDesc => 'App language in English';

  @override
  String get settingsLanguageArabic => 'العربية';

  @override
  String get settingsLanguageArabicDesc => 'لغة التطبيق بالعربية';

  @override
  String get appTitle => 'تطبيق مبيعات المصنع';

  @override
  String get commonSearch => 'بحث';

  @override
  String get commonTotal => 'الإجمالي';

  @override
  String get commonPaid => 'المدفوع';

  @override
  String get commonRemaining => 'المتبقي';

  @override
  String get commonQuantity => 'الكمية';

  @override
  String get commonUnitPrice => 'سعر الوحدة';

  @override
  String get commonStatus => 'الحالة';

  @override
  String get commonCustomer => 'العميل';

  @override
  String get commonDate => 'التاريخ';

  @override
  String get commonNoNote => 'لا توجد ملاحظة';

  @override
  String get productDeleted => 'تم حذف المنتج';

  @override
  String get errorProductNameRequired => 'اسم المنتج مطلوب';

  @override
  String get errorProductNameShort => 'اسم المنتج قصير جداً';

  @override
  String get errorProductPriceRequired => 'السعر مطلوب';

  @override
  String get errorProductPriceInvalid => 'أدخل سعراً صحيحاً';

  @override
  String get errorProductPriceZero => 'يجب أن يكون السعر أكبر من صفر';

  @override
  String get errorInvalidAmount => 'أدخل مبلغ دفع صحيح';

  @override
  String get errorAmountExceedsRemaining => 'لا يمكن أن يتجاوز الدفع المبلغ المتبقي';

  @override
  String get savePaymentBtn => 'حفظ الدفعة';

  @override
  String get invoicesTotalTitle => 'إجمالي الفواتير';

  @override
  String get invoicesTotalSubtitle => 'محفوظة محلياً';

  @override
  String get invoicesRevenueTitle => 'إجمالي الإيرادات';

  @override
  String get invoicesRevenueSubtitle => 'إجمالي جميع الفواتير';

  @override
  String get invoicesCreateBtn => 'إنشاء فاتورة';

  @override
  String get invoicesVisibleTitle => 'الفواتير الظاهرة';

  @override
  String get invoicesOutstandingTitle => 'المتبقي';

  @override
  String get invoicesEmptyTitle => 'لا توجد فواتير';

  @override
  String get errorSelectCustomer => 'الرجاء اختيار عميل';

  @override
  String get errorAddInvoiceItem => 'أضف عنصراً واحداً صحيحاً على الأقل';

  @override
  String get invoiceDetailsTitle => 'تفاصيل الفاتورة';

  @override
  String get invoiceAddPaymentBtn => 'إضافة دفعة';

  @override
  String get invoiceItemsCount => 'عدد العناصر';

  @override
  String get invoiceLineTotal => 'إجمالي السطر';

  @override
  String get errorCreateCustomerFirst => 'الرجاء إنشاء عميل واحد على الأقل أولاً';

  @override
  String get errorCreateProductFirst => 'الرجاء إنشاء منتج واحد على الأقل أولاً';

  @override
  String get invoiceCreatedMessage => 'تم إنشاء الفاتورة';

  @override
  String get invoiceDeletedMessage => 'تم حذف الفاتورة';

  @override
  String get customersTotalTitle => 'إجمالي العملاء';

  @override
  String get customersTotalSubtitle => 'محفوظة محلياً';

  @override
  String get customersSearchableTitle => 'قابل للبحث';

  @override
  String get customersSearchableSubtitle => 'بالاسم ورقم الهاتف';

  @override
  String get customersAddBtn => 'إضافة عميل';

  @override
  String get customersEmptyTitle => 'لا يوجد عملاء حتى الآن';

  @override
  String get customerStatsInvoiced => 'المفوتر';

  @override
  String get customerStatsPaid => 'المدفوع';

  @override
  String get customerStatsOutstanding => 'المتبقي';

  @override
  String customerLedgerInvoiceCreated(String ref) {
    return 'تم إنشاء الفاتورة #$ref';
  }

  @override
  String get customerLedgerInvoiceDesc => 'أُضيفت إلى رصيد العميل';

  @override
  String get customerLedgerPaymentReceived => 'تم استلام دفعة';

  @override
  String get customerDeletedMessage => 'تم حذف العميل';

  @override
  String get customerSavedMessage => 'تم حفظ العميل';

  @override
  String get invoicesEmptySubtitleNew => 'قم بإنشاء فاتورتك الأولى لبدء تتبع المبيعات والمدفوعات.';

  @override
  String get invoicesEmptySubtitleSearch => 'لا توجد فواتير تطابق البحث الحالي أو الفلاتر المحددة.';

  @override
  String get invoiceFilterAll => 'الكل';

  @override
  String get invoiceFilterOutstanding => 'المتبقي';

  @override
  String get invoiceFilterPaid => 'المدفوع';

  @override
  String get invoiceFilterCancelled => 'ملغاة';

  @override
  String get customersEmptySubtitle => 'أضف عميلك الأول لبدء إنشاء الفواتير وتتبع الأرصدة.';

  @override
  String commonItemsCount(int count) {
    return '$count عناصر';
  }

  @override
  String get commonSaveChanges => 'حفظ التغييرات';

  @override
  String get invoiceEditTitle => 'تعديل الفاتورة';

  @override
  String get productCreateTitle => 'إضافة منتج';

  @override
  String invoiceRefTitle(String ref) {
    return 'فاتورة #$ref';
  }

  @override
  String get invoiceNoPaymentsYet => 'لا توجد مدفوعات بعد';

  @override
  String get customerEditTitle => 'تعديل العميل';

  @override
  String get customerCreateTitle => 'إضافة عميل';

  @override
  String get customerAddDesc => 'أدخل تفاصيل العميل أدناه.';

  @override
  String get errorCustomerNameRequired => 'اسم العميل مطلوب';

  @override
  String get errorCustomerNameShort => 'اسم العميل قصير جداً';

  @override
  String get errorCustomerPhoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get errorCustomerPhoneInvalid => 'أدخل رقم هاتف صحيح';

  @override
  String get statusDraft => 'مسودة';

  @override
  String get statusUnpaid => 'غير مدفوع';

  @override
  String get statusPartiallyPaid => 'مدفوع جزئياً';

  @override
  String get statusPaid => 'مدفوع';

  @override
  String get statusCancelled => 'ملغاة';

  @override
  String get statusUnknown => 'غير معروف';

  @override
  String get deleteInvoiceTitle => 'حذف الفاتورة';

  @override
  String deleteInvoiceMessage(String ref) {
    return 'هل أنت متأكد من حذف الفاتورة #$ref؟ لا يمكن التراجع عن هذا الإجراء.';
  }
}
