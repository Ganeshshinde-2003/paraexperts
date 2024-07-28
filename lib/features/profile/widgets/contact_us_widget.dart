import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class ContactUsTile extends StatefulWidget {
  final String imagePath;
  final String headText;
  final String discText;
  final bool isMail;
  final String link;
  final bool isExpanded;
  final VoidCallback onTap;

  const ContactUsTile({
    super.key,
    required this.imagePath,
    required this.headText,
    required this.discText,
    this.isMail = false,
    required this.link,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ContactUsTileState createState() => _ContactUsTileState();
}

class _ContactUsTileState extends State<ContactUsTile> {
  Future<void> _launchMailApp() async {
    Uri uri = Uri.parse("mailto:${widget.link}");

    if (!await launcher.launchUrl(uri)) {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  Future<void> _launchWebSite() async {
    launcher.launchUrl(
      Uri.parse(widget.link),
      mode: launcher.LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.all(12.h),
          decoration: BoxDecoration(
            color: textFieldBackColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: const Color.fromARGB(255, 238, 238, 238),
              width: 1.w,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        widget.imagePath,
                        height: 20.h,
                        width: 20.w,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        widget.headText,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: InterFontFamily.semiBold,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    widget.isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 24.sp,
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: widget.isExpanded
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: [
                            const Divider(color: Colors.grey),
                            GestureDetector(
                              onTap: widget.isMail
                                  ? _launchMailApp
                                  : _launchWebSite,
                              child: Text(
                                widget.discText,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
