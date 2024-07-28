class PackageResponse {
  int statusCode;
  List<PackageData> data;
  String message;
  bool success;

  PackageResponse({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory PackageResponse.fromJson(Map<String, dynamic> json) {
    return PackageResponse(
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
  String title;
  String priority;
  String type;
  String description;
  int amount;
  String? additional;
  String packageDuration;
  List<String> services;
  String id;

  PackageData({
    required this.title,
    required this.priority,
    required this.type,
    required this.description,
    required this.amount,
    this.additional,
    required this.packageDuration,
    required this.services,
    required this.id,
  });

  factory PackageData.fromJson(Map<String, dynamic> json) {
    return PackageData(
      title: json['title'],
      priority: json['priority'],
      type: json['type'],
      description: json['description'],
      amount: json['amount'],
      additional: json['additional'],
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
      'additional': additional,
      'packageDuration': packageDuration,
      'services': List<dynamic>.from(services.map((x) => x)),
      '_id': id,
    };
  }
}
