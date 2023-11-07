enum CryIntensity { low, medium, high }

enum CryType { hunger, pain, diaper, sleep }

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
