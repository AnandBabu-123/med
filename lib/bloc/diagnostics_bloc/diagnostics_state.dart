import 'package:equatable/equatable.dart';
import '../../models/diagnostic_model/diagnostic_response.dart';

enum DiagnosticsStatus { initial, loading, success, failure }

class DiagnosticsState {

  final DiagnosticsStatus status;
  final List<Diagnostic> list;
  final int page;
  final bool hasReachedMax;
  final String search;

  const DiagnosticsState({
    this.status = DiagnosticsStatus.initial,
    this.list = const [],
    this.page = 1,
    this.hasReachedMax = false,
    this.search = "",
  });

  DiagnosticsState copyWith({
    DiagnosticsStatus? status,
    List<Diagnostic>? list,
    int? page,
    bool? hasReachedMax,
    String? search,
  }) {
    return DiagnosticsState(
      status: status ?? this.status,
      list: list ?? this.list,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      search: search ?? this.search,
    );
  }
}