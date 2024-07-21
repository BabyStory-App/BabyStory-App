enum CryIntensity { low, medium, high }

List<String> CryIntensityList = CryIntensity.values.map((e) => e.name).toList();
List<String> CryIntensityKoreanList = ['약함', '보통', '강함'];

CryIntensity matchIntensity(int intensityNum) {
  switch (intensityNum) {
    case 0:
      return CryIntensity.low;
    case 1:
      return CryIntensity.medium;
    case 2:
      return CryIntensity.high;
  }
  return CryIntensity.medium;
}

String getCryIntensityKorean(CryIntensity intensity) {
  return CryIntensityKoreanList[CryIntensityList.indexOf(intensity.name)];
}

CryIntensity getCryIntensityFromString(String intensity) {
  switch (intensity) {
    case 'low':
      return CryIntensity.low;
    case 'medium':
      return CryIntensity.medium;
    case 'high':
      return CryIntensity.high;
    default:
      return CryIntensity.medium;
  }
}
