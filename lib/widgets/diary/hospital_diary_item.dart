import 'package:babystory/models/hospital.dart';
import 'package:flutter/material.dart';

class HospitalDiaryItem extends StatelessWidget {
  final Hospital hospital;

  const HospitalDiaryItem({Key? key, required this.hospital}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Helper function to format dates
    String formatDate(DateTime date) {
      return "${date.year}년 ${date.month.toString().padLeft(2, '0')}월 ${date.day.toString().padLeft(2, '0')}일";
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Date Header
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.blueAccent),
              const SizedBox(width: 8),
              Text(
                formatDate(hospital.createTime),
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1),
          // Mother Section
          const Text(
            "산모",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading:
                const Icon(Icons.monitor_weight_outlined, color: Colors.pink),
            title: const Text("몸무게"),
            trailing: Text("${hospital.parentKg} kg"),
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: const Text("혈압"),
            trailing: Text(hospital.pressure.toString()),
          ),
          const Divider(height: 24, thickness: 1),
          // Newborn Section
          const Text(
            "신생아",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading:
                const Icon(Icons.monitor_weight_outlined, color: Colors.blue),
            title: const Text("몸무게"),
            trailing: Text("${hospital.babyKg} kg"),
          ),
          ListTile(
            leading: const Icon(Icons.height, color: Colors.green),
            title: const Text("신장"),
            trailing: Text("${hospital.babyCm} cm"),
          ),
          const Divider(height: 24, thickness: 1),
          // Special Notes Section
          if (hospital.special != null && hospital.special!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "특이사항",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...hospital.special!.entries.map((entry) => ListTile(
                      leading: const Icon(Icons.notes, color: Colors.orange),
                      title: Text(entry.key),
                      subtitle: Text(entry.value.toString()),
                    )),
                const Divider(height: 24, thickness: 1),
              ],
            ),
          // Next Appointment Section
          if (hospital.nextDay != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "다음날",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.calendar_today_outlined,
                      color: Colors.blue),
                  title: Text(formatDate(hospital.nextDay!)),
                ),
              ],
            )
        ]),
      ),
    );
  }
}
