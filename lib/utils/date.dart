import 'dart:math';

int calculateMonthsUntilBirth(DateTime birthDate) {
  DateTime now = DateTime.now();

  if (now.isBefore(birthDate)) {
    return 0;
  }

  // 년도 차이와 월 차이를 계산
  int yearsDiff = now.year - birthDate.year;
  int monthsDiff = now.month - birthDate.month;

  int totalMonths = (yearsDiff * 12) + monthsDiff;

  if (now.day < birthDate.day) {
    totalMonths--;
  }

  return totalMonths;
}

String timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  Duration difference = now.difference(dateTime);

  // 1시간 이내일 경우 분 단위 반환
  if (difference.inMinutes < 60) {
    return '${difference.inMinutes}분 전';
  }
  // 1일 이내일 경우 시간 단위 반환
  else if (difference.inHours < 24) {
    return '${difference.inHours}시간 전';
  }
  // 1달 이내일 경우 일 단위 반환
  else if (difference.inDays < 30) {
    return '${difference.inDays}일 전';
  }
  // 1달 이상일 경우 달 단위 반환
  else {
    int months = (difference.inDays / 30).floor();
    return '$months달 전';
  }
}

String timeAgoString(String dateTimeString) {
  DateTime inputTime = DateTime.parse(dateTimeString);
  return timeAgo(inputTime);
}

DateTime generateRandomDateTimeWithinOneMonth() {
  final now = DateTime.now();
  final random = Random();

  // 0 ~ 29일 사이의 임의의 값을 생성
  int randomDays = random.nextInt(30);
  // 0 ~ 23시간 사이의 임의의 값을 생성
  int randomHours = random.nextInt(24);
  // 0 ~ 59분 사이의 임의의 값을 생성
  int randomMinutes = random.nextInt(60);
  // 0 ~ 59초 사이의 임의의 값을 생성
  int randomSeconds = random.nextInt(60);

  // 현재 시간에서 랜덤하게 생성된 일, 시간, 분, 초를 빼서 새로운 DateTime을 반환
  return now.subtract(Duration(
    days: randomDays,
    hours: randomHours,
    minutes: randomMinutes,
    seconds: randomSeconds,
  ));
}

String formatDateTime(DateTime dateTime) {
  return '${dateTime.month}월 ${dateTime.day}일, ${dateTime.year}';
}
