class AppointmentDetailModel {
  const AppointmentDetailModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  final int statusCode;
  final AppointmentDetailsData data;
  final String message;
  final bool success;

  factory AppointmentDetailModel.fromJson(Map<String, dynamic> json) {
    return AppointmentDetailModel(
      statusCode: json['statusCode'],
      data: AppointmentDetailsData.fromJson(json['data']),
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

class AppointmentDetailsData {
  const AppointmentDetailsData({
    required this.appointment,
  });

  final AppointmentDetailsAppointmentEntity appointment;

  factory AppointmentDetailsData.fromJson(Map<String, dynamic> json) {
    return AppointmentDetailsData(
      appointment:
          AppointmentDetailsAppointmentEntity.fromJson(json['appointment']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment': appointment.toJson(),
    };
  }
}

class AppointmentDetailsAppointmentEntity {
  const AppointmentDetailsAppointmentEntity({
    required this.id,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.appointmentMode,
    required this.appointmentMethod,
    required this.callToken,
    required this.problem,
    this.reason,
  });

  final String id;
  final UserId userId;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String? reason;
  final String status;
  final String appointmentMode;
  final String appointmentMethod;
  final String callToken;
  final List<String> problem;

  factory AppointmentDetailsAppointmentEntity.fromJson(
      Map<String, dynamic> json) {
    return AppointmentDetailsAppointmentEntity(
      id: json['_id'],
      userId: UserId.fromJson(json['userId']),
      date: DateTime.parse(json['date']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      status: json['status'],
      appointmentMode: json['appointmentMode'],
      appointmentMethod: json['appointmentMethod'],
      callToken: json['callToken'],
      reason: json['reason'],
      problem: List<String>.from(json['problem']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId.toJson(),
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'appointmentMode': appointmentMode,
      'appointmentMethod': appointmentMethod,
      'callToken': callToken,
      'problem': problem,
      'reason': reason,
    };
  }
}

class UserId {
  const UserId({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  final String id;
  final String name;
  final String profilePicture;

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
