class LabModel {
  final bool status;
  final String message;
  final LabResponse response;

  LabModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory LabModel.fromJson(Map<String, dynamic> json) {
    return LabModel(
      status: json['status'],
      message: json['message'],
      response: LabResponse.fromJson(json['response']),
    );
  }
}

class LabResponse {
  final List<LabPackage> mainData;

  LabResponse({required this.mainData});

  factory LabResponse.fromJson(Map<String, dynamic> json) {
    return LabResponse(
      mainData: List<LabPackage>.from(
        json["main_data"].map((x) => LabPackage.fromJson(x)),
      ),
    );
  }
}

class LabPackage {
  final int id;
  final String name;
  final String image;
  final int price;
  final int discount;
  final String reportIn;
  final String fasting;
  final List<LabTest> tests;

  LabPackage({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.discount,
    required this.reportIn,
    required this.fasting,
    required this.tests,
  });

  factory LabPackage.fromJson(Map<String, dynamic> json) {
    return LabPackage(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['one_person'],
      discount: json['one_person_discount'],
      reportIn: json['report_in'],
      fasting: json['fasting'],
      tests: List<LabTest>.from(
        json['tests'].map((x) => LabTest.fromJson(x)),
      ),
    );
  }
}

class LabTest {
  final int id;
  final String name;
  final List<SubTest> subTests;

  LabTest({
    required this.id,
    required this.name,
    required this.subTests,
  });

  factory LabTest.fromJson(Map<String, dynamic> json) {
    return LabTest(
      id: json['id'],
      name: json['name'],
      subTests: List<SubTest>.from(
        json['sub_tests'].map((x) => SubTest.fromJson(x)),
      ),
    );
  }
}

class SubTest {
  final int id;
  final String name;

  SubTest({
    required this.id,
    required this.name,
  });

  factory SubTest.fromJson(Map<String, dynamic> json) {
    return SubTest(
      id: json['id'],
      name: json['name'],
    );
  }
}