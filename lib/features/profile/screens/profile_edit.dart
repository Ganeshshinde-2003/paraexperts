// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:paraexpert/core/resources/data.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/core/utils/shared_pref.dart';
import 'package:paraexpert/core/utils/show_snack_bar.dart';
import 'package:paraexpert/features/auth/controller/auth_controller.dart';
import 'package:paraexpert/features/auth/models/user_profile_model.dart';
import 'package:paraexpert/features/profile/controller/profile_controller.dart';
import 'package:paraexpert/features/profile/models/profile_upload_model.dart';
import 'package:paraexpert/features/profile/widgets/call_type_prize.dart';
import 'package:paraexpert/features/profile/widgets/common_textfield.dart';
import 'package:paraexpert/features/profile/widgets/social_media.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  UserResponseModel? userResponseModel;
  UserProfilePictureUploadModel? userProfilePictureUploadModel;
  File? profileImage;
  bool isLoading = false;
  bool isQualificationLoading = false;
  String dob = "dd/mm/yyyy";

  //user variable
  String name = "";
  String bio = "";
  String basedOn = "";
  String phoneNo = "";
  String email = "";
  String gender = "";
  String experience = "";
  String uploadedProfilePicURL = "";
  String dateOfBirth = DateTime.now().toString();

  final TextEditingController audioCallPrice = TextEditingController();
  final TextEditingController videoCallPrice = TextEditingController();
  final TextEditingController chatPrice = TextEditingController();

  final TextEditingController instagramController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController linkedInController = TextEditingController();

  List<String> expertise = [];
  final TextEditingController expertiseController = TextEditingController();

  List<String> interest = [];
  final TextEditingController interestController = TextEditingController();

  List<String> reviews = [];

  double ratings = 0.0;

  final TextEditingController qualificationTitleController =
      TextEditingController();
  File? qualificationCertificate;
  List<Map<String, Object>> localQualifications = [];

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  void fetchUserData() async {
    StoreInLocal storeInLocal = StoreInLocal();
    userResponseModel = await storeInLocal.getUserResponse();
    if (userResponseModel != null) {
      setState(() {
        name = userResponseModel!.data.userId.name;
        bio = userResponseModel!.data.bio;
        basedOn = userResponseModel!.data.basedOn;
        dateOfBirth = userResponseModel!.data.userId.dateOfBirth;
        if (dateOfBirth.isNotEmpty) {
          DateTime parsedDate = DateTime.parse(dateOfBirth);
          dob = DateFormat('dd/MM/yyyy').format(parsedDate);
        } else {
          dob = "dd/mm/yyyy";
        }
        phoneNo = userResponseModel!.data.userId.phone;
        email = userResponseModel!.data.userId.email;
        gender = userResponseModel!.data.userId.gender;
        uploadedProfilePicURL = userResponseModel!.data.userId.profilePicture;

        audioCallPrice.text =
            userResponseModel!.data.consultancy.audioCallPrice.toString();
        videoCallPrice.text =
            userResponseModel!.data.consultancy.videoCallPrice.toString();
        chatPrice.text =
            userResponseModel!.data.consultancy.messagingPrice.toString();

        instagramController.text = userResponseModel!.data.socials.instagram;
        twitterController.text = userResponseModel!.data.socials.twitter;
        linkedInController.text = userResponseModel!.data.socials.linkedIn;

        expertise = List<String>.from(userResponseModel!.data.expertise);

        reviews = List<String>.from(userResponseModel!.data.reviews);

        experience = userResponseModel!.data.experience.toString();

        interest = userResponseModel!.data.userId.interests;

        ratings = userResponseModel!.data.ratings;

        localQualifications = userResponseModel!.data.qualifications.map((q) {
          return {
            'title': q.title,
            'certificateUrls': q.certificateUrls,
          };
        }).toList();
      });
    }
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      profileImage = imageTemporary;

      userProfilePictureUploadModel = await ref
          .read(profileControllerProvider)
          .uploadProfileImage(context, profileImage);

      uploadedProfilePicURL = userProfilePictureUploadModel!.data!;
      setState(() {});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future pickQualificationCertificate() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        qualificationCertificate = imageTemporary;
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void addQualification() async {
    setState(() {
      isQualificationLoading = true;
    });
    final title = qualificationTitleController.text.trim();
    if (title.isNotEmpty && qualificationCertificate != null) {
      UserProfilePictureUploadModel? data = await ref
          .read(profileControllerProvider)
          .uploadQualificationImage(context, qualificationCertificate);

      setState(() {
        localQualifications.add(
          {
            'title': title,
            'certificateUrls': [data!.data],
          },
        );
        qualificationTitleController.clear();
        qualificationCertificate = null;
      });

      setState(() {
        isQualificationLoading = false;
      });
    } else {
      setState(() {
        isQualificationLoading = false;
      });
      showSnackBar(
        context: context,
        content: "Please enter a title and select a certificate.",
      );
    }
  }

  void deleteQualification(int index) {
    setState(() {
      localQualifications.removeAt(index);
    });
  }

  void addExpertise() {
    final newExpertise = expertiseController.text.trim();
    if (newExpertise.isNotEmpty && !expertise.contains(newExpertise)) {
      setState(() {
        expertise.add(newExpertise);
        expertiseController.clear();
      });
    }
  }

  void addInterests() {
    final newInterest = interestController.text.trim();
    if (newInterest.isNotEmpty && !interest.contains(newInterest)) {
      setState(() {
        interest.add(newInterest);
        interestController.clear();
      });
    }
  }

  void removeExpertise(int index) {
    setState(() {
      expertise.removeAt(index);
    });
  }

  void removeInterest(int index) {
    setState(() {
      interest.removeAt(index);
    });
  }

  void updateUserProfile() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> updatedProfile = {
      "name": name,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "interests": interest,
      "phone": phoneNo,
      "profilePicture": uploadedProfilePicURL,
      "email": email,
      "expertise": expertise,
      "ratings": ratings,
      "bio": bio,
      "basedOn": basedOn,
      "qualifications": localQualifications,
      "experience": int.parse(experience),
      "consultancy": {
        "audio_call_price": int.parse(audioCallPrice.text),
        "video_call_price": int.parse(videoCallPrice.text),
        "messaging_price": int.parse(chatPrice.text),
      },
      "socials": {
        "instagram": instagramController.text,
        "twitter": twitterController.text,
        "linkedIn": linkedInController.text,
      }
    };

    await ref
        .read(authControllerProvider)
        .updateParaProfile(context, updatedProfile);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              "assets/icons/back_button.svg",
            ),
          ),
          title: Text(
            "Profile",
            style: TextStyle(
              fontFamily: InterFontFamily.semiBold,
              fontSize: 22.sp,
              color: const Color(0xFF20043C),
            ),
          ),
          centerTitle: true,
        ),
        body: userResponseModel == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 100.w,
                              height: 100.w,
                              child: ClipOval(
                                child: profileImage != null
                                    ? Image.file(
                                        profileImage!,
                                        width: 100.w,
                                        height: 100.w,
                                        fit: BoxFit.cover,
                                      )
                                    : uploadedProfilePicURL.isNotEmpty
                                        ? Image.network(
                                            uploadedProfilePicURL,
                                            width: 100.w,
                                            height: 100.w,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            AppData.userDefaultImage,
                                            width: 100.w,
                                            height: 100.w,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: pickImage,
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/icons/edit.png',
                                    width: 35.w,
                                    height: 35.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25.h),
                      CommonTextField(
                        title: "Name",
                        hintText: "Kapil Sharma",
                        value: name,
                        onUpdate: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                      SizedBox(height: 15.h),
                      CommonTextField(
                        title: "Bio",
                        hintText: "Enter Bio",
                        isTextField: true,
                        value: bio,
                        onUpdate: (value) {
                          setState(() {
                            bio = value;
                          });
                        },
                      ),
                      SizedBox(height: 15.h),
                      CommonTextField(
                        title: "DOB",
                        hintText: dob,
                        isDate: true,
                        onUpdate: (value) {
                          setState(() {
                            dateOfBirth = value;
                          });
                        },
                      ),
                      SizedBox(height: 15.h),
                      CommonTextField(
                        title: "Phone no",
                        hintText: "000 000 0000",
                        isPhone: true,
                        canEdit: false,
                        value: phoneNo,
                        onUpdate: (value) {
                          setState(() {
                            phoneNo = value;
                          });
                        },
                      ),
                      SizedBox(height: 15.h),
                      CommonTextField(
                        title: "Based on",
                        hintText: "Enter your location",
                        value: basedOn,
                        onUpdate: (value) {
                          setState(() {
                            basedOn = value;
                          });
                        },
                      ),
                      SizedBox(height: 15.h),
                      CommonTextField(
                        title: "Experience",
                        hintText: "Enter your experience in years",
                        value: experience,
                        onUpdate: (value) {
                          setState(() {
                            experience = value;
                          });
                        },
                      ),
                      SizedBox(height: 15.h),
                      CommonTextField(
                        title: "Email",
                        hintText: "e-mail address",
                        value: email,
                        onUpdate: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      SizedBox(height: 15.h),
                      CommonTextField(
                        title: "Gender",
                        hintText: gender,
                        isGender: true,
                        onUpdate: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      SizedBox(height: 15.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Consultancy",
                              style: TextStyle(
                                fontFamily: InterFontFamily.medium,
                                fontSize: 15.sp,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            NumberInputRow(
                              title: "Audio Call",
                              controller: audioCallPrice,
                            ),
                            SizedBox(height: 5.h),
                            NumberInputRow(
                              title: "Video Call",
                              controller: videoCallPrice,
                            ),
                            SizedBox(height: 5.h),
                            NumberInputRow(
                              title: "Chat",
                              controller: chatPrice,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Socials",
                              style: TextStyle(
                                fontFamily: InterFontFamily.medium,
                                fontSize: 15.sp,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            SocialMediaInputRow(
                              title: "Instagram",
                              icon: Iconsax.instagram,
                              controller: instagramController,
                            ),
                            SizedBox(height: 5.h),
                            SocialMediaInputRow(
                              title: "Twitter",
                              icon: FontAwesomeIcons.xTwitter,
                              controller: twitterController,
                            ),
                            SizedBox(height: 5.h),
                            SocialMediaInputRow(
                              title: "LinkedIn",
                              icon: FontAwesomeIcons.linkedinIn,
                              controller: linkedInController,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Expertise",
                              style: TextStyle(
                                fontFamily: InterFontFamily.medium,
                                fontSize: 15.sp,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xffF8F0FF),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: expertiseController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Enter expertise",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.sp,
                                          fontFamily: InterFontFamily.regular,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                      ),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey,
                                        fontFamily: InterFontFamily.medium,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: addExpertise,
                                  child: Container(
                                    width: 70.w,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.h, horizontal: 10.w),
                                    decoration: const BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "Add",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: InterFontFamily.semiBold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: List<Widget>.generate(expertise.length,
                                  (index) {
                                return Chip(
                                  backgroundColor: textFieldBackColor,
                                  side: BorderSide(
                                    color: primaryColor,
                                    width: 1.w,
                                  ),
                                  label: Text(expertise[index]),
                                  deleteIcon: Icon(Iconsax.trash, size: 18.sp),
                                  onDeleted: () => removeExpertise(index),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Interests",
                              style: TextStyle(
                                fontFamily: InterFontFamily.medium,
                                fontSize: 15.sp,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xffF8F0FF),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: interestController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Enter interest",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.sp,
                                          fontFamily: InterFontFamily.regular,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                      ),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey,
                                        fontFamily: InterFontFamily.medium,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: addInterests,
                                  child: Container(
                                    width: 70.w,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.h, horizontal: 10.w),
                                    decoration: const BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "Add",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: InterFontFamily.semiBold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: List<Widget>.generate(interest.length,
                                  (index) {
                                return Chip(
                                  backgroundColor: textFieldBackColor,
                                  side: BorderSide(
                                    color: primaryColor,
                                    width: 1.w,
                                  ),
                                  label: Text(interest[index]),
                                  deleteIcon: Icon(Iconsax.trash, size: 18.sp),
                                  onDeleted: () => removeInterest(index),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                "Reviews",
                                style: TextStyle(
                                  fontFamily: InterFontFamily.medium,
                                  fontSize: 15.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Wrap(
                              spacing: 10.w,
                              runSpacing: 10.h,
                              children: reviews
                                  .map(
                                    (review) => Chip(
                                      label: Text(review),
                                      backgroundColor: textFieldBackColor,
                                      side: BorderSide(
                                        color: primaryColor,
                                        width: 1.w,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(height: 15.h),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 15),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         "Rating",
                      //         style: TextStyle(
                      //           fontFamily: InterFontFamily.medium,
                      //           fontSize: 15.sp,
                      //           color: Colors.black,
                      //         ),
                      //       ),
                      //       SizedBox(height: 5.h),
                      //       RatingDisplay(
                      //         rating: ratings,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 15.h),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 15.w, bottom: 10.h),
                              child: Text(
                                "Qualifications",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontFamily: InterFontFamily.semiBold,
                                  color: const Color(0xFF393939),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF8F0FF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    controller: qualificationTitleController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter qualification title",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14.sp,
                                        fontFamily: InterFontFamily.regular,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Colors.grey,
                                      fontFamily: InterFontFamily.medium,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: pickQualificationCertificate,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h, horizontal: 10.w),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            qualificationCertificate != null
                                                ? "Certificate selected"
                                                : "Upload Certificate",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.white,
                                              fontFamily:
                                                  InterFontFamily.medium,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    InkWell(
                                      onTap: addQualification,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h, horizontal: 10.w),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: isQualificationLoading
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : Text(
                                                  "Add Certificate",
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.white,
                                                    fontFamily:
                                                        InterFontFamily.medium,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                localQualifications.isEmpty
                                    ? const Text("No qualifications available.")
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: localQualifications.length,
                                        itemBuilder: (context, index) {
                                          final qualification =
                                              localQualifications[index];
                                          return Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10.h),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      qualification['title']
                                                          as String,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            InterFontFamily
                                                                .medium,
                                                        fontSize: 14.sp,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    (qualification['certificateUrls']
                                                                as List)
                                                            .isNotEmpty
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              _showImagePopup(
                                                                context,
                                                                (qualification[
                                                                        'certificateUrls']
                                                                    as List<
                                                                        String?>)[0]!,
                                                              );
                                                            },
                                                            child: SizedBox(
                                                              width: 100.w,
                                                              height: 100.w,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7.r),
                                                                child: Image
                                                                    .network(
                                                                  (qualification[
                                                                          'certificateUrls']
                                                                      as List<
                                                                          String?>)[0]!,
                                                                  width: 100.w,
                                                                  height: 100.w,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : const Text(
                                                            "No certificate available.",
                                                          ),
                                                  ],
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                      Iconsax.trash,
                                                      color: primaryColor),
                                                  onPressed: () =>
                                                      deleteQualification(
                                                          index),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.w, 0, 10.w, 5.h),
          child: InkWell(
            onTap: updateUserProfile,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(30.r),
                ),
              ),
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        "Update Profile",
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: secondaryColor,
                          fontFamily: InterFontFamily.semiBold,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePopup(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: FutureBuilder(
            future: _getImage(imageUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                );
              }
            },
          ),
        );
      },
    );
  }

  Future<ImageProvider> _getImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    return MemoryImage(response.bodyBytes);
  }
}
