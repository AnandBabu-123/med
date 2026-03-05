enum ProfileStatus {
  initial,
  loading,
  success,
  failure,
  dropdownLoaded
}

class ProfileState {

  final ProfileStatus status;
  final String message;

  final Map<String,String> genderList;
  final Map<String,String> bloodGroupList;
  final Map<String,String> coverageList;

  ProfileState({
    this.status = ProfileStatus.initial,
    this.message = "",
    this.genderList = const {},
    this.bloodGroupList = const {},
    this.coverageList = const {},
  });

  ProfileState copyWith({
    ProfileStatus? status,
    String? message,
    Map<String,String>? genderList,
    Map<String,String>? bloodGroupList,
    Map<String,String>? coverageList,
  }) {
    return ProfileState(
      status: status ?? this.status,
      message: message ?? this.message,
      genderList: genderList ?? this.genderList,
      bloodGroupList: bloodGroupList ?? this.bloodGroupList,
      coverageList: coverageList ?? this.coverageList,
    );
  }
}