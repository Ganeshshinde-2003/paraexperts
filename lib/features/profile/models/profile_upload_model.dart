class UserProfilePictureUploadModel {
  const UserProfilePictureUploadModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  final int? statusCode;
  final String? data;
  final String? message;
  final bool? success;

  // Factory constructor to create an instance from JSON
  factory UserProfilePictureUploadModel.fromJson(Map<String, dynamic> json) {
    return UserProfilePictureUploadModel(
      statusCode: json['statusCode'] as int?,
      data: json['data'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data,
      'message': message,
      'success': success,
    };
  }
}
