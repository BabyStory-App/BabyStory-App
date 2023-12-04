import 'package:babystory/models/cry_state.dart';
import 'package:babystory/widgets/cry_record_list_item.dart';
import 'package:flutter/material.dart';

class CryRecordList extends StatefulWidget {
  final List<CryState> cryStates;

  const CryRecordList({
    super.key,
    required this.cryStates,
  });

  @override
  State<CryRecordList> createState() => _CryRecordScrollViewState();
}

class _CryRecordScrollViewState extends State<CryRecordList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.cryStates.length,
      separatorBuilder: (BuildContext separatorContext, int separatorIndex) =>
          const SizedBox(height: 12),
      itemBuilder: (BuildContext itemContext, int itemIndex) {
        var renderIndex = widget.cryStates.length - itemIndex - 1;
        return CryRecordListItem(
            cryState: widget.cryStates[renderIndex],
            initiallyExpanded: renderIndex == widget.cryStates.length - 1);
      },
    );
  }
}
