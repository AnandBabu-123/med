

enum OtpStatus { initial, loading, success, failure }

class OtpState {
  final OtpStatus status;
  final String message;

  const OtpState({
    this.status = OtpStatus.initial,
    this.message = '',
  });

  OtpState copyWith({
    OtpStatus? status,
    String? message,
  }) {
    return OtpState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}