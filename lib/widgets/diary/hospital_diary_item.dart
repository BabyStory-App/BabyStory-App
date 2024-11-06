import 'package:babystory/models/hospital.dart';
import 'package:flutter/material.dart';

class HostpitalDiaryItem extends StatelessWidget {
  final Hospital hospital;

  const HostpitalDiaryItem({Key? key, required this.hospital})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 6),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: const Border(
            top: BorderSide(
              color: Colors.black12,
              width: 1,
            ),
          ),
        ),
        child: Text(
            "${hospital.createTime.year}년 ${hospital.createTime.month.toString().padLeft(2, '0')}월 ${hospital.createTime.day.toString().padLeft(2, '0')}일",
            textAlign: TextAlign.start,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("산모",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text("몸무게: "),
                  Text(hospital.parentKg.toString()),
                  const Text("kg"),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text("혈압: "),
                  Text(hospital.pressure.toString()),
                ],
              ),
              const SizedBox(height: 4),
              const Text("신생아",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text("몸무게: "),
                  Text(hospital.babyKg.toString()),
                  const Text("kg"),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text("신장: "),
                  Text(hospital.babyCm.toString()),
                  const Text("cm"),
                ],
              ),
              const SizedBox(height: 4),
              const Text("특이사항",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              for (var key in hospital.special!.keys)
                Row(
                  children: [
                    Text("$key: "),
                    Text(hospital.special![key].toString()),
                  ],
                ),
              const SizedBox(height: 4),
              if (hospital.nextDay != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("다음날",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                        "${hospital.nextDay!.year}년 ${hospital.nextDay!.month.toString().padLeft(2, '0')}월 ${hospital.nextDay!.day.toString().padLeft(2, '0')}일"),
                  ],
                )
            ],
          )),
    ]);
  }
}
