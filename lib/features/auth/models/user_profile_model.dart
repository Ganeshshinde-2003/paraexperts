class UserResponseModel {
  final int statusCode;
  final UserData data;
  final String message;
  final bool success;

  UserResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      statusCode: json['statusCode'],
      data: UserData.fromJson(json['data']),
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

class UserData {
  final Consultancy consultancy;
  final Socials socials;
  final String id;
  final UserId userId;
  final List<String> expertise;
  final double ratings;
  final String bio;
  final String basedOn;
  final List<Qualification> qualifications;
  final List<String> reviews;
  final int experience;

  UserData({
    required this.consultancy,
    required this.socials,
    required this.id,
    required this.userId,
    required this.expertise,
    required this.ratings,
    required this.bio,
    required this.basedOn,
    required this.qualifications,
    required this.reviews,
    required this.experience,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      consultancy: Consultancy.fromJson(json['consultancy']),
      socials: Socials.fromJson(json['socials']),
      id: json['_id'],
      userId: UserId.fromJson(json['userId']),
      expertise: List<String>.from(json['expertise']),
      ratings: json['ratings'].toDouble(),
      bio: json['bio'],
      basedOn: json['basedOn'],
      qualifications: (json['qualifications'] as List)
          .map((i) => Qualification.fromJson(i))
          .toList(),
      reviews: List<String>.from(json['reviews']),
      experience: json['experience'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consultancy': consultancy.toJson(),
      'socials': socials.toJson(),
      '_id': id,
      'userId': userId.toJson(),
      'expertise': expertise,
      'ratings': ratings,
      'bio': bio,
      'basedOn': basedOn,
      'qualifications': qualifications.map((i) => i.toJson()).toList(),
      'reviews': reviews,
      'experience': experience,
    };
  }
}

class Consultancy {
  final int audioCallPrice;
  final int videoCallPrice;
  final int messagingPrice;

  Consultancy({
    required this.audioCallPrice,
    required this.videoCallPrice,
    required this.messagingPrice,
  });

  factory Consultancy.fromJson(Map<String, dynamic> json) {
    return Consultancy(
      audioCallPrice: json['audio_call_price'],
      videoCallPrice: json['video_call_price'],
      messagingPrice: json['messaging_price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'audio_call_price': audioCallPrice,
      'video_call_price': videoCallPrice,
      'messaging_price': messagingPrice,
    };
  }
}

class Socials {
  final String instagram;
  final String twitter;
  final String linkedIn;

  Socials({
    required this.instagram,
    required this.twitter,
    required this.linkedIn,
  });

  factory Socials.fromJson(Map<String, dynamic> json) {
    return Socials(
      instagram: json['instagram'],
      twitter: json['twitter'],
      linkedIn: json['linkedIn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'instagram': instagram,
      'twitter': twitter,
      'linkedIn': linkedIn,
    };
  }
}

class UserId {
  final String id;
  final String phone;
  final String gender;
  final String name;
  final String profilePicture;
  final String email;
  final List<String> interests;
  final String dateOfBirth;

  UserId({
    required this.id,
    required this.phone,
    required this.gender,
    required this.name,
    required this.profilePicture,
    required this.email,
    required this.dateOfBirth,
    required this.interests,
  });

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      id: json['_id'],
      phone: json['phone'],
      gender: json['gender'],
      name: json['name'],
      profilePicture: json['profilePicture'],
      email: json['email'],
      interests: List<String>.from(json['interests']),
      dateOfBirth: json['dateOfBirth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'phone': phone,
      'gender': gender,
      'name': name,
      'profilePicture': profilePicture,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'interests': interests,
    };
  }
}

class Qualification {
  final String title;
  final List<String> certificateUrls;
  final String id;

  Qualification({
    required this.title,
    required this.certificateUrls,
    required this.id,
  });

  factory Qualification.fromJson(Map<String, dynamic> json) {
    return Qualification(
      title: json['title'],
      certificateUrls: List<String>.from(json['certificateUrls']),
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'certificateUrls': certificateUrls,
      '_id': id,
    };
  }
}
