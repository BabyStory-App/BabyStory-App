import 'package:babystory/models/milk.dart';
import 'package:flutter/material.dart';

class MilkDiaryItem extends StatelessWidget {
  final Milk milk;

  const MilkDiaryItem({Key? key, required this.milk}) : super(key: key);

  // Helper function to convert milk code to string
  String getMilkType(int milkCode) {
    switch (milkCode) {
      case 0:
        return "모유";
      case 1:
        return "분유";
      default:
        return "기타";
    }
  }

  // Helper function to format date and time
  String formatDateTime(DateTime dateTime) {
    return "${dateTime.year}년 ${dateTime.month.toString().padLeft(2, '0')}월 ${dateTime.day.toString().padLeft(2, '0')}일 "
        "${dateTime.hour.toString().padLeft(2, '0')}시 ${dateTime.minute.toString().padLeft(2, '0')}분";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header with date and time
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.blueAccent),
              const SizedBox(width: 8),
              Text(
                formatDateTime(milk.createTime),
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1),
          // Milk Information Section
          const Text(
            "수유 정보",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.local_drink, color: Colors.pink),
            title: const Text("종류"),
            trailing: Text(getMilkType(milk.milk)),
          ),
          ListTile(
            leading: const Icon(Icons.opacity, color: Colors.blue),
            title: const Text("양"),
            trailing: Text("${milk.amount} ml"),
          ),
        ]),
      ),
    );
  }
}
