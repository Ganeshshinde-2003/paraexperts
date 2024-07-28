import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paraexpert/core/resources/data.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/features/profile/widgets/contact_us_widget.dart';
import 'package:paraexpert/features/profile/widgets/faq_widget.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  int _expandedFAQIndex = -1;
  int _expandedContactIndex = -1;

  void _handleFAQTileTap(int index) {
    setState(() {
      _expandedFAQIndex = _expandedFAQIndex == index ? -1 : index;
    });
  }

  void _handleContactTileTap(int index) {
    setState(() {
      _expandedContactIndex = _expandedContactIndex == index ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: primaryColor,
          ),
          backgroundColor: secondaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset("assets/icons/back_button.svg"),
          ),
          title: Text(
            "Help Center",
            style: TextStyle(
              fontFamily: InterFontFamily.semiBold,
              fontSize: 20.sp,
              color: const Color(0xFF20043C),
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelStyle: TextStyle(
              fontFamily: InterFontFamily.semiBold,
              fontSize: 16.sp,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: InterFontFamily.semiBold,
              fontSize: 16.sp,
            ),
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'FAQ'),
              Tab(text: 'Contact Us'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 20.0,
              ),
              itemCount: 7,
              itemBuilder: (context, index) {
                return ExpandableFAQItem(
                  headText: 'Can I access my courses offline',
                  discText:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliquaLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua..',
                  isExpanded: _expandedFAQIndex == index,
                  onTap: () => _handleFAQTileTap(index),
                );
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: ListView.builder(
                itemCount: AppData.contactItems.length,
                itemBuilder: (context, index) {
                  final item = AppData.contactItems[index];
                  return ContactUsTile(
                    imagePath: item['imagePath'],
                    headText: item['headText'],
                    discText: item['discText'],
                    link: item['link'],
                    isMail: item['isMail'],
                    isExpanded: _expandedContactIndex == index,
                    onTap: () => _handleContactTileTap(index),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
