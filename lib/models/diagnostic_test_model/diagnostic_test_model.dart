class DiagnosticTestsModel {

  final DiagnosticResponse response;

  DiagnosticTestsModel({required this.response});

  factory DiagnosticTestsModel.fromJson(Map<String,dynamic> json){
    return DiagnosticTestsModel(
      response: DiagnosticResponse.fromJson(json["response"]),
    );
  }
}

class DiagnosticResponse {

  final List<TestMainData> mainData;

  DiagnosticResponse({required this.mainData});

  factory DiagnosticResponse.fromJson(Map<String,dynamic> json){
    return DiagnosticResponse(
      mainData: (json["main_data"] as List)
          .map((e)=>TestMainData.fromJson(e))
          .toList(),
    );
  }
}

class TestMainData {

  final int id;
  final String name;
  final String image;
  final int price;
  final int discountPrice;
  final String reportIn;
  final String fasting;
  final List<TestCategory> tests;

  TestMainData({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.discountPrice,
    required this.reportIn,
    required this.fasting,
    required this.tests,
  });

  factory TestMainData.fromJson(Map<String, dynamic> json) {

    return TestMainData(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      price: json["one_person"],
      discountPrice: json["one_person_discount"],
      reportIn: json["report_in"],
      fasting: json["fasting"],

      tests: (json["tests"] as List? ?? [])
          .map((e) => TestCategory.fromJson(e))
          .toList(),
    );
  }
}
class TestCategory {

  final int id;
  final String name;
  final List<SubTest> subTests;

  TestCategory({
    required this.id,
    required this.name,
    required this.subTests,
  });

  factory TestCategory.fromJson(Map<String, dynamic> json) {

    return TestCategory(
      id: json["id"],
      name: json["name"],

      subTests: (json["sub_tests"] as List? ?? [])
          .map((e) => SubTest.fromJson(e))
          .toList(),
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
      id: json["id"],
      name: json["name"],
    );
  }
}