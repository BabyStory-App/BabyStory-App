import 'package:babystory/apis/baby_api.dart';
import 'package:babystory/apis/cry_api.dart';
import 'package:babystory/models/baby.dart';
import 'package:babystory/models/cry_state.dart';
import 'package:babystory/screens/cry_list.dart';
import 'package:babystory/utils/color.dart';
import 'package:babystory/widgets/cry_page_navigate_widget.dart';
import 'package:flutter/material.dart';
import 'package:d_chart/commons/config_render.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/commons/decorator.dart';
import 'package:d_chart/commons/enums.dart';
import 'package:d_chart/commons/style.dart';
import 'package:d_chart/numeric/combo.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:d_chart/ordinal/pie.dart';
import 'package:d_chart/time/line.dart';

class CryInspectMain extends StatefulWidget {
  final Baby selectedBaby;
  final Map<String, dynamic> inspectData;

  const CryInspectMain({
    super.key,
    required this.selectedBaby,
    required this.inspectData,
  });

  @override
  State<CryInspectMain> createState() => _CryInspectMainState();
}

class _CryInspectMainState extends State<CryInspectMain> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CryListScreen(baby: widget.selectedBaby),
                    ),
                  ),
              child: const CryPageNavigateWidget()),
          const SizedBox(height: 40),
          chart1(widget.inspectData["cry_freq_hour"].cast<int>()),
          const SizedBox(height: 52),
          chart2(
            widget.inspectData["cry_freq_date"]['date'].cast<String>(),
            widget.inspectData["cry_freq_date"]['freqs'].cast<int>(),
          ),
          const SizedBox(height: 52),
          chart3(widget.inspectData["type_freq"]),
          const SizedBox(height: 52),
          chart4(
            widget.inspectData["duration_of_type"]["type"].cast<String>(),
            widget.inspectData["duration_of_type"]["duration"].cast<double>(),
          ),
          const SizedBox(height: 52),
        ],
      ),
    );
  }

  Text description(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
    );
  }

  Text title(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: ColorProps.textBlack),
    );
  }

  Column chart1(List<int> cryFreqHours) {
    int maxIdx = 0;
    for (int i = 0; i < cryFreqHours.length; i++) {
      if (cryFreqHours[i] > cryFreqHours[maxIdx]) {
        maxIdx = i;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title('아기는 ${maxIdx + 1}시에 주로 울어요!'),
        const SizedBox(height: 10),
        SizedBox(height: 176, child: _chart1(cryFreqHours)),
        const SizedBox(height: 10),
        description(
            '최근 한달 간 아기는 ${maxIdx + 1}시에 ${cryFreqHours[maxIdx]}번 울었어요.'),
        const SizedBox(height: 2),
        description('너무 늦은 시간에 아기가 많이 울면 아기가 져녁을 먹는 시간을 조금 늦추는 것도 좋아요.'),
      ],
    );
  }

  Widget _chart1(List<int> cryFreqHours) {
    var timeList = List.generate(
        cryFreqHours.length,
        (index) =>
            NumericData(domain: index + 1, measure: cryFreqHours[index]));

    final numericGroup = [
      NumericGroup(
        id: '1',
        chartType: ChartType.bar,
        data: timeList,
        color: ColorProps.bgBlue,
      ),
      NumericGroup(
        id: '2',
        chartType: ChartType.line,
        data: timeList,
        color: Colors.purple,
      ),
      NumericGroup(
        id: '3',
        chartType: ChartType.scatterPlot,
        data: timeList,
        color: Colors.red,
      ),
    ];

    return AspectRatio(
      aspectRatio: 16 / 8,
      child: DChartComboN(
        animate: true,
        animationDuration: const Duration(milliseconds: 500),
        configRenderLine: ConfigRenderLine(
          includeArea: true,
          includePoints: true,
          radiusPx: 2.5,
          areaOpacity: 0.05,
          strokeWidthPx: 1,
        ),
        groupList: numericGroup,
      ),
    );
  }

  Column chart2(List<String> dates, List<int> freqs) {
    double mean = 0;
    int cryCount = 0, leftSum = 0, rightSum = 0, halfIdx = freqs.length ~/ 2;
    for (int i = 0; i < freqs.length; i++) {
      cryCount += freqs[i];
      if (i < halfIdx) {
        leftSum += freqs[i];
      } else {
        rightSum += freqs[i];
      }
    }
    mean = cryCount / freqs.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title('아기는 하루에 ${mean.toInt()}번에서 ${mean.toInt() + 1}번 울어요!'),
        const SizedBox(height: 10),
        SizedBox(height: 176, child: _chart2(dates, freqs)),
        const SizedBox(height: 10),
        description(
            '최근 한달 간 아기는 총 ${cryCount}번 울었어요. 하루에 ${mean.toInt()}번에서 ${mean.toInt() + 1}번 정도 울어요.'),
        const SizedBox(height: 2),
        description(
            '조금씩이기는 하나 시간이 지날수록 아기가 더 ${leftSum > rightSum ? '많이' : '적게'} 울고 있어요.'),
        const SizedBox(height: 2),
        description(
            '그만큼 아기가 점점 더 ${leftSum > rightSum ? '건강' : '의젓'}해지고 있다는 뜻이에요.'),
      ],
    );
  }

  Widget _chart2(List<String> dates, List<int> freqs) {
    var timeList = List.generate(
        dates.length,
        (index) => TimeData(
            domain: DateTime.parse(dates[index]), measure: freqs[index]));

    return AspectRatio(
      aspectRatio: 16 / 8,
      child: DChartLineT(
        animate: true,
        animationDuration: const Duration(milliseconds: 500),
        configRenderLine: ConfigRenderLine(
          includeArea: true,
          includePoints: true,
          radiusPx: 2.5,
          areaOpacity: 0.05,
          strokeWidthPx: 1,
        ),
        groupList: [
          TimeGroup(
            id: '3',
            chartType: ChartType.scatterPlot,
            data: timeList,
            color: Colors.orange,
          )
        ],
      ),
    );
  }

  Column chart3(Map<String, dynamic> typeFreq) {
    var typeFreqKeys = typeFreq.keys.toList();
    typeFreqKeys = List.generate(
        typeFreqKeys.length, (i) => getStrCryTypeKorean(typeFreqKeys[i]));
    var typeFreqValues = typeFreq.values.toList().cast<int>();
    int maxIdx = typeFreqKeys.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title('아기는 ${descOfCryType(typeFreqKeys[maxIdx])} 많이 울어요!'),
        const SizedBox(height: 10),
        SizedBox(height: 176, child: _chart3(typeFreqKeys, typeFreqValues)),
        const SizedBox(height: 16),
        description(
            '최근 한달 간 아기는 ${descOfCryType(typeFreqKeys[maxIdx])} ${typeFreqValues[maxIdx]}번으로 가장 많이 울었어요.'),
        const SizedBox(height: 2),
        description(
            '반대로 아기가 ${descOfCryType(typeFreqKeys[0])}는 ${typeFreqValues[0]}번으로 가장 적게 울었어요.'),
      ],
    );
  }

  Widget _chart3(List<String> typeFreqKeys, List<int> typeFreqValues) {
    var colorList = [
      Colors.blue[300],
      Colors.amber[300],
      Colors.purple[300],
      Colors.pink[300],
      Colors.green[300],
      Colors.red[300],
      Colors.orange[300],
    ];

    var ordinalDataList = List.generate(
        typeFreqKeys.length,
        (index) => OrdinalData(
            domain: typeFreqKeys[index],
            measure: typeFreqValues[index],
            color: colorList[index]));

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: DChartPieO(
        data: ordinalDataList,
        animate: true,
        animationDuration: const Duration(milliseconds: 500),
        customLabel: (ordinalData, index) => ordinalData.domain,
        configRenderPie: ConfigRenderPie(
          arcRatio: 1,
          strokeWidthPx: 0.5,
          arcLabelDecorator: ArcLabelDecorator(
              leaderLineStyle: const ArcLabelLeaderLineStyle(
                color: Colors.transparent,
                length: 8.0,
                thickness: 0.1,
              ),
              labelPosition: ArcLabelPosition.outside,
              outsideLabelStyle: const LabelStyle(
                color: Colors.black,
                fontSize: 14,
              )),
        ),
      ),
    );
  }

  Column chart4(List<String> types, List<double> durations) {
    int maxIdx = types.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title('아기는 ${descOfCryType(types[maxIdx])} 가장 길게 울어요.'),
        const SizedBox(height: 10),
        SizedBox(height: 176, child: _chart4(types, durations)),
        const SizedBox(height: 10),
        description(
            '최근 한달 간 아기는 ${descOfCryType(types[maxIdx])} 평균 ${durations[maxIdx]}분으로 가장 길게 울었어요.'),
        const SizedBox(height: 2),
        description(
            '반대로 아기가 ${descOfCryType(types[0])}는 평균 ${durations[0]}분으로 가장 짧게 울었어요.'),
      ],
    );
  }

  Widget _chart4(List<String> types, List<double> durations) {
    var colorList = [
      Colors.blue[300],
      Colors.amber[300],
      Colors.purple[300],
      Colors.pink[300],
      Colors.green[300],
      Colors.red[300],
      Colors.orange[300],
    ];

    var ordinalList = List.generate(
        types.length,
        (index) => OrdinalData(
            domain: getStrCryTypeKorean(types[index]),
            measure: durations[index],
            color: colorList[index]));

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: DChartBarO(
        vertical: false,
        flipVertical: true,
        animate: true,
        animationDuration: const Duration(milliseconds: 800),
        fillColor: (group, ordinalData, index) => ordinalData.color,
        groupList: [
          OrdinalGroup(
            id: '1',
            data: ordinalList,
          )
        ],
      ),
    );
  }

  String descOfCryType(String type) {
    switch (type) {
      case 'sad':
        return "슬플 때";
      case 'hug':
        return "안아주어야 할 때";
      case 'diaper':
        return "기저귀를 갈아주어야 할 때";
      case 'hungry':
        return "배고플 때";
      case 'sleepy':
        return "졸릴 때";
      case 'awake':
        return "막 잠에서 깨어났을 때";
      case 'uncomfortable':
      default:
        return "몸이 불편할 때";
    }
  }
}
