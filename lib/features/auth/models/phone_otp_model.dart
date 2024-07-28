class MobileResponse {
  final int statusCode;
  final MobileData data;
  final String message;
  final bool success;

  MobileResponse({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory MobileResponse.fromJson(Map<String, dynamic> json) {
    return MobileResponse(
      statusCode: json['statusCode'],
      data: MobileData.fromJson(json['data']),
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

class MobileData {
  final String requestId;

  MobileData({
    required this.requestId,
  });

  factory MobileData.fromJson(Map<String, dynamic> json) {
    return MobileData(
      requestId: json['requestID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestID': requestId,
    };
  }
}
