// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:paraexpert/core/routes/app_routes.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/core/utils/on_will_pop_up.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Item> items = [
    Item(name: 'Slots', routeName: AppRoutes.availableSlots),
    Item(name: 'Packages', routeName: AppRoutes.packages),
  ];

  Future<void> _handleRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: primaryColor,
      animSpeedFactor: 4.0,
      springAnimationDurationInMilliseconds: 700,
      height: 130,
      showChildOpacityTransition: false,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () =>
              ConfirmExitDialog.showExitConfirmationDialog(context),
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarColor: primaryColor),
                    expandedHeight: MediaQuery.of(context).size.height * 0.1,
                    automaticallyImplyLeading: false,
                    backgroundColor: secondaryColor,
                    scrolledUnderElevation: 0.0,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      centerTitle: true,
                      background: Padding(
                        padding: EdgeInsetsDirectional.only(top: 20.h),
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsetsDirectional.symmetric(
                                horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.notification,
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 40.r,
                                        height: 40.r,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: primaryColor,
                                        ),
                                        child: const Icon(
                                          Iconsax.notification4,
                                          color: customWhiteColor,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          width: 10.r,
                                          height: 10.r,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.red.withOpacity(0.6),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.15),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    height: 47.r,
                                    child: TextFormField(
                                      onTap: () {
                                        // Navigator.pushNamed(
                                        //     context, AppRoutes.searchQuery);
                                      },
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                          15.w,
                                          15.h,
                                          25.w,
                                          15.h,
                                        ),
                                        prefixIcon: SizedBox(
                                          child: SvgPicture.asset(
                                            "assets/icons/search.svg",
                                            colorFilter: const ColorFilter.mode(
                                                primaryColor,
                                                BlendMode.modulate),
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                        hintText:
                                            "Search for what you want guidance for",
                                        hintStyle: TextStyle(
                                          fontFamily: InterFontFamily.regular,
                                          fontSize: 12.sp,
                                          color: tertiaryColor.withOpacity(0.5),
                                        ),
                                        fillColor: secondaryColor,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.r),
                                          borderSide: const BorderSide(
                                            color: primaryColor,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.r),
                                          borderSide: const BorderSide(
                                            color: primaryColor,
                                          ),
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () {},
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                end: 4.w),
                                            child: Container(
                                              height: 40.r,
                                              width: 40.r,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primaryColor,
                                              ),
                                              child: SvgPicture.asset(
                                                "assets/icons/category.svg",
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  secondaryColor,
                                                  BlendMode.srcIn,
                                                ),
                                                fit: BoxFit.scaleDown,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ];
              },
              body: ListView(
                padding: EdgeInsetsDirectional.only(top: 10.h),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(12.r)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12.r)),
                          child: SvgPicture.asset(
                            "assets/images/bannerimage.svg",
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 2,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, items[index].routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: primaryColor,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: Text(
                                  items[index].name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 18.sp,
                                    fontFamily: InterFontFamily.semiBold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Item {
  final String name;
  final String routeName;

  Item({required this.name, required this.routeName});
}
