enum CryType { sad, hug, diaper, hungry, sleepy, awake, uncomfortable }

List<String> CryTypeList = CryType.values.map((e) => e.name).toList();

List<String> CryTypeKoreanList = ['슬픔', '허그', '기저귀', '배고픔', '졸림', '깨어남', '불편함'];

List<String> CryTypeDescKoreanList = [
  '슬퍼요',
  '안아주세요',
  '기저귀를 갈아주세요',
  '배고파요',
  '졸려요',
  '깨어났어요',
  '불편해요'
];

String getCryTypeKorean(CryType type, {bool desc = false}) {
  if (desc) {
    return CryTypeDescKoreanList[CryTypeList.indexOf(type.name)];
  }
  return CryTypeKoreanList[CryTypeList.indexOf(type.name)];
}

String getStrCryTypeKorean(String type, {bool desc = false}) {
  print('type: $type');
  if (desc) {
    return CryTypeDescKoreanList[CryTypeList.indexOf(type.toLowerCase())];
  }
  return CryTypeKoreanList[CryTypeList.indexOf(type.toLowerCase())];
}

CryType getCryTypeFromString(String type) {
  switch (type) {
    case 'sad':
      return CryType.sad;
    case 'hug':
      return CryType.hug;
    case 'diaper':
      return CryType.diaper;
    case 'hungry':
      return CryType.hungry;
    case 'sleepy':
      return CryType.sleepy;
    case 'awake':
      return CryType.awake;
    case 'uncomfortable':
      return CryType.uncomfortable;
    default:
      return CryType.uncomfortable;
  }
}

Map<String, double> getCryTypeFromStateMap(Map<String, double> stateMap) {
  Map<String, double> tempPredictMap = {};
  var keys = stateMap.keys.toList();

  while (keys.isNotEmpty) {
    String maxKey = keys[0];
    for (var key in keys) {
      if (stateMap[key]! > stateMap[maxKey]!) {
        maxKey = key;
      }
    }
    tempPredictMap[maxKey] = stateMap[maxKey]!.toDouble();
    stateMap.remove(maxKey);
    keys.remove(maxKey);
  }
  return tempPredictMap;
}
