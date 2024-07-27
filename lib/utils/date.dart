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
