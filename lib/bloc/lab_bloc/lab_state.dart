import '../../models/lab_test_models/lab_model.dart';

enum LabStatus { initial, loading, success, failure }

class LabState {

  final LabStatus status;
  final List<LabPackage> packages;

  const LabState({
    this.status = LabStatus.initial,
    this.packages = const [],
  });

  LabState copyWith({
    LabStatus? status,
    List<LabPackage>? packages,
  }) {
    return LabState(
      status: status ?? this.status,
      packages: packages ?? this.packages,
    );
  }
}