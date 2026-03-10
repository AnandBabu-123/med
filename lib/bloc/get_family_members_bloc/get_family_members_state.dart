
import '../../models/family_member_model/total_family_members_model.dart';

class GetFamilyMembersState {

  final bool loading;
  final List<FamilyMember> members;
  final String error;

  const GetFamilyMembersState({
    this.loading = false,
    this.members = const [],
    this.error = "",
  });

  GetFamilyMembersState copyWith({
    bool? loading,
    List<FamilyMember>? members,
    String? error,
  }) {
    return GetFamilyMembersState(
      loading: loading ?? this.loading,
      members: members ?? this.members,
      error: error ?? this.error,
    );
  }
}