import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';
import 'package:paraexpert/core/utils/font_styles.dart';
import 'package:paraexpert/features/agora_services/widgets/video_buttons.dart';

class VideoCall extends StatefulWidget {
  final String? callToken;
  final String? userName;
  const VideoCall({super.key, required this.callToken, required this.userName});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  final appID = dotenv.env["APPID"];
  String token = "";
  final channelName = "video";
  late Stopwatch stopwatch;
  late Timer timer;

  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  bool muted = false;
  bool disableCamera = false;

  @override
  void initState() {
    super.initState();
    token = widget.callToken.toString();
    initAgora();
    stopwatch = Stopwatch();

    timer = Timer.periodic(const Duration(milliseconds: 30), (t) {
      setState(() {});
    });
  }

  void handleStopWatch() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
    } else {
      stopwatch.start();
    }
  }

  String returnCallDurationElapsed() {
    var milli = stopwatch.elapsed.inMilliseconds;

    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, "0");
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, "0");

    return "$minutes:$seconds";
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();

    await _engine.initialize(RtcEngineContext(
      appId: appID,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint('local user ${connection.localUid} joined');
          setState(() {
            _localUserJoined = true;
          });
        },
        // Occurs when a remote user join the channel
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          handleStopWatch();
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        // Occurs when a remote user leaves the channel
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.joinChannel(
      token: token.toString(),
      channelId: channelName,
      options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster),
      uid: 0,
    );
  }

  @override
  void dispose() {
    super.dispose();
    handleStopWatch();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 60.h, 10.w, 0),
              child: Container(
                width: 120.w,
                height: 200.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: customWhiteColor,
                ),
                child: Center(
                  child: _localUserJoined
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _engine,
                            canvas: const VideoCanvas(
                              uid: 0,
                            ),
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.w, 60.h, 0, 0),
              child: const VideoButtons(
                category: "back button",
                icon: null,
                svgIcon: "assets/icons/video_back.svg",
              ),
            ),
          ),
          _callEnd(),
          _toolBar()
        ],
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channelName),
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: customBlackColor,
        child: const Text(
          'Please wait...',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _toolBar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding:
          EdgeInsetsDirectional.symmetric(vertical: 30.h, horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "User",
            style: TextStyle(
                fontSize: 14.sp,
                fontFamily: PoppinsFontFamily.regular,
                color: secondaryColor),
          ),
          Text(
            widget.userName.toString(),
            style: TextStyle(
                fontSize: 24.sp,
                fontFamily: PoppinsFontFamily.medium,
                color: secondaryColor),
          ),
          SizedBox(height: 10.h),
          Container(
            height: 50.h,
            width: 100.w,
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(24.r)),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 10.r,
                  height: 10.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  returnCallDurationElapsed(),
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: PoppinsFontFamily.medium,
                      color: secondaryColor),
                ),
              ],
            ),
          ),
          SizedBox(height: 60.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const VideoButtons(
                category: "Chat",
                icon: Iconsax.message,
                svgIcon: "",
              ),
              InkWell(
                onTap: () {
                  _engine.switchCamera();
                },
                child: const VideoButtons(
                  category: "Reverse",
                  icon: null,
                  svgIcon: "assets/icons/video_reverse.svg",
                ),
              ),
              SizedBox(width: 60.r),
              InkWell(
                onTap: () {
                  setState(() {
                    disableCamera = !disableCamera;
                  });
                  if (!disableCamera) {
                    _engine.disableVideo();
                  } else {
                    _engine.enableVideo();
                  }
                },
                child: const VideoButtons(
                  category: "Diable Video",
                  icon: Iconsax.video5,
                  svgIcon: "",
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    muted = !muted;
                  });
                  _engine.muteLocalAudioStream(muted);
                },
                child: const VideoButtons(
                  category: "Disable Audio",
                  icon: Iconsax.microphone_25,
                  svgIcon: "",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _callEnd() {
    return Container(
      alignment: Alignment.topCenter,
      height: 150.h,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: 80.r,
          height: 80.r,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
              border: Border.all(color: customWhiteColor, width: 2.w)),
          child: Icon(
            Icons.call_end,
            color: customWhiteColor,
            size: 40.r,
          ),
        ),
      ),
    );
  }
}

class CallArgs {
  final String? callToken;
  final String? userName;

  const CallArgs({required this.callToken, required this.userName});
}
