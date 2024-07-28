import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paraexpert/core/routes/app_routes.dart';
import 'package:paraexpert/features/agora_services/screens/audio_call.dart';
import 'package:paraexpert/features/agora_services/screens/video_call.dart';
import 'package:paraexpert/features/appointment/screens/appointment_details_screen.dart';
import 'package:paraexpert/features/appointment/screens/appointment_screen.dart';
import 'package:paraexpert/features/auth/screens/login_screen.dart';
import 'package:paraexpert/features/auth/screens/verify_otp_screen.dart';
import 'package:paraexpert/features/available_slots/screens/available_slots.dart';
import 'package:paraexpert/features/booked_packages/screens/booked_packages.dart';
import 'package:paraexpert/features/booked_packages/screens/package_details.dart';
import 'package:paraexpert/features/home/screens/home_screen.dart';
import 'package:paraexpert/features/home/widgets/bottom_bar.dart';
import 'package:paraexpert/features/notifications/screens/notification_screen.dart';
import 'package:paraexpert/features/onboarding/screens/mobile_no_screen.dart';
import 'package:paraexpert/features/onboarding/screens/splash_screen.dart';
import 'package:paraexpert/features/packages/screens/create_package.dart';
import 'package:paraexpert/features/packages/screens/edit_package.dart';
import 'package:paraexpert/features/packages/screens/packages_sceens.dart';
import 'package:paraexpert/features/profile/screens/help_center.dart';
import 'package:paraexpert/features/profile/screens/privacy_policy.dart';
import 'package:paraexpert/features/profile/screens/profile_edit.dart';
import 'package:paraexpert/features/profile/screens/profile_screen.dart';

class Routes {
  static const transitionDuration = Duration(milliseconds: 250);

  static Route<dynamic> generateRoute(RouteSettings settings) {
    const transitionType = PageTransitionType.fade;

    Widget page;
    PageTransitionType type = transitionType;

    switch (settings.name) {
      case AppRoutes.splash:
        page = const SplashScreen();
        break;
      case AppRoutes.mobileNoScreen:
        page = const MobileNoScreen();
        break;
      case AppRoutes.auth:
        page = const LoginScreen();
        break;
      case AppRoutes.verifyOtp:
        final args = settings.arguments as Map<String, String>;
        page = VerifyOTPScreen(
          userPhone: args['userPhone']!,
          requestId: args['requestId']!,
        );
        break;
      case AppRoutes.home:
        page = const HomeScreen();
        break;
      case AppRoutes.bottomBar:
        page = const HomeBottomContainer();
        break;
      case AppRoutes.appointments:
        page = const AppointmentDetailsScreen();
        break;
      case AppRoutes.bookingIdDetails:
        final args = settings.arguments as String;
        page = AppointmentDetailsPage(bookingID: args);
        break;
      case AppRoutes.videoCall:
        final args = settings.arguments as CallArgs;
        page = VideoCall(
          callToken: args.callToken,
          userName: args.userName,
        );
        break;
      case AppRoutes.audioCall:
        final args = settings.arguments as CallArgs;
        page = AudioCall(callToken: args.callToken, userName: args.userName);
        break;
      case AppRoutes.notification:
        page = const NotificationScreen();
        break;
      case AppRoutes.availableSlots:
        page = const AvailableSlotsScreen();
        break;
      case AppRoutes.packages:
        page = const PackagesScreen();
        break;
      case AppRoutes.createPackage:
        page = const CreatePackageScreen();
        break;
      case AppRoutes.packageDetails:
        final args = settings.arguments as String;
        page = EditPackageScreen(packageId: args);
        break;
      case AppRoutes.profile:
        page = const ProfileScreen();
        break;
      case AppRoutes.privacyPolicy:
        page = const PrivacyPolicyScreen();
        break;
      case AppRoutes.helpCenter:
        page = const HelpCenterScreen();
        break;
      case AppRoutes.editProfile:
        page = const ProfileEditScreen();
        break;
      case AppRoutes.pacakgeBookedDetails:
        final args = settings.arguments as Map<String, String>;
        page = PackageDetailsScreen(
          bookingId: args['bookingId']!,
          packageId: args['packageId']!,
        );
        break;
      case AppRoutes.bookedPackages:
        page = const BookedPackagesScreen();
        break;
      default:
        page = const Scaffold(
          body: Center(child: Text("No route found!")),
        );
        break;
    }
    return PageTransition(
      child: page,
      type: type,
      duration: transitionDuration,
      settings: settings,
    );
  }
}
