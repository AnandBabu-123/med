import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/banner_repository/banner_repository.dart';
import 'banner_event.dart';
import 'banner_state.dart';

// class BannerBloc extends Bloc<BannerEvent, BannerState> {
//
//   final BannerRepository repository;
//
//   BannerBloc(this.repository) : super(BannerInitial()) {
//
//     on<FetchBannerEvent>((event, emit) async {
//       emit(BannerLoading());
//
//       try {
//         final data = await repository.fetchBanners();
//         emit(BannerLoaded(data));
//       } catch (e) {
//         emit(BannerError(e.toString()));
//       }
//     });
//   }
// }



class BannerBloc extends Bloc<BannerEvent, BannerState> {

  final BannerRepository repository;

  BannerBloc(this.repository) : super(BannerInitial()) {

    on<FetchBannerEvent>((event, emit) async {
      emit(BannerLoading());

      try {
        final banners = await repository.fetchBanners();
        emit(BannerLoaded(banners));
      } catch (e) {
        emit(BannerError(e.toString()));
      }
    });
  }
}