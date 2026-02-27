import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/prifile_repository/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(const ProfileState()) {

    on<SubmitProfileEvent>(_submitProfile);
  }

  Future<void> _submitProfile(
      SubmitProfileEvent event,
      Emitter<ProfileState> emit,
      ) async {

    emit(state.copyWith(
      status: ProfileStatus.loading,
      message: "",
    ));

    try {

      final response = await repository.updateProfile(
        event.request,
        event.image,
      );

      emit(state.copyWith(
        status: ProfileStatus.success,
        message: response["message"] ?? "Profile Updated Successfully",
      ));

    } catch (e) {

      emit(state.copyWith(
        status: ProfileStatus.failure,
        message: e.toString().replaceAll("Exception:", ""),
      ));
    }
  }
}