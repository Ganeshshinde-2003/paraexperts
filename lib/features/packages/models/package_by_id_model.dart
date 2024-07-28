class PackageByIdResponse {
  final int statusCode;
  final PackageByData data;
  final String message;
  final bool success;

  PackageByIdResponse({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory PackageByIdResponse.fromJson(Map<String, dynamic> json) {
    return PackageByIdResponse(
      statusCode: json['statusCode'],
      data: PackageByData.fromJson(json['data']),
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

class PackageByData {
  final String title;
  final String priority;
  final String type;
  final String description;
  final int amount;
  final String packageDuration;
  final List<String> services;
  final String id;

  PackageByData({
    required this.title,
    required this.priority,
    required this.type,
    required this.description,
    required this.amount,
    required this.packageDuration,
    required this.services,
    required this.id,
  });

  factory PackageByData.fromJson(Map<String, dynamic> json) {
    return PackageByData(
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
