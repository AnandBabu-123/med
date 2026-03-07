import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/dignoastic_prescription_booking/diagnostic_prescription_repository.dart';
import 'diagnostic_prescription_event.dart';
import 'diagnostic_prescription_state.dart';

class DiagnosticPrescriptionBloc
    extends Bloc<DiagnosticPrescriptionEvent, DiagnosticPrescriptionState> {

  final DiagnosticPrescriptionRepository repository;

  DiagnosticPrescriptionBloc(this.repository)
      : super(const DiagnosticPrescriptionState()) {

    on<UploadPrescriptionEvent>(_uploadPrescription);
  }

  Future<void> _uploadPrescription(
      UploadPrescriptionEvent event,
      Emitter<DiagnosticPrescriptionState> emit) async {

    try {

      emit(state.copyWith(loading: true));

      final response = await repository.uploadPrescription(
        diagnosticId: event.diagnosticId,
        image: event.base64Image,
        name: event.name,
        mobile: event.mobile,
        familyMemberId: event.familyMemberId,
        language: event.language,
      );

      print("API RESPONSE : $response");

      emit(state.copyWith(
        loading: false,
        success: true,
        message: response["message"],
      ));

    } catch (e) {

      print("API ERROR : $e");

      emit(state.copyWith(
        loading: false,
        success: false,
        message: e.toString(),
      ));
    }
  }
}