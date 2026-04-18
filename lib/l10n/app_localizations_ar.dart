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
  String get commonDelete => 'حذف';

  @override
  String get commonEdit => 'تعديل';

  @override
  String get productFixedPrice => 'سعر ثابت';
}
