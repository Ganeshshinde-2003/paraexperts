class PackageBookedResponseModel {
  int statusCode;
  PackageBookedData data;
  String message;
  bool success;

  PackageBookedResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory PackageBookedResponseModel.fromJson(Map<String, dynamic> json) {
    return PackageBookedResponseModel(
      statusCode: json['statusCode'],
      data: PackageBookedData.fromJson(json['data']),
      message: json['message'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.toJson(),
      'message': message,
      'success': success,
    };
  }
}

class PackageBookedData {
  PackageBookedBookings bookings;
  PackageDetail packageDetail;

  PackageBookedData({
    required this.bookings,
    required this.packageDetail,
  });

  factory PackageBookedData.fromJson(Map<String, dynamic> json) {
    return PackageBookedData(
      bookings: PackageBookedBookings.fromJson(json['bookings']),
      packageDetail: PackageDetail.fromJson(json['packageDetail']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookings': bookings.toJson(),
      'packageDetail': packageDetail.toJson(),
    };
  }
}

class PackageBookedBookings {
  String id;
  String packageId;
  UserId userId;
  ParaExpertId paraExpertId;
  String bookingDate;
  String location;
  String prescriptionReport;
  String address;
  String status;
  String? questions;

  PackageBookedBookings({
    required this.id,
    required this.packageId,
    required this.userId,
    required this.paraExpertId,
    required this.bookingDate,
    required this.location,
    required this.prescriptionReport,
    required this.address,
    required this.status,
    this.questions,
  });

  factory PackageBookedBookings.fromJson(Map<String, dynamic> json) {
    return PackageBookedBookings(
      id: json['_id'],
      packageId: json['packageId'],
      userId: UserId.fromJson(json['userId']),
      paraExpertId: ParaExpertId.fromJson(json['paraExpertId']),
      bookingDate: json['bookingDate'],
      location: json['location'],
      prescriptionReport: json['prescriptionReport'],
      address: json['address'],
      status: json['status'],
      questions: json['questions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'packageId': packageId,
      'userId': userId.toJson(),
      'paraExpertId': paraExpertId.toJson(),
      'bookingDate': bookingDate,
      'location': location,
      'prescriptionReport': prescriptionReport,
      'address': address,
      'status': status,
      'questions': questions,
    };
  }
}

class UserId {
  String id;
  String name;
  String profilePicture;

  UserId({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      id: json['_id'],
      name: json['name'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'profilePicture': profilePicture,
    };
  }
}

class ParaExpertId {
  String id;
  UserId userId;

  ParaExpertId({
    required this.id,
    required this.userId,
  });

  factory ParaExpertId.fromJson(Map<String, dynamic> json) {
    return ParaExpertId(
      id: json['_id'],
      userId: UserId.fromJson(json['userId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId.toJson(),
    };
  }
}

class PackageDetail {
  String title;
  String priority;
  String type;
  String description;
  int amount;
  String packageDuration;
  List<String> services;
  String id;

  PackageDetail({
    required this.title,
    required this.priority,
    required this.type,
    required this.description,
    required this.amount,
    required this.packageDuration,
    required this.services,
    required this.id,
  });

  factory PackageDetail.fromJson(Map<String, dynamic> json) {
    return PackageDetail(
      title: json['title'],
      priority: json['priority'],
      type: json['type'],
      description: json['description'],
      amount: json['amount'],
      packageDuration: json['packageDuration'],
      services: List<String>.from(json['services']),
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'priority': priority,
      'type': type,
      'description': description,
      'amount': amount,
      'packageDuration': packageDuration,
      'services': services,
      '_id': id,
    };
  }
}
