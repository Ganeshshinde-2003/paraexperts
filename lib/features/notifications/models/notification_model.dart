class NotificationEntity {
  final int? statusCode;
  final List<NotificationDataEntity> data;
  final String? message;
  final bool? success;

  NotificationEntity({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      statusCode: json['statusCode'],
      data: (json['data'] as List)
          .map((e) => NotificationDataEntity.fromJson(e))
          .toList(),
      message: json['message'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
      'success': success,
    };
  }
}

class NotificationDataEntity {
  final String? id;
  final String? title;
  final String? description;
  final String? referrer;
  final String? referrerId;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationDataEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.referrer,
    required this.referrerId,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationDataEntity.fromJson(Map<String, dynamic> json) {
    return NotificationDataEntity(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      referrer: json['referrer'],
      referrerId: json['referrerId'],
      image: json['image'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'referrer': referrer,
      'referrerId': referrerId,
      'image': image,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
