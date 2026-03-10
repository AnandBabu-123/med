class TotalFamilyMembersModel {
  final bool status;
  final String message;
  final List<FamilyMember> familyMembers;

  TotalFamilyMembersModel({
    required this.status,
    required this.message,
    required this.familyMembers,
  });

  factory TotalFamilyMembersModel.fromJson(Map<String, dynamic> json) {
    return TotalFamilyMembersModel(
      status: json["status"],
      message: json["message"],
      familyMembers: (json["response"]["family_members"] as List)
          .map((e) => FamilyMember.fromJson(e))
          .toList(),
    );
  }
}

class FamilyMember {
  final int id;
  final String name;
  final String type;
  final int mobile;

  FamilyMember({
    required this.id,
    required this.name,
    required this.type,
    required this.mobile,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json["id"],
      name: json["name"],
      type: json["type"],
      mobile: json["mobile"],
    );
  }
}