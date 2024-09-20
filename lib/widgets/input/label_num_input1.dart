import 'dart:async';
import 'package:flutter/material.dart';

class LabelNumInput1 extends StatefulWidget {
  final String label;
  final String? hint;
  final double value;
  final double labelWidth;
  final bool intOnly; // 정수 입력만 받을지 여부
  final Function(num)? onFocusOut; // 포커스 해제 시 수행할 함수
  final Duration debounceDuration; // 타이머 시간 설정

  const LabelNumInput1({
    super.key,
    required this.label,
    this.hint,
    this.value = 0.0,
    this.labelWidth = 70,
    this.intOnly = false, // 기본적으로 double을 받으나, intOnly 옵션으로 정수 입력 가능
    this.onFocusOut, // onFocusOut 함수 인자 추가
    this.debounceDuration = const Duration(seconds: 2), // 디폴트 2초 후 실행
  });

  @override
  State<LabelNumInput1> createState() => _LabelNumInput1State();
}

class _LabelNumInput1State extends State<LabelNumInput1> {
  late TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  void _onTextChanged(String newValue) {
    // 기존 타이머가 있으면 취소
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    // 숫자만 입력받도록 처리
    String filteredValue = widget.intOnly
        ? newValue.replaceAll(RegExp(r'[^0-9]'), '') // 정수만 허용
        : newValue.replaceAll(RegExp(r'[^0-9.]'), ''); // 소수 허용

    // 텍스트 필드의 값을 필터링된 값으로 업데이트
    if (_controller.text != filteredValue) {
      _controller.value = TextEditingValue(
        text: filteredValue,
        selection: TextSelection.collapsed(offset: filteredValue.length),
      );
    }

    // 새로운 타이머 시작
    _debounceTimer = Timer(widget.debounceDuration, () {
      if (widget.onFocusOut != null && filteredValue.isNotEmpty) {
        num parsedValue = widget.intOnly
            ? int.parse(filteredValue)
            : double.parse(filteredValue);
        widget.onFocusOut!(parsedValue); // 타이머 만료 시 onFocusOut 호출
      }
    });
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
            child: TextField(
              controller: _controller,
              style: const TextStyle(
                  fontSize: 14, color: Colors.black, height: 1.5),
              onChanged: _onTextChanged,
              keyboardType: TextInputType.numberWithOptions(
                decimal: !widget.intOnly, // 소수점 입력 여부를 intOnly에 따라 결정
              ),
              decoration: InputDecoration(
                hintText: widget.value == 0 ? widget.hint : null,
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel(); // 타이머 해제
    super.dispose();
  }

  num get value => widget.intOnly
      ? int.tryParse(_controller.text) ?? widget.value.toInt()
      : double.tryParse(_controller.text) ?? widget.value;
}
