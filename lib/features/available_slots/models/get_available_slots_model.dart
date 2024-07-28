class AvailabilityResponse {
  final int statusCode;
  final Data data;
  final String message;
  final bool success;

  AvailabilityResponse({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory AvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return AvailabilityResponse(
      statusCode: json['statusCode'],
      data: Data.fromJson(json['data']),
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

class Data {
  final List<Availability> availability;

  Data({required this.availability});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      availability: List<Availability>.from(
        json['availability'].map((item) => Availability.fromJson(item)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availability':
          List<dynamic>.from(availability.map((item) => item.toJson())),
    };
  }
}

class Availability {
  final Slots slots;
  final int day;

  Availability({required this.slots, required this.day});

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      slots: Slots.fromJson(json['slots']),
      day: json['day'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slots': slots.toJson(),
      'day': day,
    };
  }
}

class Slots {
  final List<String> chat;
  final List<String> videoCall;
  final List<String> audioCall;

  Slots({required this.chat, required this.videoCall, required this.audioCall});

  factory Slots.fromJson(Map<String, dynamic> json) {
    return Slots(
      chat: List<String>.from(json['chat']),
      videoCall: List<String>.from(json['video_call']),
      audioCall: List<String>.from(json['audio_call']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat': chat,
      'video_call': videoCall,
      'audio_call': audioCall,
    };
  }
}
