enum CryIntensity { low, medium, high }

List<String> CryIntensityList = CryIntensity.values.map((e) => e.name).toList();

enum CryType { hunger, pain, diaper, sleep }

List<String> CryTypeList = CryType.values.map((e) => e.name).toList();

class CryState {
  DateTime time;
  CryType type;
  CryIntensity intensity;
  String audioURL;

  double? duration;

  CryState({
    required this.time,
    required this.type,
    required this.intensity,
    required this.audioURL,
    this.duration,
  });
}
