import 'package:flutter/material.dart';

class LabelDateInput1 extends StatefulWidget {
  final String label;
  final String? hint;
  final DateTime? value;
  final double labelWidth;
  final Function(DateTime)? onDateSelected; // 날짜 선택 후 호출할 함수

  const LabelDateInput1({
    super.key,
    required this.label,
    this.hint,
    this.value,
    this.labelWidth = 70,
    this.onDateSelected,
  });

  @override
  State<LabelDateInput1> createState() => _LabelDateInput1State();
}

class _LabelDateInput1State extends State<LabelDateInput1> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with formatted date or hint
    _controller = TextEditingController(
      text: widget.value != null
          ? _formatDate(widget.value!)
          : (widget.hint ?? ''),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != widget.value) {
      setState(() {
        _controller.text = _formatDate(picked);
      });
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(picked); // 날짜 선택 후 함수 호출
      }
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
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
            child: GestureDetector(
              onTap: () => _selectDate(context), // 클릭 시 날짜 선택기 호출
              child: AbsorbPointer(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(
                      fontSize: 14, color: Colors.black, height: 1.5),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: Colors.black.withOpacity(0.6),
                    ),
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
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
