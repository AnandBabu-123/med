import 'dart:io';
import '../../models/profile_request_model/profile_request_model.dart';

abstract class ProfileEvent {}

class LoadProfileDropdowns extends ProfileEvent {
  final String language;

  LoadProfileDropdowns({
    required this.language,
  });
}

class SubmitProfileEvent extends ProfileEvent {

  final ProfileRequestModel request;

  SubmitProfileEvent({
    required this.request,
  });

}