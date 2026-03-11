class PharmacyOngoingOrdersModel {
  final bool status;
  final String message;
  final OrdersResponse response;

  PharmacyOngoingOrdersModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory PharmacyOngoingOrdersModel.fromJson(Map<String, dynamic> json) {
    return PharmacyOngoingOrdersModel(
      status: json["status"],
      message: json["message"],
      response: OrdersResponse.fromJson(json["response"]),
    );
  }
}

class OrdersResponse {
  final List<OrderItem> orders;
  final Pagination pagination;

  OrdersResponse({
    required this.orders,
    required this.pagination,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      orders: List<OrderItem>.from(
        json["orders"].map((x) => OrderItem.fromJson(x)),
      ),
      pagination: Pagination.fromJson(json["pagination"]),
    );
  }
}

class OrderItem {
  final int id;
  final String bookingId;
  final String hospitalName;
  final String orderType;
  final String createdOn;
  final String bookingType;
  final String bookingStatus;
  final String image;
  final String acceptStatus;
  final List<dynamic> products;

  OrderItem({
    required this.id,
    required this.bookingId,
    required this.hospitalName,
    required this.orderType,
    required this.createdOn,
    required this.bookingType,
    required this.bookingStatus,
    required this.image,
    required this.acceptStatus,
    required this.products,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json["id"],
      bookingId: json["booking_id"],
      hospitalName: json["hospital_name"],
      orderType: json["order_type"],
      createdOn: json["created_on"],
      bookingType: json["booking_type"],
      bookingStatus: json["booking_status"],
      image: json["image"],
      acceptStatus: json["accept_status"],
      products: json["products"] ?? [],
    );
  }
}

class Pagination {
  final int currentPage;
  final int limit;
  final List<TotalPages> totalPages;

  Pagination({
    required this.currentPage,
    required this.limit,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json["current_page"],
      limit: json["limit"],
      totalPages: List<TotalPages>.from(
        json["total_pages"].map((x) => TotalPages.fromJson(x)),
      ),
    );
  }
}

class TotalPages {
  final int page;

  TotalPages({required this.page});

  factory TotalPages.fromJson(Map<String, dynamic> json) {
    return TotalPages(
      page: json["page"],
    );
  }
}