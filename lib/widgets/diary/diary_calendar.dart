import 'package:babystory/screens/dday.dart';
import 'package:babystory/screens/dday_write.dart';
import 'package:babystory/utils/alert.dart';
import 'package:babystory/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DiaryCalendar extends StatefulWidget {
  final int diaryId;
  final String jwt;
  final DateTime? initDate;

  const DiaryCalendar(
      {Key? key, required this.diaryId, required this.jwt, this.initDate})
      : super(key: key);

  @override
  _DiaryCalendarState createState() => _DiaryCalendarState();
}

class _DiaryCalendarState extends State<DiaryCalendar> {
  final HttpUtils httpUtils = HttpUtils();
  late DateTime focusedDay;
  DateTime? selectedDay; // 선택된 날짜를 저장할 변수
  Map<String, int> diaryData = {};

  @override
  void initState() {
    super.initState();
    focusedDay = widget.initDate ?? DateTime.now();
    initializeDateFormatting('ko_KR', null); // 로케일 초기화
    fetchDiaryData(focusedDay.year, focusedDay.month);
  }

  int getLastDayOfMonth(DateTime focusedDate) {
    int nextMonth = focusedDate.month % 12 + 1;
    int year =
        focusedDate.month == 12 ? focusedDate.year + 1 : focusedDate.year;
    DateTime firstDayNextMonth = DateTime(year, nextMonth, 1);
    DateTime lastDayThisMonth =
        firstDayNextMonth.subtract(const Duration(days: 1));
    return lastDayThisMonth.day;
  }

  Future<void> fetchDiaryData(int year, int month) async {
    try {
      var json = await httpUtils.get(
          url: '/diary/hasddays/${widget.diaryId}&$year&$month',
          headers: {'Authorization': 'Bearer ${widget.jwt}'});

      var lastDayOfMonth = getLastDayOfMonth(focusedDay);
      var dayState = json == null
          ? List.filled(lastDayOfMonth, 0)
          : List<int>.from(json['hasDday']);
      if (dayState.length < lastDayOfMonth) {
        dayState.addAll(List.filled(lastDayOfMonth - dayState.length, 0));
      }

      Map<String, int> newDiaryData = {};
      for (int i = 0; i < lastDayOfMonth; i++) {
        DateTime date = DateTime(year, month, i + 1);
        String key = DateFormat('yyyy-MM-dd').format(date);
        newDiaryData[key] = dayState[i];
      }

      setState(() {
        diaryData = newDiaryData;
      });
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    print("날짜 선택: $selectedDay");
    var ddayId = diaryData[DateFormat('yyyy-MM-dd').format(selectedDay)];
    if (ddayId == null) {
      return;
    }
    if (ddayId != 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DdayScreen(
            ddayId: ddayId,
          ),
        ),
      );
    } else {
      Alert.confirmAlert(
          context: context,
          title: "일기를 생성",
          content: "일기가 없습니다. 일기를 생성하시겠습니까?",
          onAccept: () async {
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DdayWriteScreen(
                    diaryId: widget.diaryId, createTime: selectedDay),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // 1. 달력의 패딩 추가
        child: SizedBox(
          height: 400,
          child: TableCalendar(
            locale: 'ko_KR', // 2. 로케일을 한국어로 설정
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            onDaySelected: (selected, focused) {
              setState(() {
                selectedDay = selected;
                focusedDay = focused;
              });
              _onDaySelected(selected, focused); // 3. 날짜 선택 시 함수 호출
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                String key = DateFormat('yyyy-MM-dd').format(day);
                bool hasDiary =
                    diaryData[key] == null ? false : diaryData[key] != 0;

                return GestureDetector(
                  onTap: () {
                    _onDaySelected(day, focusedDay); // 3. 날짜 클릭 시 이동
                  },
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: hasDiary ? Colors.black : Colors.grey,
                        fontWeight:
                            hasDiary ? FontWeight.bold : FontWeight.normal,
                        fontSize: hasDiary ? 17 : 15,
                      ),
                    ),
                  ),
                );
              },
              // 1. 이전/다음 달의 날짜 숨기기
              outsideBuilder: (context, day, focusedDay) {
                return const SizedBox.shrink(); // 이전/다음 달의 날짜를 빈 위젯으로 대체
              },
            ),
            onPageChanged: (newFocusedDay) {
              setState(() {
                focusedDay = newFocusedDay;
                selectedDay = null; // 페이지 변경 시 선택된 날짜 초기화
              });
              fetchDiaryData(newFocusedDay.year, newFocusedDay.month);
            },
            calendarStyle: const CalendarStyle(
              cellPadding: EdgeInsets.all(8.0),
              outsideDaysVisible: false,
              // 2. 선택된 날짜의 하이라이트 제거
              selectedDecoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.transparent, // 오늘 날짜의 하이라이트 제거
                shape: BoxShape.circle,
              ),
              // 선택된 날짜의 텍스트 스타일 조정 (필요 시)
              selectedTextStyle: TextStyle(color: Colors.black),
              todayTextStyle: TextStyle(color: Colors.black),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextFormatter: (date, locale) =>
                  DateFormat.yMMMM(locale).format(date), // 월 이름 포맷
              headerPadding: const EdgeInsets.only(bottom: 8.0),
            ),
            daysOfWeekHeight: 30, // 요일 이름 높이 조정
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
              weekdayStyle: TextStyle(color: Colors.black),
            ),
            // Disable default selection highlight
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            // Disable built-in selection animations
            enabledDayPredicate: (day) {
              return true;
            },
          ),
        ),
      ),
    );
  }
}
