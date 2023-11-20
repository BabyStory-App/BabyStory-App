import 'package:babystory/models/cry_state.dart';
import 'package:babystory/utils/color.dart';
import 'package:flutter/material.dart';

class CryResultWidget extends StatefulWidget {
  final CryState cryState;

  const CryResultWidget({super.key, required this.cryState});

  @override
  State<CryResultWidget> createState() => _CryResultWidgetState();
}

class _CryResultWidgetState extends State<CryResultWidget> {
  late DetailInfoRender info;
  bool isInit = false;

  Future<void> initDetailInfoRender() async {
    setState(() {
      info = DetailInfoRender(cryState: widget.cryState);
      isInit = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initDetailInfoRender();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(widget.cryState.getType()));
  }
}

class DetailInfoRender {
  CryState cryState;
  final DetailInfoKR _detailInfoLang = DetailInfoKR();
  late DetailInfo _info;

  DetailInfoRender({required this.cryState}) {
    _info = _detailInfoLang.getDetailInfo(cryState.getType());
    _info.updatePredictionMap(cryState.predictMap);
  }

  DetailInfo get raw => _info;

  Column renderDescription() {
    List<Widget> renderList = [];
    var wordList = _info.description.split('\n');
    for (var word in wordList) {
      if (word == '') {
        renderList.add(const SizedBox(height: 12));
      } else {
        if (word.contains('**')) {
          var richWords = word.split('**');
          List<TextSpan> richRendderList = [];
          for (var i = 0; i < richWords.length; i++) {
            if (i % 2 == 0) {
              richRendderList.add(TextSpan(
                  text: richWords[i],
                  style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(47, 199, 117, 0.99))));
            } else {
              richRendderList.add(TextSpan(
                  text: richWords[i],
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(57, 141, 147, 1))));
            }
          }
          renderList.add(Text.rich(TextSpan(children: richRendderList)));
        } else {
          renderList.add(Text(word,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(47, 199, 117, 0.99),
              )));
        }
        renderList.add(const SizedBox(height: 12));
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: renderList,
    );
  }

  Image renderImage() {
    return Image.asset(_info.iconPath);
  }

  SizedBox renderPredictionInfo(double width, String state) {
    List<String> keys = cryState.predictMap.keys.toList();
    double p1 = cryState.predictMap[keys[0]]!;
    double p2 = cryState.predictMap[keys[1]]!;

    return SizedBox(
      width: width * 0.82,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(keys[0],
                  style: const TextStyle(
                    fontSize: 17,
                  )),
              const SizedBox(height: 4),
              Text(keys[1],
                  style: const TextStyle(
                    fontSize: 17,
                  )),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Column(
            children: [
              Row(
                children: [
                  Text('${(p1 * 100).round()}%'),
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
                  Text('${(p2 * 100).round()}%'),
                  const SizedBox(width: 7),
                  Container(
                    height: 15,
                    width: width *
                        (state.toLowerCase() == 'uncomfortable' ? 0.32 : 0.5) *
                        p2,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(255, 239, 199, 1),
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

  Row renderPredictBar({
    required double width,
    required double percent,
    Color color = const Color.fromRGBO(222, 252, 185, 1),
  }) {
    if (percent > 1) {
      throw "percent in renderPredictBar must be less than 1";
    }
    return Row(
      children: [
        Container(
          height: 18,
          width: width * percent,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(3.0),
              bottomLeft: Radius.circular(3.0),
            ),
          ),
        ),
        Container(
          height: 18,
          // width: width * (1 - percent),
          width: 1,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(217, 217, 217, 0.5),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(3.0),
              bottomRight: Radius.circular(3.0),
            ),
          ),
        ),
        Text('${(percent * 100).round()}%'),
      ],
    );
  }

  Widget renderIconDesc() {
    List<String> descList = _info.iconDesc.split('\n');

    List<Widget> textList = [];
    for (var desc in descList) {
      textList.add(Text(desc,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          )));
      textList.add(const SizedBox(height: 5));
    }
    return Row(
      children: [
        const SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: textList,
        ),
      ],
    );
  }
}

class DetailInfoKR {
  @override
  DetailInfo diaperInfo = DetailInfo(
      state: 'Diaper',
      predictionMap: {},
      iconPath: 'assets/icons/diaper.png',
      iconTitle: '새 기저귀가 필요해요!',
      iconDesc: '아기가 불안해 보이는\n표정을 짓거나 졸린듯\n눈을 게슴츠레\n뜨고 있지는 않나요?',
      description:
          '아기가 우는 주요한\n원인 중 하나는 아기 **기저귀의 상태**가\n좋지 않을 때에요!\n기저귀가 **젖어** 불편하다는 신호입니다.\n\n아기가 쾌적함을 느낄 수 있게 **기저귀를** \n **갈아주는 것**을 추천합니다.\n\n추가적으로 아기의 **용변 상태**와\n기저귀 **발진**이 생기지 않았는지 확인해주세요.');

  @override
  DetailInfo hungryInfo = DetailInfo(
      state: 'Hungry',
      predictionMap: {},
      iconPath: 'assets/icons/hungry.png',
      iconTitle: '배가 고파요!',
      iconDesc: '아기 입 주변에\n검지를 갖다 대보세요.\n혹시 고개를 돌려\n손을 보거나, 손을\n빠는 시늉을 하나요?',
      description:
          '그렇다면 아기는\n배가 고플 확률이 높으니\n **수유**를 하거나 **우유**를 주세요!\n\n추가적으로 평소 아기가\n **밥**을 먹는 **주기**를 확인해주세요!\n\n아기가 밥 먹는 시간을 알려주는 **알람**을\n설정해 보는 건 어떨까요?');

  @override
  DetailInfo awakeInfo = DetailInfo(
      state: 'Awake',
      predictionMap: {},
      iconPath: 'assets/icons/awake.png',
      iconTitle: '방금 일어났어요!',
      iconDesc: '아기는 스스로의\n움직임에 깜짝 놀라\n잠에서 깨어 울기도 해요.',
      description:
          '아기가 방금 깨어났어요!\n아기를 잘 **다독여** 주시고,\n\n 아기가 안정감을 느낄 수 있도록\n **싸개**로 아기를 포근하게 감싸주세요.\n\n아기를 편안하게 해주는 **음악**을\n들려주는 것은 어떨까요?');

  @override
  DetailInfo hugInfo = DetailInfo(
      state: 'Hug',
      predictionMap: {},
      iconPath: 'assets/icons/hug.png',
      iconTitle: '안아주세요!',
      iconDesc: '아기가 눈물없이\n크게 울고 있나요?',
      description:
          '그렇다면 아기는 더 **안아달라**는 의미이거나\n놀고 싶다는 투정일 수 있어요!\n아기가 부모님과의 **교감**을\n원하는 상태입니다.\n\n아기를 안아 토닥여주거나\n아기와 **눈맞춤**을 하고 놀아주세요.\n아기와의 **애착형성**에 도움이 된답니다!');

  @override
  DetailInfo sadInfo = DetailInfo(
      state: 'Sad',
      predictionMap: {},
      iconPath: 'assets/icons/sad.png',
      iconTitle: '슬퍼요!',
      iconDesc: '혹시 아기가 뚜렷한\n원인 없이 막 우나요?',
      description:
          '먼저 아기의 **체온**이나 **몸 상태**를 체크해보세요.\n가기가 열이 있나요?\n그렇다면 가까운 병원을 안내해드릴게요.\n\n그런게 아니라 아기가 **온몸**에 힘이 들어가\n얼굴이 **붉어지거나**,\n몸 가까이 **주먹**을 쥐며\n배에 힘을 주고 있다면\n **영아 산통**을 의심해 볼 수 있어요!');

  @override
  DetailInfo sleepyInfo = DetailInfo(
      state: 'Sleepy',
      predictionMap: {},
      iconPath: 'assets/icons/sleepy.png',
      iconTitle: '졸려요!',
      iconDesc: '아기가 손을 눈에\n가져가거나\n계속 눈을 깜빡이나요?',
      description:
          '그렇다면 아기가\n **잠**이 온다는 의미에요.\n\n아기가 잘 잘 수 있도록\n주변을 **조용하게** 만들어주세요.\n\n아래의 버튼을 누르면 아기의 수면에\n도움이 되는 **노래**를 제공해 드릴게요.');

  @override
  DetailInfo uncomfortableInfo = DetailInfo(
      state: 'Uncomfortable',
      predictionMap: {},
      iconPath: 'assets/icons/uncomfortable.png',
      iconTitle: '불편해요!',
      iconDesc: '아기의 체온과 행동을\n확인해 보셨나요?',
      description:
          '아기에게 열도 없고, 배도 딱딱하지 않다면\n아기가 **성장통**을 겪고 있을 수 있어요!\n아기의 다리를 부드럽게 **마사지**해주세요.\n\n또는 아기의 주변 환경이 \n맞지 않는 경우일 수 있으니 \n **온도**와 **습도**를 확인해주세요.\n아기가 느끼기에 방 안 온도는\n **24~26도**, 습도는 **50~60%**가 \n가장 적당하다고 해요!');

  DetailInfo getDetailInfo(String state) {
    switch (state.toLowerCase()) {
      case 'diaper':
        return diaperInfo;
      case 'hungry':
        return hungryInfo;
      case 'awake':
        return awakeInfo;
      case 'hug':
        return hugInfo;
      case 'sad':
        return sadInfo;
      case 'sleepy':
        return sleepyInfo;
      case 'uncomfortable':
        return uncomfortableInfo;
      default:
        throw "Unknown type of baby state";
    }
  }
}

class DetailInfo {
  String state;
  Map<String, double> predictionMap;
  String iconPath;
  String iconDesc;
  String iconTitle;
  String description;

  DetailInfo({
    required this.state,
    this.predictionMap = const {'': 0, ' ': 0},
    required this.iconPath,
    required this.iconDesc,
    required this.iconTitle,
    required this.description,
  });

  void updatePredictionMap(Map<String, double> predictMap) =>
      predictionMap = predictMap;
}
