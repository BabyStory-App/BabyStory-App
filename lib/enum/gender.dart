enum Gender { male, female, unknown }

List<String> GenderList = Gender.values.map((e) => e.name).toList();

Gender matchGender(int genderNum) {
  switch (genderNum) {
    case 0:
      return Gender.male;
    case 1:
      return Gender.female;
  }
  return Gender.unknown;
}
