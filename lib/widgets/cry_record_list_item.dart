import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/models/cry_state.dart';
import 'package:babystory/utils/color.dart';
import 'package:babystory/widgets/expandsion_tile_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

class CryRecordListItem extends StatefulWidget {
  final CryState cryState;
  late bool initiallyExpanded;

  CryRecordListItem(
      {super.key, required this.cryState, this.initiallyExpanded = false});

  @override
  State<CryRecordListItem> createState() => _CryRecordListItemState();
}

class _CryRecordListItemState extends State<CryRecordListItem> {
  DateFormat bannerDateFormat = DateFormat("yyyy-MM-dd");
  DateFormat detailDateFormat = DateFormat("yyyy년 MM월 dd일 HH시 mm분 ss초");
  final AudioPlayer player = AudioPlayer();

  bool isplaying = false;
  bool isLoading = true;

  @override
  void initState() {
    initAudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> initAudioPlayer() async {
    var filePath = await RawsApi.getCry(widget.cryState.audioURL);
    try {
      await player.setFilePath(filePath);
    } catch (e) {
      try {
        await player.setAsset('assets/samples/test.wav');
      } catch (e) {
        print(e);
      }
    }
    await player.setLoopMode(LoopMode.one);
    await player.pause();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _tooglePlay() async {
    setState(() {
      isLoading = false;
      isplaying = !isplaying;
    });
    if (isplaying) {
      await player.play();
    } else {
      await player.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ExpansionTileCard(
        initiallyExpanded: widget.initiallyExpanded,
        baseColor: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        key: GlobalKey(),
        leading: CircleAvatar(
            radius: 24,
            backgroundColor: ColorProps.bgBlue,
            child: Image.asset(
              'assets/icons/${widget.cryState.getType()}.png',
              width: 36,
              height: 36,
            )),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(getCryTypeKorean(widget.cryState.type, desc: true),
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
        ]),
        subtitle: Text(bannerDateFormat.format(widget.cryState.time),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
        children: <Widget>[
          const Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(detailDateFormat.format(widget.cryState.time),
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            _intensityAndTimeWidget(widget.cryState.intensity,
                                widget.cryState.duration),
                          ],
                        ),
                      ),
                      Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            onPressed: () {
                              _tooglePlay();
                            },
                            icon: isLoading
                                ? const Icon(Icons.arrow_circle_down_rounded)
                                : isplaying
                                    ? const Icon(Icons.pause_rounded)
                                    : const Icon(Icons.play_arrow_rounded),
                            color: Colors.white,
                            iconSize: 24,
                          )),
                      const SizedBox(width: 3),
                    ],
                  ),
                  const SizedBox(height: 16),
                  renderPredictionInfo(widget.cryState, 250),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _intensityAndTimeWidget(CryIntensity intensity, double? cryTime) {
    cryTime = cryTime ?? 2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text("울음 강도:",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        const SizedBox(width: 3),
        Text(getCryIntensityKorean(intensity),
            style: TextStyle(
              fontSize: 12,
              fontWeight: intensity == CryIntensity.high
                  ? FontWeight.bold
                  : FontWeight.w400,
              color: intensity == CryIntensity.low
                  ? Colors.blue
                  : intensity == CryIntensity.medium
                      ? Colors.orange[700]
                      : Colors.red,
            )),
        const SizedBox(width: 8),
        const Text('][',
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: ColorProps.gray)),
        const SizedBox(width: 8),
        const Text("울음 시간:",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        const SizedBox(width: 3),
        Text("${cryTime.toStringAsFixed(1)}초",
            style: TextStyle(
              fontSize: 12,
              fontWeight: cryTime > 11 ? FontWeight.bold : FontWeight.w400,
              color: cryTime < 6
                  ? Colors.blue
                  : cryTime < 11
                      ? Colors.orange[700]
                      : Colors.red,
            )),
      ],
    );
  }

  SizedBox renderPredictionInfo(CryState cryState, double width) {
    List<String> keys = cryState.predictMap.keys.toList();
    double p1 = cryState.predictMap[keys[0]]!;
    double p2 = cryState.predictMap[keys[1]]!;
    double p3 = cryState.predictMap[keys[2]]!;
    String state = cryState.getType();

    return SizedBox(
      width: width * 0.82,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getStrCryTypeKorean(keys[0]),
                  style: const TextStyle(
                    fontSize: 13,
                  )),
              const SizedBox(height: 13),
              Text(getStrCryTypeKorean(keys[1]),
                  style: const TextStyle(
                    fontSize: 13,
                  )),
              const SizedBox(height: 13),
              Text(getStrCryTypeKorean(keys[2]),
                  style: const TextStyle(
                    fontSize: 13,
                  )),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                      width: 30,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Text('${(p1 * 100).round()}%')])),
                  const SizedBox(width: 7),
                  Container(
                    height: 15,
                    width: width *
                        (state.toLowerCase() == 'uncomfortable' ? 0.32 : 0.5) *
                        p1,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(222, 252, 185, 1),
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 15,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(217, 217, 217, 0.5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(3.0),
                          bottomRight: Radius.circular(3.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                      width: 30,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Text('${(p2 * 100).round()}%')])),
                  const SizedBox(width: 7),
                  Container(
                    height: 15,
                    width: width *
                        (state.toLowerCase() == 'uncomfortable' ? 0.32 : 0.5) *
                        p2,
                    decoration: const BoxDecoration(
                      color: ColorProps.bgBrown,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 15,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(217, 217, 217, 0.5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(3.0),
                          bottomRight: Radius.circular(3.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                      width: 30,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Text('${(p3 * 100).round()}%')])),
                  const SizedBox(width: 7),
                  Container(
                    height: 15,
                    width: width *
                        (state.toLowerCase() == 'uncomfortable' ? 0.32 : 0.5) *
                        p3,
                    decoration: const BoxDecoration(
                      color: ColorProps.bgPink,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 15,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(217, 217, 217, 0.5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(3.0),
                          bottomRight: Radius.circular(3.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }
}
