import 'package:flutter/material.dart';

class AiDoctorRecommandCardData {
  final String title;
  final String description;
  final Icon icon;
  AiDoctorRecommandCardData({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class AiDoctorRecommandCard extends StatelessWidget {
  final AiDoctorRecommandCardData cardData;

  const AiDoctorRecommandCard({Key? key, required this.cardData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 240, 240, 240),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 230, 230, 230),
                borderRadius: BorderRadius.circular(12),
              ),
              child: cardData.icon,
            ),
            const SizedBox(height: 6),
            Text(cardData.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
            const SizedBox(height: 6),
            Text(cardData.description,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(175, 0, 0, 0),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3),
          ],
        ),
      ),
    );
  }
}
