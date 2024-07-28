class OTPResponse {
  final int statusCode;
  final OTPData data;
  final String message;
  final bool success;

  OTPResponse({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory OTPResponse.fromJson(Map<String, dynamic> json) {
    return OTPResponse(
      statusCode: json['statusCode'],
      data: OTPData.fromJson(json['data']),
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

class OTPData {
  final String token;
  final bool isNewUser;
  final String userId;

  OTPData({
    required this.token,
    required this.isNewUser,
    required this.userId,
  });

  factory OTPData.fromJson(Map<String, dynamic> json) {
    return OTPData(
      token: json['token'],
      isNewUser: json['isNewUser'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'isNewUser': isNewUser,
      'userId': userId,
    };
  }
}
