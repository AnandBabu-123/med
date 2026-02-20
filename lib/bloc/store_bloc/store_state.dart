

import 'package:equatable/equatable.dart';

import '../../models/storeModel/store_model.dart';
import '../../utils/enums.dart';


class StoreState extends Equatable {
  final PostApiStatus status;
  final List<StoreModel> stores;
  final String message;

  const StoreState({
    this.status = PostApiStatus.initial,
    this.stores = const [],
    this.message = '',
  });

  StoreState copyWith({
    PostApiStatus? status,
    List<StoreModel>? stores,
    String? message,
  }) {
    return StoreState(
      status: status ?? this.status,
      stores: stores ?? this.stores,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, stores, message];
}
