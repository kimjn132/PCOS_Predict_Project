import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:pcos_app/controller/calendar_database_handler.dart';
import 'package:pcos_app/model/schedule.dart';
import 'package:pcos_app/widget/calendar/table_calendar_widget.dart';

class FloatingButtonWidget extends StatefulWidget {
  const FloatingButtonWidget({super.key});

  @override
  State<FloatingButtonWidget> createState() => _FloatingButtonWidgetState();
}

class _FloatingButtonWidgetState extends State<FloatingButtonWidget> {
  HawkFabMenuController hawkFabMenuController = HawkFabMenuController();
  late TextEditingController contentcontroller;
  late TextEditingController updatecontroller;
  late DatabaseHandler handler;

  Map<String, List> mySchedule = {};

  DateTime? focusedDay = DateTime.now();
  DateTime? selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDay = focusedDay;
    contentcontroller = TextEditingController();
    updatecontroller = TextEditingController();
    handler = DatabaseHandler();
    getAll();
    handler.initializeDB().whenComplete(
      () async {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return HawkFabMenu(
      icon: AnimatedIcons.menu_close,
      fabColor: Colors.redAccent, // <<<<<<<<<<<<
      iconColor: Colors.white,
      hawkFabMenuController: hawkFabMenuController,
      items: [
        HawkFabMenuItem(
          label: '생리 시작',
          ontap: () {
            setState(() {
              if (rangeEnd == null || rangeEnd!.isBefore(selectedDay!)) {
                rangeStart =
                    DateTime.parse(selectedDay.toString().split(" ")[0]);
                rangeEnd = DateTime(selectedDay!.year, selectedDay!.month,
                    selectedDay!.day + 4);
              } else {
                rangeStart =
                    DateTime.parse(selectedDay.toString().split(" ")[0]);
              }
            });
          },
          icon: const Icon(Icons.water_drop),
          color: Colors.red,
          labelColor: Colors.red[200],
        ),
        HawkFabMenuItem(
          label: '생리 끝',
          ontap: () {
            setState(() {
              if (rangeStart != null) {
                if (rangeStart!.isBefore(selectedDay!)) {
                  rangeEnd =
                      DateTime.parse(selectedDay.toString().split(" ")[0]);
                } else {
                  rangeEnd =
                      DateTime.parse(selectedDay.toString().split(" ")[0]);
                  rangeStart = DateTime(selectedDay!.year, selectedDay!.month,
                      selectedDay!.day - 4);
                }
              } else {
                rangeEnd = DateTime.parse(selectedDay.toString().split(" ")[0]);
                rangeStart = DateTime(selectedDay!.year, selectedDay!.month,
                    selectedDay!.day - 4);
              }
            });
          },
          icon: const Icon(Icons.water_drop_outlined),
          labelColor: Colors.white,
          labelBackgroundColor: Colors.red[200],
        ),
        HawkFabMenuItem(
          label: '일정 등록',
          ontap: () {
            contentcontroller.text = "";
            showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              context: context,
              builder: (BuildContext conntext) {
                return Container(
                  height: 450,
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
                                  addSchedule(selectedDay!,
                                      contentcontroller.text.trim());
                                  mySchedule.clear();
                                  setState(() {
                                    getAll();
                                  });
                                  contentcontroller.text = "";
                                  Navigator.of(context).pop();
                                } else {
                                  showScheduleDialog(context);
                                }
                              },
                              child: const Text('저장'),
                            ),
                          ],
                        ),
                        Text(
                          selectedDay.toString().split(" ")[0],
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: contentcontroller,
                          maxLines: 8,
                          decoration: const InputDecoration(
                            hintText: "일정을 작성해주세요",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.edit_calendar),
          labelColor: Colors.red[200],
        ),
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            CalendarWidget(
              focusedDay: focusedDay,
              selectedDay: selectedDay,
              rangeStart: rangeStart,
              rangeEnd: rangeEnd,
            ),
          ],
        ),
      ),
    );
  }

  // =========== funcs =============
  // 일정 등록
  Future<void> addSchedule(DateTime date, String content) async {
    Schedule newSchedule =
        Schedule(date: date.toString().split(' ')[0], content: content);
    await handler.insertSchedule(newSchedule);
  }

  // 모든 일정 불러오기
  void getAll() {
    setState(() {
      Future<List<Schedule>> dbSchedule;
      dbSchedule = handler.querySchedule();
      dbSchedule.then(
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
    });
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
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
