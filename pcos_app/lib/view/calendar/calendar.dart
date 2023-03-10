import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:intl/intl.dart';
import 'package:pcos_app/controller/calendar_database_handler.dart';
import 'package:pcos_app/model/schedule.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late TextEditingController contentcontroller;
  late TextEditingController updatecontroller;
  late DatabaseHandler handler;

  HawkFabMenuController hawkFabMenuController = HawkFabMenuController();

  CalendarFormat _calendarFormat = CalendarFormat.month;

  Map<String, List> mySchedule = {};

  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    contentcontroller = TextEditingController();
    updatecontroller = TextEditingController();
    handler = DatabaseHandler();
    setState(() {
      getAll();
    });
    handler.initializeDB().whenComplete(
      () {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: Color(0xFFFBA5A8),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: HawkFabMenu(
          heroTag: 'first',
          icon: AnimatedIcons.menu_close,
          fabColor: Colors.redAccent,
          iconColor: Colors.white,
          hawkFabMenuController: hawkFabMenuController,
          items: [
            HawkFabMenuItem(
              label: '생리 시작',
              ontap: () {
                setState(() {
                  if (_rangeEnd == null || _rangeEnd!.isBefore(_selectedDay!)) {
                    _rangeStart =
                        DateTime.parse(_selectedDay.toString().split(" ")[0]);
                    _rangeEnd = DateTime(_selectedDay!.year,
                        _selectedDay!.month, _selectedDay!.day + 4);
                  } else {
                    _rangeStart =
                        DateTime.parse(_selectedDay.toString().split(" ")[0]);
                  }
                });
              },
              icon: const Icon(Icons.water_drop),
              color: Colors.redAccent,
              labelColor: Colors.red[200],
            ),
            HawkFabMenuItem(
              label: '생리 끝',
              heroTag: 'second',
              ontap: () {
                setState(() {
                  if (_rangeStart != null) {
                    if (_rangeStart!.isBefore(_selectedDay!)) {
                      _rangeEnd =
                          DateTime.parse(_selectedDay.toString().split(" ")[0]);
                    } else {
                      _rangeEnd =
                          DateTime.parse(_selectedDay.toString().split(" ")[0]);
                      _rangeStart = DateTime(_selectedDay!.year,
                          _selectedDay!.month, _selectedDay!.day - 4);
                    }
                  } else {
                    _rangeEnd =
                        DateTime.parse(_selectedDay.toString().split(" ")[0]);
                    _rangeStart = DateTime(_selectedDay!.year,
                        _selectedDay!.month, _selectedDay!.day - 4);
                  }
                });
              },
              icon: const Icon(Icons.water_drop_outlined),
              labelColor: Colors.white,
              color: Colors.redAccent,
              labelBackgroundColor: Colors.red[200],
            ),
            HawkFabMenuItem(
              heroTag: 'third',
              label: '일정 등록',
              ontap: () {
                contentcontroller.text = "";
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      if (contentcontroller.text.trim() != "") {
                                        addSchedule(_selectedDay!,
                                            contentcontroller.text.trim());
                                        // mySchedule.clear();
                                        setState(() {
                                          getAll();
                                        });
                                        contentcontroller.text = "";
                                        Navigator.pop(context);
                                      } else {
                                        showScheduleDialog(context);
                                      }
                                    },
                                    child: const Text(
                                      '저장',
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                _selectedDay.toString().split(" ")[0],
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: contentcontroller,
                                maxLines: 10,
                                decoration: const InputDecoration(
                                  hintText: "일정을 작성해주세요",
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.edit_calendar),
              color: Colors.redAccent,
              labelColor: Colors.red[200],
            ),
          ],
          body: SingleChildScrollView(
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  locale: 'ko_KR',
                  rangeStartDay: (_rangeStart),
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(day, _focusedDay),
                  rangeSelectionMode: _rangeSelectionMode,
                  onDaySelected: _onDaySelected,
                  // onRangeSelected: _onRangeSelected,
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    titleTextFormatter: (date, locale) =>
                        DateFormat.yMMMM(locale).format(date),
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red[300],
                    ),
                    headerPadding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                    ),
                    leftChevronIcon: const Icon(
                      Icons.arrow_left,
                      color: Colors.redAccent,
                    ),
                    rightChevronIcon: const Icon(
                      Icons.arrow_right,
                      color: Colors.redAccent,
                    ),
                  ),
                  calendarStyle: const CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Color(0xFFDABC90),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 196, 198),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(color: Color(0xFFF16A6E)),
                      rangeHighlightColor: Color.fromARGB(255, 246, 190, 203),
                      rangeStartDecoration: BoxDecoration(
                        color: Color(0xFFF16A6E),
                        shape: BoxShape.circle,
                      ),
                      rangeEndDecoration: BoxDecoration(
                        color: Color(0xFFF16A6E),
                        shape: BoxShape.circle,
                      ),
                      weekendDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: TextStyle(color: Colors.red)),
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  eventLoader: _listOfDayEvents,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ..._listOfDayEvents(_selectedDay!).map(
                  (e) => GestureDetector(
                    onTap: () {
                      updatecontroller.text = e['content'];
                      // 일정 수정
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Spacer(),
                                        TextButton(
                                          onPressed: () {
                                            updateSchedule(
                                                updatecontroller.text.trim(),
                                                e['id']);
                                            // mySchedule.clear();
                                            setState(() {
                                              getAll();
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            '수정',
                                            style: TextStyle(
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      _selectedDay.toString().split(" ")[0],
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: updatecontroller,
                                      maxLines: 10,
                                      decoration: const InputDecoration(
                                        hintText: "일정을 작성해주세요",
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    onLongPress: () {
                      deleteAction(e['id']);
                      setState(() {
                        getAll();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 9.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(15.0)),
                      child: ListTile(
                        leading: const Icon(Icons.event_available),
                        title: Text('${e['content']}'),
                      ),
                    ),
                  ),
                ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============ Functions ===============
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      // _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });
  }

  Future<void> addSchedule(DateTime date, String content) async {
    Schedule newSchedule =
        Schedule(date: date.toString().split(' ')[0], content: content);
    await handler.insertSchedule(newSchedule);
  }

  Future<void> updateSchedule(String content, int id) async {
    await handler.updateSchedule(content, id);
  }

  Future<void> deleteSchedule(int id, String today) async {
    await handler.deleteSchedule(id, today);
  }

  Future<void> getAll() async {
    mySchedule.clear();
    Future<List<Schedule>> dbSchedule = handler.querySchedule();
    await dbSchedule.then(
      (value) {
        for (var i in value) {
          if (mySchedule[i.date] != null) {
            mySchedule[i.date]?.add({
              "id": i.id,
              "content": i.content,
              "dropdate": i.dropdate,
            });
          } else {
            mySchedule[i.date] = [
              {
                "id": i.id,
                "content": i.content,
                "dropdate": i.dropdate,
              }
            ];
          }
        }
      },
    );
    setState(() {});
  }

  // Marker 찍기
  List _listOfDayEvents(DateTime dateTime) {
    if (mySchedule[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySchedule[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  // 일정 작성 안하고 저장 버튼 눌렀을 경우
  showScheduleDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          // 내용 만들기
          title: const Text('일정 작성'),
          content: const Text('일정을 작성해주세요!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
            ),
          ],
        );
      },
    );
  }

  // 일정 삭제
  deleteAction(int id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('일정 삭제'),
          content: const Text('일정을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '취소',
              ),
            ),
            TextButton(
              onPressed: () {
                deleteSchedule(id, DateTime.now().toString().split(" ")[0]);
                // mySchedule.clear();
                setState(() {
                  getAll();
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                '확인',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
} // End
