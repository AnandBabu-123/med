import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/bloc/post_address_bloc/post_address_event.dart';
import 'package:medryder/bloc/post_address_bloc/post_address_state.dart';

import '../../repository/post_address_repository/post_address_repository.dart';


class PostAddressBloc
    extends Bloc<PostAddressEvent, PostAddressState> {

  final PostAddressRepository repository;

  PostAddressBloc(this.repository)
      : super(const PostAddressState()) {

    on<SubmitAddressEvent>(_submitAddress);
  }

  Future<void> _submitAddress(
      SubmitAddressEvent event,
      Emitter<PostAddressState> emit,
      ) async {

    /// RESET STATE
    emit(const PostAddressState(
      status: PostAddressStatus.loading,
    ));

    try {

      final message = await repository.addAddress({
        "address": event.address,
        "hno": event.hno,
        "building_no": event.buildingNo,
        "landmark": event.landmark,
        "lat": event.lat,
        "lon": event.lon,
        "state": event.state,
        "city": event.city,
        "pincode": event.pincode,
        "address_type": event.addressType,
      });

      /// ✅ SUCCESS EMIT
      emit(PostAddressState(
        status: PostAddressStatus.success,
        message: message,
      ));

    } catch (e) {

      /// ✅ FAILURE EMIT
      emit(PostAddressState(
        status: PostAddressStatus.failure,
        message: e.toString(),
      ));
    }
  }
}