import 'package:babystory/models/cry_state.dart';
import 'package:babystory/widgets/listen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CryDetectScreen extends StatefulWidget {
  const CryDetectScreen({super.key});

  @override
  State<CryDetectScreen> createState() => _CryDetectScreenState();
}

class _CryDetectScreenState extends State<CryDetectScreen> {
  CryState? cryState;

  Future<void> alertBabyCry(BuildContext context, CryState cry) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: const Text("울음이 감지됨"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(describeEnum(cry.type)),
                Text(cry.getPredictMap(limit: 2).toString()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(alertContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateBabyState(CryState value) {
    setState(() {
      cryState = value;
      if (cryState != null) {
        print(cryState!.getPredictMap(limit: 2));
        alertBabyCry(context, cryState!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListenWiget(onBabyStateUpdate: _updateBabyState),
        ],
      ),
    );
  }
}
