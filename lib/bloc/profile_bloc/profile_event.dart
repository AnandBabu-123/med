import 'dart:io';
import '../../models/profile_request_model/profile_request_model.dart';

abstract class ProfileEvent {}

/// LOAD DROPDOWNS
class LoadProfileDropdowns extends ProfileEvent {

  final String language;

  LoadProfileDropdowns({
    required this.language,
  });

}

/// SUBMIT PROFILE
class SubmitProfileEvent extends ProfileEvent {

  final ProfileRequestModel request;
  final File? image;

  SubmitProfileEvent({
    required this.request,
    this.image,
  });

}