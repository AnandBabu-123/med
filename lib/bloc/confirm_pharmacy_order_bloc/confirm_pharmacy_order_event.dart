import 'dart:io';

abstract class ConfirmPharmacyOrderEvent {}

class SubmitConfirmPharmacyOrderEvent extends ConfirmPharmacyOrderEvent {

  final int pharmacyId;
  final File file;
  final String orderType;
  final String language;
  final int addressId;
  final String name;
  final String mobile;

  SubmitConfirmPharmacyOrderEvent({
    required this.pharmacyId,
    required this.file,
    required this.orderType,
    required this.language,
    required this.addressId,
    required this.name,
    required this.mobile,
  });
}