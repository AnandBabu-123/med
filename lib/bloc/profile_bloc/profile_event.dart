import 'dart:io';
import '../../models/profile_request_model.dart';

abstract class ProfileEvent {}

/// Submit / Update Profile
class SubmitProfileEvent extends ProfileEvent {
  final ProfileRequestModel request;
  final File? image;

  SubmitProfileEvent({
    required this.request,
    this.image,
  });
}