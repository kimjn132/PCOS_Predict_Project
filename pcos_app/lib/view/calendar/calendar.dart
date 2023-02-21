import 'package:flutter/material.dart';
import 'package:pcos_app/widget/calendar/floating_button_widget.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: FloatingButtonWidget(),
      ),
    );
  }
}
