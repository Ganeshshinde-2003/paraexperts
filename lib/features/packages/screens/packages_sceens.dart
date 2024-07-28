import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paraexpert/core/routes/app_routes.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/features/packages/controllers/packages_controller.dart';
import 'package:paraexpert/features/packages/models/all_packages_model.dart';
import 'package:paraexpert/features/packages/widgets/packages_widget.dart';
import 'package:paraexpert/features/packages/widgets/toggle_bar.dart';

class PackagesScreen extends ConsumerStatefulWidget {
  const PackagesScreen({super.key});

  @override
  ConsumerState<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends ConsumerState<PackagesScreen> {
  bool isOnline = true;
  PackageResponse? packageData;
  bool isLoading = true;

  void _handleSwitchChange(bool newValue) {
    setState(() {
      isOnline = newValue;
    });
  }

  @override
  void initState() {
    fetchPackages();
    super.initState();
  }

  void fetchPackages() async {
    setState(() {
      isLoading = true;
    });
    packageData =
        await ref.read(packagesControllerProvider).fetchPackages(context);
    setState(() {
      isLoading = false;
    });
  }

  List<Widget> buildPackageWidgets() {
    if (packageData == null) return [];

    // Filter the packages based on the isOnline flag
    final filteredPackages = packageData!.data.where((package) {
      return (isOnline && package.type == 'online') ||
          (!isOnline && package.type == 'offline');
    }).toList();

    return filteredPackages.isEmpty
        ? [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  SvgPicture.asset(
                    "assets/images/nodata.svg",
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    isOnline ? 'No Online Packages' : 'No Offline Packages',
                    style: TextStyle(
                      fontFamily: InterFontFamily.semiBold,
                      fontSize: 20.sp,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            )
          ]
        : filteredPackages.reversed.map((package) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.packageDetails,
                    arguments: package.id,
                  );
                },
                child: PackagesWidget(
                  title: package.title,
                  description: package.description,
                  price: package.amount.toString(),
                ),
              ),
            );
          }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        leading: IconButton(
          padding: EdgeInsetsDirectional.only(start: 20.w),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.bottomBar,
              (route) => false,
            );
          },
          icon: SvgPicture.asset(
            "assets/icons/back_button.svg",
          ),
        ),
        title: Text(
          "Packages",
          style: TextStyle(
            fontFamily: InterFontFamily.semiBold,
            fontSize: 22.sp,
            color: const Color(0xFF20043C),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              children: [
                OnlineOfflineSwitch(onChanged: _handleSwitchChange),
                SizedBox(height: 10.h),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: buildPackageWidgets(),
                          ),
                        ),
                      ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: const [0.8, 1.0],
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.createPackage);
                },
                child: Container(
                  width: double.infinity,
                  height: 55.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: primaryColor,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Center(
                    child: Text(
                      "Create Package",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontFamily: InterFontFamily.semiBold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
