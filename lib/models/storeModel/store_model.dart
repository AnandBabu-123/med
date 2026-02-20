class StoreModel {
  String? message;
  bool? status;
  List<Stores>? stores;
  int? currentPage;
  int? pageSize;
  int? totalElements;
  int? totalPages;

  StoreModel(
      {this.message,
        this.status,
        this.stores,
        this.currentPage,
        this.pageSize,
        this.totalElements,
        this.totalPages});

  StoreModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['stores'] != null) {
      stores = <Stores>[];
      json['stores'].forEach((v) {
        stores!.add(new Stores.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    pageSize = json['pageSize'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.stores != null) {
      data['stores'] = this.stores!.map((v) => v.toJson()).toList();
    }
    data['currentPage'] = this.currentPage;
    data['pageSize'] = this.pageSize;
    data['totalElements'] = this.totalElements;
    data['totalPages'] = this.totalPages;
    return data;
  }
}

class Stores {
  String? type;
  String? userIdStoreId;
  String? id;
  String? name;
  String? pincode;
  String? district;
  String? state;
  String? location;
  String? owner;
  String? ownerContact;
  String? secondaryContact;
  String? ownerEmail;
  String? registrationDate;
  String? creationTimeStamp;
  String? role;
  String? addedBy;
  String? modifiedBy;
  String? modifiedDate;
  String? modifiedTimeStamp;
  String? status;
  String? storeVerifiedStatus;
  String? expiryDate;
  String? currentPlan;
  String? storeBusinessType;
  String? userId;
  String? gstNumber;

  Stores(
      {this.type,
        this.userIdStoreId,
        this.id,
        this.name,
        this.pincode,
        this.district,
        this.state,
        this.location,
        this.owner,
        this.ownerContact,
        this.secondaryContact,
        this.ownerEmail,
        this.registrationDate,
        this.creationTimeStamp,
        this.role,
        this.addedBy,
        this.modifiedBy,
        this.modifiedDate,
        this.modifiedTimeStamp,
        this.status,
        this.storeVerifiedStatus,
        this.expiryDate,
        this.currentPlan,
        this.storeBusinessType,
        this.userId,
        this.gstNumber});

  Stores.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    userIdStoreId = json['userIdStoreId'];
    id = json['id'];
    name = json['name'];
    pincode = json['pincode'];
    district = json['district'];
    state = json['state'];
    location = json['location'];
    owner = json['owner'];
    ownerContact = json['ownerContact'];
    secondaryContact = json['secondaryContact'];
    ownerEmail = json['ownerEmail'];
    registrationDate = json['registrationDate'];
    creationTimeStamp = json['creationTimeStamp'];
    role = json['role'];
    addedBy = json['addedBy'];
    modifiedBy = json['modifiedBy'];
    modifiedDate = json['modifiedDate'];
    modifiedTimeStamp = json['modifiedTimeStamp'];
    status = json['status'];
    storeVerifiedStatus = json['storeVerifiedStatus'];
    expiryDate = json['expiryDate'];
    currentPlan = json['currentPlan'];
    storeBusinessType = json['storeBusinessType'];
    userId = json['userId'];
    gstNumber = json['gstNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['userIdStoreId'] = this.userIdStoreId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['pincode'] = this.pincode;
    data['district'] = this.district;
    data['state'] = this.state;
    data['location'] = this.location;
    data['owner'] = this.owner;
    data['ownerContact'] = this.ownerContact;
    data['secondaryContact'] = this.secondaryContact;
    data['ownerEmail'] = this.ownerEmail;
    data['registrationDate'] = this.registrationDate;
    data['creationTimeStamp'] = this.creationTimeStamp;
    data['role'] = this.role;
    data['addedBy'] = this.addedBy;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedDate'] = this.modifiedDate;
    data['modifiedTimeStamp'] = this.modifiedTimeStamp;
    data['status'] = this.status;
    data['storeVerifiedStatus'] = this.storeVerifiedStatus;
    data['expiryDate'] = this.expiryDate;
    data['currentPlan'] = this.currentPlan;
    data['storeBusinessType'] = this.storeBusinessType;
    data['userId'] = this.userId;
    data['gstNumber'] = this.gstNumber;
    return data;
  }
}
