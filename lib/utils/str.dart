class Str {
  static List<String> splitFromRight(String s, String pattern, int count) {
    List<String> reversedParts = s.split('').reversed.join().split(pattern);
    if (reversedParts.length > count) {
      reversedParts = reversedParts.sublist(0, count);
    }
    return reversedParts.reversed
        .map((part) => part.split('').reversed.join())
        .toList();
  }
}
