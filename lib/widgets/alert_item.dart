import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/models/alert.dart';
import 'package:flutter/material.dart';

class AlertItem extends StatelessWidget {
  final AlertMsg alertMsg;

  const AlertItem({Key? key, required this.alertMsg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      RawsApi.getProfileLink(alertMsg.creater.photoId),
                    )),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alertMsg.message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        )),
                    Text(alertMsg.creater.nickname,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black45,
                        )),
                  ],
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.black45, size: 16)
          ],
        ),
      ),
    );
  }
}
