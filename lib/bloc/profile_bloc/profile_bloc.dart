import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repository/profile_repository/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

import 'dart:convert';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileState()) {

    on<LoadProfileDropdowns>(_loadDropdowns);
    on<SubmitProfileEvent>(_submitProfile);

  }

  /// ================= LOAD DROPDOWNS =================

  Future<void> _loadDropdowns(
      LoadProfileDropdowns event,
      Emitter<ProfileState> emit
      ) async {

    emit(state.copyWith(status: ProfileStatus.loading));

    try {

      final prefs = await SharedPreferences.getInstance();

      final userId = prefs.getInt("user_id") ?? 0;
      final token = prefs.getString("auth_token") ?? "";

      final response = await repository.fetchDropdowns(
        userId: userId,
        token: token,
        language: event.language,
      );

      Map<String,String> genderMap = {};
      Map<String,String> bloodMap = {};
      Map<String,String> coverageMap = {};

      for (var g in response.gender) {
        genderMap[g.id.toString()] = g.name;
      }

      for (var b in response.bloodGroups) {
        bloodMap[b.id.toString()] = b.name;
      }

      for (var c in response.categories) {
        coverageMap[c.id.toString()] = c.name;
      }

      emit(state.copyWith(
        status: ProfileStatus.dropdownLoaded,
        genderList: genderMap,
        bloodGroupList: bloodMap,
        coverageList: coverageMap,
      ));

    } catch (e) {

      emit(state.copyWith(
        status: ProfileStatus.failure,
        message: e.toString(),
      ));

    }
  }

  /// ================= SUBMIT PROFILE =================

  Future<void> _submitProfile(
      SubmitProfileEvent event,
      Emitter<ProfileState> emit,
      ) async {

    emit(state.copyWith(status: ProfileStatus.loading));

    try {

      final body = event.request.toJson();

      print("========= PROFILE REQUEST BODY =========");
      print(body);

      final message = await repository.submitProfile(body);

      emit(state.copyWith(
        status: ProfileStatus.success,
        message: message,
      ));

    } catch (e) {

      emit(state.copyWith(
        status: ProfileStatus.failure,
        message: e.toString(),
      ));

    }
  }

}