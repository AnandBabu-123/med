class FamilyCountModel {
  final bool status;
  final String message;
  final FamilyCountResponse response;

  FamilyCountModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory FamilyCountModel.fromJson(Map<String, dynamic> json) {
    return FamilyCountModel(
      status: json["status"],
      message: json["message"],
      response: FamilyCountResponse.fromJson(json["response"]),
    );
  }
}

class FamilyCountResponse {
  final String familyMembersId;
  final int count;

  FamilyCountResponse({
    required this.familyMembersId,
    required this.count,
  });

  factory FamilyCountResponse.fromJson(Map<String, dynamic> json) {
    return FamilyCountResponse(
      familyMembersId: json["family_members_id"] ?? 0,
      count: json["count"] ?? 0,
    );
  }
}