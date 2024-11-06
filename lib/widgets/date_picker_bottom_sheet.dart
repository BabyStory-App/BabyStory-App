import 'package:flutter/material.dart';

class DatePickerBottomSheet extends StatefulWidget {
  @override
  _DatePickerBottomSheetState createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  // 연도 리스트 생성 (예: 현재 년도 - 100부터 현재 년도 + 10까지)
  List<int> getYearList() {
    int currentYear = DateTime.now().year;
    return List<int>.generate(111, (index) => currentYear - 100 + index);
  }

  // 월 리스트 생성
  List<int> getMonthList() {
    return List<int>.generate(12, (index) => index + 1);
  }

  // 일 리스트 생성 (해당 월과 연도에 맞는 일수 계산)
  List<int> getDayList() {
    int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    return List<int>.generate(daysInMonth, (index) => index + 1);
  }

  @override
  Widget build(BuildContext context) {
    // Bottom Sheet의 높이를 화면의 절반으로 설정
    return Container(
      padding: const EdgeInsets.all(8),
      height: 200,
      child: Column(
        children: [
          const Text(
            '날짜 선택',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 20),
          // 연, 월, 일 선택을 위한 Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 연도 선택
              Expanded(
                child: Column(
                  children: [
                    const Text('연도'),
                    DropdownButton<int>(
                      value: selectedYear,
                      items: getYearList()
                          .map((year) => DropdownMenuItem(
                                value: year,
                                child: Text(year.toString()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value!;
                          // 선택된 월에 따른 일수 재계산
                          int maxDay =
                              DateTime(selectedYear, selectedMonth + 1, 0).day;
                          if (selectedDay > maxDay) {
                            selectedDay = maxDay;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              // 월 선택
              Expanded(
                child: Column(
                  children: [
                    const Text('월'),
                    DropdownButton<int>(
                      value: selectedMonth,
                      items: getMonthList()
                          .map((month) => DropdownMenuItem(
                                value: month,
                                child: Text(month.toString()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMonth = value!;
                          // 선택된 월에 따른 일수 재계산
                          int maxDay =
                              DateTime(selectedYear, selectedMonth + 1, 0).day;
                          if (selectedDay > maxDay) {
                            selectedDay = maxDay;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              // 일 선택
              Expanded(
                child: Column(
                  children: [
                    const Text('일'),
                    DropdownButton<int>(
                      value: selectedDay,
                      items: getDayList()
                          .map((day) => DropdownMenuItem(
                                value: day,
                                child: Text(day.toString()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDay = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // 확인 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                DateTime pickedDate =
                    DateTime(selectedYear, selectedMonth, selectedDay);
                Navigator.pop(context, pickedDate);
              },
              child: const Text('확인',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
