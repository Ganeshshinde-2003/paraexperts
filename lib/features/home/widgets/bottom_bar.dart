import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/features/appointment/screens/appointment_screen.dart';
import 'package:paraexpert/features/booked_packages/screens/booked_packages.dart';
import 'package:paraexpert/features/home/screens/home_screen.dart';
import 'package:paraexpert/features/profile/screens/profile_screen.dart';

class HomeBottomContainer extends StatefulWidget {
  const HomeBottomContainer({super.key});

  @override
  State<HomeBottomContainer> createState() => _HomePageState();
}

class _HomePageState extends State<HomeBottomContainer> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    IconData home = Iconsax.home;
    IconData appointment = Iconsax.book;
    IconData cart = Iconsax.shopping_cart;
    IconData profile = Iconsax.profile_circle;

    List body = const [
      HomeScreen(),
      AppointmentDetailsScreen(),
      BookedPackagesScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        top: false,
        child: body[index],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: customBottomNavColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 15.w,
            vertical: 15.h,
          ),
          child: GNav(
            backgroundColor: customBottomNavColor,
            color: secondaryColor,
            activeColor: secondaryColor,
            tabBackgroundColor: tabBgColor,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            padding: EdgeInsetsDirectional.all(12.r),
            duration: const Duration(microseconds: 100),
            tabs: [
              GButton(
                icon: home,
                onPressed: () {
                  home = Iconsax.home5;
                },
              ),
              GButton(
                icon: appointment,
                onPressed: () {
                  appointment = Iconsax.book5;
                },
              ),
              GButton(
                icon: cart,
                onPressed: () {
                  cart = Iconsax.shopping_cart5;
                },
              ),
              GButton(
                icon: profile,
                onPressed: () {
                  profile = Iconsax.profile_circle5;
                },
              )
            ],
            onTabChange: (value) {
              setState(() {
                index = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
