class DiagnosticPrescriptionState {

  final bool loading;
  final bool success;
  final String message;

  const DiagnosticPrescriptionState({
    this.loading = false,
    this.success = false,
    this.message = "",
  });

  DiagnosticPrescriptionState copyWith({
    bool? loading,
    bool? success,
    String? message,
  }) {
    return DiagnosticPrescriptionState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
      message: message ?? this.message,
    );
  }
}