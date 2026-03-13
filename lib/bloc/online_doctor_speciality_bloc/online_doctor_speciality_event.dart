import 'package:equatable/equatable.dart';

abstract class OnlineDoctorSpecialityEvent extends Equatable {
  const OnlineDoctorSpecialityEvent();

  @override
  List<Object?> get props => [];
}

/// FIRST API
class FetchOnlineDoctorsEvent extends OnlineDoctorSpecialityEvent {
  final String language;

  const FetchOnlineDoctorsEvent({required this.language});

  @override
  List<Object?> get props => [language];
}

/// SECOND API
class FetchDoctorsBySpecialityEvent extends OnlineDoctorSpecialityEvent {
  final int specialityId;
  final String language;
  final bool isPagination;

  const FetchDoctorsBySpecialityEvent({
    required this.specialityId,
    required this.language,
    this.isPagination = false,
  });

  @override
  List<Object?> get props => [specialityId, language, isPagination];
}