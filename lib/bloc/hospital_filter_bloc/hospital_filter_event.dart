abstract class HospitalFilterEvent {}

class LoadHospitalFilter extends HospitalFilterEvent {
  final String language;

  LoadHospitalFilter(this.language);
}

class ChangeCategory extends HospitalFilterEvent {
  final int index;

  ChangeCategory(this.index);
}

class ToggleSpeciality extends HospitalFilterEvent {
  final int specialityId;

  ToggleSpeciality(this.specialityId);
}

class ResetFilters extends HospitalFilterEvent {}