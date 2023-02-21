import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.rangeStart,
    required this.rangeEnd,
  });

  final DateTime? focusedDay;
  final DateTime? selectedDay;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: widget.focusedDay!,
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      locale: 'ko_KR',
      rangeStartDay: (widget.rangeStart),
      rangeEndDay: widget.rangeEnd,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(day, widget.focusedDay),
      onDaySelected: _onDaySelected,
    );
  }

  // ================ funcs ==================
  // 날짜 선택
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(selectedDay, selectedDay)) {
      setState(() {
        selectedDay = selectedDay;
        focusedDay = focusedDay;
      });
    }
  }
}
