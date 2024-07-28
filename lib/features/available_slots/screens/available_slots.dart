import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/features/available_slots/controller/available_slots_controller.dart';
import 'package:paraexpert/features/available_slots/models/get_available_slots_model.dart';

class AvailableSlotsScreen extends ConsumerStatefulWidget {
  const AvailableSlotsScreen({super.key});

  @override
  ConsumerState<AvailableSlotsScreen> createState() =>
      _AvailableSlotsScreenState();
}

class _AvailableSlotsScreenState extends ConsumerState<AvailableSlotsScreen> {
  bool isLoading = false;
  bool isFetching = true;
  AvailabilityResponse? availableSlots;
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final List<Map<String, dynamic>> selectedSlots = List.generate(
    7,
    (index) => {
      'day': index,
      'slots': {
        'chat': [],
        'video_call': [],
        'audio_call': [],
      },
    },
  );

  List<String> timeSlots = [];

  String selectedSlotType = 'chat';

  @override
  void initState() {
    super.initState();
    getAvailableSlots();
    timeSlots = List.generate(
      17,
      (index) => formatTime(index + 6),
    );
  }

  void getAvailableSlots() async {
    setState(() {
      isFetching = true;
    });
    availableSlots = await ref
        .read(availableSlotsControllerProvider)
        .getAvailableSlots(context);

    if (availableSlots != null &&
        availableSlots!.data.availability.isNotEmpty) {
      for (var dayData in availableSlots!.data.availability) {
        selectedSlots[dayData.day]['slots']['chat'] =
            dayData.slots.chat.map((slot) => formatTimeTo12Hour(slot)).toList();
        selectedSlots[dayData.day]['slots']['video_call'] = dayData
            .slots.videoCall
            .map((slot) => formatTimeTo12Hour(slot))
            .toList();
        selectedSlots[dayData.day]['slots']['audio_call'] = dayData
            .slots.audioCall
            .map((slot) => formatTimeTo12Hour(slot))
            .toList();
      }
      setState(() {
        isFetching = false;
      });
    }
  }

  String formatTime(int hour) {
    final int hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final String period = hour < 12 ? 'AM' : 'PM';
    return '${hour12.toString().padLeft(2, '0')}:00 $period';
  }

  String formatTimeTo12Hour(String time) {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    final int hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final String period = hour < 12 ? 'AM' : 'PM';
    return '${hour12.toString().padLeft(2, '0')}:00 $period';
  }

  void onTimeSlotTap(int dayIndex, int timeSlotIndex) {
    setState(() {
      String timeSlot = timeSlots[timeSlotIndex];
      List<dynamic> slots = selectedSlots[dayIndex]['slots'][selectedSlotType]!;
      bool isSelected = slots.contains(timeSlot);

      if (isSelected) {
        slots.remove(timeSlot);
      } else {
        bool isSelectedInOtherTypes = selectedSlots[dayIndex]['slots']
            .values
            .any((typeSlots) =>
                typeSlots.contains(timeSlot) &&
                typeSlots !=
                    selectedSlots[dayIndex]['slots'][selectedSlotType]);

        if (!isSelectedInOtherTypes) {
          slots.add(timeSlot);
        }
      }
    });
  }

  void setSlots() {
    List<Map<String, dynamic>> selectedSlots24 = List.generate(
      selectedSlots.length,
      (dayIndex) {
        List<dynamic> chatSlots = selectedSlots[dayIndex]['slots']['chat']
            .map((slot) => convertTo24Hour(slot))
            .toList();
        List<dynamic> videoCallSlots = selectedSlots[dayIndex]['slots']
                ['video_call']
            .map((slot) => convertTo24Hour(slot))
            .toList();
        List<dynamic> audioCallSlots = selectedSlots[dayIndex]['slots']
                ['audio_call']
            .map((slot) => convertTo24Hour(slot))
            .toList();

        return {
          'day': dayIndex,
          'slots': {
            'chat': chatSlots,
            'video_call': videoCallSlots,
            'audio_call': audioCallSlots,
          },
        };
      },
    );

    setSlotsStore(selectedSlots24);
  }

  void setSlotsStore(List<Map<String, dynamic>> slots) async {
    setState(() {
      isLoading = true;
    });
    await ref
        .read(availableSlotsControllerProvider)
        .setAvailableSlots(context, slots);
    setState(() {
      isLoading = false;
    });
  }

  String convertTo24Hour(String time) {
    List<String> parts = time.split(' ');
    String hourMinute = parts[0];
    String period = parts[1];
    List<String> hourMinuteParts = hourMinute.split(':');
    int hour = int.parse(hourMinuteParts[0]);
    int minute = int.parse(hourMinuteParts[1]);

    if (period == 'PM' && hour < 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  int getCurrentDayIndex() {
    int currentDay = DateTime.now().weekday;
    return currentDay - 1;
  }

  Widget buildTimeSlots(int dayIndex) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 2.5,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        String slot = timeSlots[index];

        bool isSelectedInChat =
            selectedSlots[dayIndex]['slots']['chat'].contains(slot);
        bool isSelectedInVideoCall =
            selectedSlots[dayIndex]['slots']['video_call'].contains(slot);
        bool isSelectedInAudioCall =
            selectedSlots[dayIndex]['slots']['audio_call'].contains(slot);

        return GestureDetector(
          onTap: () => onTimeSlotTap(dayIndex, index),
          child: Container(
            decoration: BoxDecoration(
              color: selectedSlots[dayIndex]['slots'][selectedSlotType]!
                      .contains(slot)
                  ? primaryColor
                  : isSelectedInVideoCall && selectedSlotType != 'video_call'
                      ? Colors.grey.withOpacity(0.5)
                      : isSelectedInAudioCall &&
                              selectedSlotType != 'audio_call'
                          ? Colors.grey.withOpacity(0.5)
                          : isSelectedInChat && selectedSlotType != 'chat'
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: primaryColor,
                width: 1.0,
              ),
            ),
            child: Center(
              child: Text(
                slot,
                style: TextStyle(
                  color: selectedSlots[dayIndex]['slots'][selectedSlotType]!
                          .contains(slot)
                      ? Colors.white
                      : primaryColor,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: daysOfWeek.length,
      initialIndex: getCurrentDayIndex(),
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: primaryColor),
          backgroundColor: secondaryColor,
          leading: IconButton(
            padding: EdgeInsetsDirectional.only(start: 20.w),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              "assets/icons/back_button.svg",
            ),
          ),
          title: Text(
            "Slots",
            style: TextStyle(
              fontFamily: InterFontFamily.semiBold,
              fontSize: 22.sp,
              color: const Color(0xFF20043C),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: primaryColor, width: 1.0),
                ),
                child: DropdownButton<String>(
                  value: selectedSlotType,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: primaryColor,
                  ),
                  iconSize: 18,
                  elevation: 1,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedSlotType = newValue;
                      });
                    }
                  },
                  items: <String>['chat', 'video_call', 'audio_call']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 16,
                            color: primaryColor,
                            fontFamily: InterFontFamily.semiBold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: TabBar(
              isScrollable: true,
              tabs: daysOfWeek.map((day) => Tab(text: day)).toList(),
            ),
          ),
        ),
        body: isFetching
            ? const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : TabBarView(
                children: List.generate(
                  daysOfWeek.length,
                  (dayIndex) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: buildTimeSlots(dayIndex),
                  ),
                ),
              ),
        bottomNavigationBar: BottomAppBar(
          color: secondaryColor,
          child: GestureDetector(
            onTap: setSlots,
            child: Container(
              width: double.infinity,
              height: 56.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: primaryColor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Set Slots",
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
    );
  }
}
