class ProfileDropdownModel {
  final List<CommonItem> gender;
  final List<CommonItem> categories;
  final List<CommonItem> bloodGroups;

  ProfileDropdownModel({
    required this.gender,
    required this.categories,
    required this.bloodGroups,
  });

  factory ProfileDropdownModel.fromJson(Map<String, dynamic> json) {
    return ProfileDropdownModel(
      gender: (json["gender"] as List)
          .map((e) => CommonItem.fromJson(e))
          .toList(),
      categories: (json["categories"] as List)
          .map((e) => CommonItem.fromJson(e))
          .toList(),
      bloodGroups: (json["blood_groups"] as List)
          .map((e) => CommonItem.fromJson(e))
          .toList(),
    );
  }
}

class CommonItem {
  final int id;
  final String name;

  CommonItem({required this.id, required this.name});

  factory CommonItem.fromJson(Map<String, dynamic> json) {
    return CommonItem(
      id: json["id"],
      name: json["name"],
    );
  }
}