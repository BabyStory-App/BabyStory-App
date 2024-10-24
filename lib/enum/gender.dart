enum Gender { male, female, unknown }

List<String> GenderList = Gender.values.map((e) => e.name).toList();

Gender matchGender(int? genderNum) {
  switch (genderNum) {
    case 0:
      return Gender.male;
    case 1:
      return Gender.female;
  }
  return Gender.unknown;
}

String genderToString(Gender gender) {
  switch (gender) {
    case Gender.male:
      return 'male';
    case Gender.female:
      return 'female';
    default:
      return 'unknown';
  }
}

String genderToKorean(Gender gender) {
  switch (gender) {
    case Gender.male:
      return '남성';
    case Gender.female:
      return '여성';
    default:
      return '비공개';
  }
}

List<String> genderKoreanList = ['남성', '여성', '비공개'];

int genderToInt(Gender gender) {
  switch (gender) {
    case Gender.male:
      return 0;
    case Gender.female:
      return 1;
    default:
      return 2;
  }
}
