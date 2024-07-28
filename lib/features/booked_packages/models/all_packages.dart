class GetAllPackageResponse {
  int statusCode;
  List<PackageData> data;
  String message;
  bool success;

  GetAllPackageResponse({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory GetAllPackageResponse.fromJson(Map<String, dynamic> json) {
    return GetAllPackageResponse(
      statusCode: json['statusCode'],
      data: List<PackageData>.from(
          json['data'].map((x) => PackageData.fromJson(x))),
      message: json['message'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
      'message': message,
      'success': success,
    };
  }
}

class PackageData {
  String id;
  String packageId;
  User userId;
  String paraExpertId;
  DateTime? bookingDate;
  String location;
  String status;
  String? prescriptionReport;
  String? address;

  PackageData({
    required this.id,
    required this.packageId,
    required this.userId,
    required this.paraExpertId,
    this.bookingDate,
    required this.location,
    required this.status,
    this.prescriptionReport,
    this.address,
  });

  factory PackageData.fromJson(Map<String, dynamic> json) {
    return PackageData(
      id: json['_id'],
      packageId: json['packageId'],
      userId: User.fromJson(json['userId']),
      paraExpertId: json['paraExpertId'],
      bookingDate: DateTime.parse(json['bookingDate']),
      location: json['location'],
      status: json['status'],
      prescriptionReport: json['prescriptionReport'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'packageId': packageId,
      'userId': userId.toJson(),
      'paraExpertId': paraExpertId,
      'bookingDate': bookingDate!.toIso8601String(),
      'location': location,
      'status': status,
      'prescriptionReport': prescriptionReport,
      'address': address,
    };
  }
}

class User {
  String id;
  String name;
  String profilePicture;

  User({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
