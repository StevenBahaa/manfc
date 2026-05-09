import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../customers/domain/entities/customer_entity.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/constants/invoice_status.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/invoice_item_entity.dart';
import '../../data/models/invoice_model.dart';
import 'invoice_form_state.dart';
import 'invoice_providers.dart';

part 'invoice_form_provider.g.dart';

@riverpod
class InvoiceForm extends _$InvoiceForm {
  @override
  InvoiceFormState build() {
    return const InvoiceFormState();
  }

  void initialize({InvoiceEntity? initialInvoice, CustomerEntity? customer}) {
    if (initialInvoice != null) {
      state = state.copyWith(
        invoice: InvoiceModel(
          id: initialInvoice.id,
          customerId: initialInvoice.customerId,
          customerName: initialInvoice.customerName,
          totalAmount: initialInvoice.totalAmount,
          paidAmount: initialInvoice.paidAmount,
          remainingAmount: initialInvoice.remainingAmount,
          status: initialInvoice.status,
          createdAt: initialInvoice.createdAt,
          items: initialInvoice.items,
        ),
      );
    } else {
      final now = DateTime.now();
      state = state.copyWith(
        invoice: InvoiceModel(
          id: now.millisecondsSinceEpoch.toString(),
          customerId: customer?.id ?? '',
          customerName: customer?.name ?? '',
          totalAmount: 0,
          paidAmount: 0,
          remainingAmount: 0,
          status: InvoiceStatus.unpaid,
          createdAt: now,
          items: const [],
        ),
        selectedCustomer: customer,
      );
    }
  }

  void setCustomer(CustomerEntity customer) {
    final currentInvoice = state.invoice;
    if (currentInvoice != null) {
      state = state.copyWith(
        invoice: currentInvoice.copyWith(
          customerId: customer.id,
          customerName: customer.name,
        ),
        selectedCustomer: customer,
      );
    }
  }

  void setDate(DateTime date) {
    final currentInvoice = state.invoice;
    if (currentInvoice != null) {
      state = state.copyWith(
        invoice: currentInvoice.copyWith(createdAt: date),
      );
    }
  }

  void addItem(ProductEntity product) {
    final currentInvoice = state.invoice;
    if (currentInvoice == null) return;

    final existingItems = List<InvoiceItemEntity>.from(currentInvoice.items);
    
    // Check if product already exists, increment quantity if so
    final existingIndex = existingItems.indexWhere((item) => item.productId == product.id);
    
    if (existingIndex != -1) {
      final item = existingItems[existingIndex];
      final newQty = item.quantity + 1;
      existingItems[existingIndex] = InvoiceItemEntity(
        id: item.id,
        invoiceId: item.invoiceId,
        productId: item.productId,
        productName: item.productName,
        unitPrice: item.unitPrice,
        quantity: newQty,
        lineTotal: item.unitPrice * newQty,
      );
    } else {
      final itemId = '${currentInvoice.id}_${product.id}_${DateTime.now().microsecondsSinceEpoch}';
      existingItems.add(
        InvoiceItemEntity(
          id: itemId,
          invoiceId: currentInvoice.id,
          productId: product.id,
          productName: product.name,
          unitPrice: product.price,
          quantity: 1,
          lineTotal: product.price,
        ),
      );
    }

    _updateInvoiceItems(existingItems);
  }

  void updateItemQuantity(String itemId, int quantity) {
    final currentInvoice = state.invoice;
    if (currentInvoice == null) return;

    final items = List<InvoiceItemEntity>.from(currentInvoice.items);
    final index = items.indexWhere((item) => item.id == itemId);
    
    if (index != -1 && quantity > 0) {
      final item = items[index];
      items[index] = InvoiceItemEntity(
        id: item.id,
        invoiceId: item.invoiceId,
        productId: item.productId,
        productName: item.productName,
        unitPrice: item.unitPrice,
        quantity: quantity,
        lineTotal: item.unitPrice * quantity,
      );
      _updateInvoiceItems(items);
    }
  }

  void removeItem(String itemId) {
    final currentInvoice = state.invoice;
    if (currentInvoice == null) return;

    final items = List<InvoiceItemEntity>.from(currentInvoice.items);
    items.removeWhere((item) => item.id == itemId);
    
    _updateInvoiceItems(items);
  }

  void _updateInvoiceItems(List<InvoiceItemEntity> items) {
    final currentInvoice = state.invoice;
    if (currentInvoice == null) return;

    final totalAmount = items.fold<double>(0, (sum, item) => sum + item.lineTotal);
    
    state = state.copyWith(
      invoice: currentInvoice.copyWith(
        items: items,
        totalAmount: totalAmount,
        remainingAmount: totalAmount - currentInvoice.paidAmount,
      ),
    );
  }

  Future<bool> save() async {
    final currentInvoice = state.invoice;
    if (currentInvoice == null) return false;

    // Basic Validation
    if (currentInvoice.customerId.isEmpty) {
      state = state.copyWith(validationErrors: {'customer': 'Please select a customer'});
      return false;
    }
    if (currentInvoice.items.isEmpty) {
      state = state.copyWith(validationErrors: {'items': 'Please add at least one item'});
      return false;
    }

    state = state.copyWith(isSaving: true, validationErrors: {});

    try {
      final repository = ref.read(invoiceRepositoryProvider);
      await repository.saveInvoice(currentInvoice);
      
      // Invalidate the list provider so it refreshes
      ref.invalidate(invoicesProvider);
      
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        validationErrors: {'general': 'Failed to save invoice: $e'},
      );
      return false;
    }
  }
}
