import '../../models/diagnostic_test_model/diagnostic_test_model.dart';


enum DiagnosticTestsStatus { initial, loading, success, failure }

class DiagnosticTestsState {

  final DiagnosticTestsStatus status;
  final List<TestMainData> list;

  const DiagnosticTestsState({
    this.status = DiagnosticTestsStatus.initial,
    this.list = const [],
  });

  DiagnosticTestsState copyWith({
    DiagnosticTestsStatus? status,
    List<TestMainData>? list,
  }) {
    return DiagnosticTestsState(
      status: status ?? this.status,
      list: list ?? this.list,
    );
  }
}