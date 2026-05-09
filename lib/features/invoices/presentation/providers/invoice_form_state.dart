import '../../../customers/domain/entities/customer_entity.dart';
import '../../data/models/invoice_model.dart';

class InvoiceFormState {
  final InvoiceModel? invoice;
  final CustomerEntity? selectedCustomer;
  final bool isSaving;
  final Map<String, String> validationErrors;

  const InvoiceFormState({
    this.invoice,
    this.selectedCustomer,
    this.isSaving = false,
    this.validationErrors = const {},
  });

  InvoiceFormState copyWith({
    InvoiceModel? invoice,
    CustomerEntity? selectedCustomer,
    bool? isSaving,
    Map<String, String>? validationErrors,
  }) {
    return InvoiceFormState(
      invoice: invoice ?? this.invoice,
      selectedCustomer: selectedCustomer ?? this.selectedCustomer,
      isSaving: isSaving ?? this.isSaving,
      validationErrors: validationErrors ?? this.validationErrors,
    );
  }
}
