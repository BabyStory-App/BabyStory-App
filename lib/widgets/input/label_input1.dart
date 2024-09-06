import 'dart:async';
import 'package:flutter/material.dart';

class LabelInput1 extends StatefulWidget {
  final String label;
  final String? hint;
  final String value;
  final double labelWidth;
  final Function(String)? onFocusOut; // 포커스 해제 시 수행할 함수
  final Duration debounceDuration; // 타이머 시간 설정

  const LabelInput1({
    super.key,
    required this.label,
    this.hint,
    this.value = '',
    this.labelWidth = 70,
    this.onFocusOut, // onFocusOut 함수 인자 추가
    this.debounceDuration = const Duration(seconds: 2), // 디폴트 2초 후 실행
  });

  @override
  State<LabelInput1> createState() => _LabelInput1State();
}

class _LabelInput1State extends State<LabelInput1> {
  late TextEditingController _controller;
  Timer? _debounceTimer; // 타이머 변수

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    _controller = TextEditingController(text: widget.value);
  }

  void _onTextChanged(String newValue) {
    // 기존 타이머가 있으면 취소
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    // 새로운 타이머 시작
    _debounceTimer = Timer(widget.debounceDuration, () {
      if (widget.onFocusOut != null) {
        widget.onFocusOut!(newValue); // 타이머가 만료되면 onFocusOut 호출
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
              onChanged: _onTextChanged, // 텍스트 변경 시 호출
              minLines: 1,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: widget.value.isEmpty ? widget.hint : null,
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

  String get value => _controller.text;
}
