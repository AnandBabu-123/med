abstract class ConfirmPharmacyOrderState {}

class ConfirmOrderPharmacyInitial extends ConfirmPharmacyOrderState {}

class ConfirmOrderPharmacyLoading extends ConfirmPharmacyOrderState {}

class ConfirmOrderPharmacySuccess extends ConfirmPharmacyOrderState {
  final String message;

  ConfirmOrderPharmacySuccess(this.message);
}

class ConfirmOrderPharmacyError extends ConfirmPharmacyOrderState {
  final String error;

  ConfirmOrderPharmacyError(this.error);
}