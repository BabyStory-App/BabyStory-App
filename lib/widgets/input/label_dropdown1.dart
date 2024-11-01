import 'package:flutter/material.dart';

class LabelDropdown1 extends StatefulWidget {
  final String label;
  final List<String> options;
  final String? hint;
  final String? value;
  final double labelWidth;
  final Function(String?)? onSelected; // 항목 선택 시 수행할 함수

  const LabelDropdown1({
    super.key,
    required this.label,
    required this.options,
    this.hint,
    this.value,
    this.labelWidth = 70,
    this.onSelected, // onSelected 함수 인자 추가
  });

  @override
  State<LabelDropdown1> createState() => _LabelDropdown1State();
}

class _LabelDropdown1State extends State<LabelDropdown1> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    print("widget.value: ${widget.value}");
    print("widget.options: ${widget.options}");
    _selectedValue = widget.value ?? widget.options.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: widget.labelWidth,
                minWidth: widget.labelWidth,
              ),
              child: Text(
                widget.label,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                maxLines: 3,
                softWrap: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedValue,
              hint: widget.hint != null
                  ? Text(
                      widget.hint!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    )
                  : null,
              onChanged: (newValue) {
                setState(() {
                  _selectedValue = newValue;
                });
                // 선택되었을 때 onSelected 함수 호출
                if (widget.onSelected != null) {
                  widget.onSelected!(newValue);
                }
              },
              items: widget.options
                  .map<DropdownMenuItem<String>>(
                    (String option) => DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black, height: 1.5),
                      ),
                    ),
                  )
                  .toList(),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? get value => _selectedValue;
}
