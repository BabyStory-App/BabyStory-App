import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/audio_processor.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/cry_result.dart';
import 'package:babystory/utils/color.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/utils/os.dart';
import 'package:babystory/widgets/circle_hollow_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:babystory/models/cry_state.dart';
import 'package:provider/provider.dart';

enum ListenState {
  init,
  listening,
  silence,
  crying,
  analysing,
  done,
}

class CryDetectScreen extends StatefulWidget {
  const CryDetectScreen({super.key});

  @override
  State<CryDetectScreen> createState() => _CryDetectWidgetState();
}

class _CryDetectWidgetState extends State<CryDetectScreen>
    with TickerProviderStateMixin {
  final HttpUtils httpUtils = HttpUtils();
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  late SvgPicture mainSvg;
  late ListenState listenState;
  late Parent parent;

  late AudioProcessor _audioProcessor;
  bool isListening = false;

  Parent getParentFromProvider() {
    final parent = context.read<ParentProvider>().parent;
    if (parent == null) {
      throw Exception('Parent is null');
    }
    return parent;
  }

  @override
  void initState() {
    super.initState();
    parent = getParentFromProvider();

    listenState = ListenState.init;
    mainSvg = SvgPicture.asset('assets/icons/sound_wave-color.svg');

    _rotationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.05).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.fastOutSlowIn),
    )..addListener(() {
        setState(() {});
      });

    _audioProcessor = AudioProcessor(
      isListening: () => isListening,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  String getMainSvgPath(ListenState state) {
    String fileState = 'smile';
    switch (state) {
      case ListenState.init:
        return 'assets/icons/sound_wave-color.svg';
      case ListenState.listening:
        break;
      case ListenState.silence:
        fileState = 'sleepy';
        break;
      case ListenState.crying:
        fileState = 'uncomfortable';
        break;
      case ListenState.analysing:
        return 'assets/icons/sound_analyzing-color.svg';
      case ListenState.done:
        return 'assets/icons/check_circle-color.svg';
    }
    return 'assets/icons/baby-$fileState-white.svg';
  }

  String getTitle(ListenState state) {
    switch (state) {
      case ListenState.init:
        return '터치하여 시작하기!';
      case ListenState.listening:
        return '아이의 소리에 귀를 기울이고 있어요';
      case ListenState.silence:
        return '아기가 자고 있어요';
      case ListenState.crying:
        return '아이가 울고 있어요!!';
      case ListenState.analysing:
        return '아이의 울음 원인 분석 중!';
      case ListenState.done:
        return '분석 완료!';
    }
  }

  void setListenStateWithRef(ListenState toListenState) {
    _scaleController.forward().then((_) {
      setState(() {
        listenState = toListenState;
        isListening = toListenState == ListenState.listening;
        mainSvg = SvgPicture.asset(getMainSvgPath(listenState));
      });
      _scaleController.reverse().then((_) {
        _bounceController.forward().then((_) {
          _bounceController.reverse();
        });
      });
    });
  }

  void toggleListening() {
    listenState == ListenState.init ? startListening() : endListening();
  }

  void startListening() {
    debugPrint("Start listening");
    setListenStateWithRef(ListenState.listening);
    _audioProcessor.waitForSoundAndAnalyze(
      onAnalysisStarted: () {
        setListenStateWithRef(ListenState.analysing);
        _rotationController.repeat();
      },
      onAnalysisComplete: onAnalysisComplete,
    );
  }

  void onAnalysisComplete(String filePath) async {
    // Check if the file exists
    debugPrint("Send to server with file $filePath");
    if (OsUtils.isFileExist(filePath) == false) {
      throw OSError('Audio file $filePath not exist');
    }

    // Send the file to the server and get predictState
    var json = await httpUtils.postMultipart(
        url: '/cry/predict',
        headers: {'Authorization': 'Bearer ${parent.jwt ?? ''}'},
        filePath: filePath);
    if (json == null) {
      return;
    }
    CryState predictState = CryState.fromJson(json);

    // Stop the rotation and update the state
    setListenStateWithRef(ListenState.done);
    _rotationController.stop();

    // move page after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      setListenStateWithRef(ListenState.init);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CryResultScreen(cryState: predictState),
          ));
    });
  }

  void endListening() {
    setListenStateWithRef(ListenState.init);
    _rotationController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        color: ColorProps.orangeYellow,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getTitle(listenState),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              AvatarGlow(
                animate: [ListenState.listening, ListenState.crying]
                    .contains(listenState),
                endRadius: 160.0,
                glowColor: Colors.red.shade400,
                duration: const Duration(milliseconds: 2000),
                curve: Curves.easeInOut,
                child: GestureDetector(
                  onTap: toggleListening,
                  child: Material(
                    shape: const CircleBorder(),
                    elevation: 8,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      height: 150,
                      width: 150,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(255, 199, 110, 0.851),
                      ),
                      child: Transform.scale(
                        scale: _scaleAnimation.value * _bounceAnimation.value,
                        child: mainSvg,
                      ),
                    ),
                  ),
                ),
              ),
              if (listenState == ListenState.analysing)
                RotationTransition(
                  turns: _rotationController,
                  child: CustomPaint(
                    painter: CircleHollowPainter(),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 60),
        ],
      ),
    ));
  }
}
