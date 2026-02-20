
import 'package:bloc/bloc.dart';
import 'package:medryder/bloc/store_bloc/store_event.dart';
import 'package:medryder/bloc/store_bloc/store_state.dart';

import '../../repository/store_repository/store_repository.dart';
import '../../utils/enums.dart';


class StoreBloc extends Bloc<StoreEvent,StoreState>{
  final StoreRepository storeRepository;
  StoreBloc(this.storeRepository) : super( StoreState()){
  on<FetchStoreEvent>(_fetchStoress);
  }

  Future<void> _fetchStoress(
      FetchStoreEvent event, Emitter<StoreState> emit) async {

    emit(state.copyWith(status: PostApiStatus.loading));

    try {
      final stores = await storeRepository.fetchStores();

      emit(state.copyWith(
        status: PostApiStatus.success,
        stores: stores,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PostApiStatus.failure,
        message: e.toString(),
      ));
    }
  }

}