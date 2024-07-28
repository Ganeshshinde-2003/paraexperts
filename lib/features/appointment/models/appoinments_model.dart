class AppointmentResponse {
  int statusCode;
  List<Appointment> data;
  String message;
  bool success;

  AppointmentResponse({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
      statusCode: json['statusCode'],
      data: List<Appointment>.from(
          json['data'].map((x) => Appointment.fromJson(x))),
      message: json['message'],
      success: json['success'],
    );
  }
}

class Appointment {
  String id;
  UserData? userId;
  String date;
  String startTime;
  String endTime;
  String status;
  String appointmentMode;
  String? appointmentMethod;
  String callToken;

  Appointment({
    required this.id,
    this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.appointmentMode,
    this.appointmentMethod,
    required this.callToken,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id'],
      userId: json['userId'] != null ? UserData.fromJson(json['userId']) : null,
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      status: json['status'],
      appointmentMode: json['appointmentMode'],
      appointmentMethod: json['appointmentMethod'],
      callToken: json['callToken'],
    );
  }
}

class UserData {
  String id;
  String name;
  String? profilePicture;

  UserData({
    required this.id,
    required this.name,
    this.profilePicture,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      name: json['name'],
      profilePicture: json['profilePicture'],
    );
  }
}
