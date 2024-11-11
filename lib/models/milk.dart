class Milk {
  final int id;
  final int diaryId;
  final String babyId;
  final int milk;
  final int amount;
  final DateTime createTime;

  Milk({
    required this.id,
    required this.diaryId,
    required this.babyId,
    required this.milk,
    required this.amount,
    required this.createTime,
  });

  factory Milk.fromJson(Map<String, dynamic> json) {
    return Milk(
      id: json['milk_id'],
      diaryId: json['diary_id'],
      babyId: json['baby_id'],
      milk: json['milk'],
      amount: json['amount'],
      createTime: DateTime.parse(json['mtime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'milk_id': id,
      'diary_id': diaryId,
      'baby_id': babyId,
      'milk': milk,
      'amount': amount,
      'mtime': createTime.toIso8601String(),
    };
  }

  void printInfo() {
    print(
        "\n\tid: $id\n\tdiaryId: $diaryId\n\tbabyId: $babyId\n\tmilk: $milk\n\tamount: $amount\n\tcreateTime: $createTime");
  }
}
