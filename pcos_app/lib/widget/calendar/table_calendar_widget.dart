import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   initializeDateFormatting(Localizations.localeOf(context).languageCode);
  // }

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
      headerStyle: HeaderStyle(
        titleCentered: true,
        titleTextFormatter: (date, locale) =>
            DateFormat.yMMMM(locale).format(date),
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          color: Colors.red[300],
        ),
        headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
      ),
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 196, 198),
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(color: Color(0xFFF16A6E)),
        rangeHighlightColor: Color.fromARGB(255, 246, 190, 203),
        rangeStartDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        rangeEndDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        weekendDecoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
      ),
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        focusedDay = focusedDay;
      },
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
