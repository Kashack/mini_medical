import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePickerWidget extends StatefulWidget {
  final DateTime selectedDate;

  const TimePickerWidget({super.key, required this.selectedDate});

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  int tag = 0;
  DateTime now = DateTime.now();
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);

  List<TimeOfDay> timeList = [];

  generateTimeList() {
    print(widget.selectedDate.day);
    print(now.day);
    if (widget.selectedDate.day == now.day) {
      startTime = TimeOfDay(hour: now.hour, minute: now.minute);
      if (startTime.hour < 9) {
        startTime = const TimeOfDay(hour: 9, minute: 0);
      }
      else if (startTime.minute < 30) {
        startTime = TimeOfDay(hour: now.hour, minute: 30);
      } else if (startTime.minute > 30) {
        startTime = TimeOfDay(hour: now.hour + 1, minute: 0);
      }
    }

    TimeOfDay currentTime = TimeOfDay(hour: 6, minute: 00);
    for (int i = 0; i <= 20; i++){
      print(startTime);
      timeList.add(startTime);
      if(startTime.hour == 17){
        break;
      }
      if (startTime.minute == 30){
        startTime = TimeOfDay(hour: startTime.hour + 1, minute: 00);
      }else{
        startTime = TimeOfDay(hour: startTime.hour, minute: startTime.minute + 30);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    generateTimeList();
  }

  @override
  Widget build(BuildContext context) {
    return ChipsChoice<int>.single(
      value: tag,
      onChanged: (val) => setState(() => tag = val),
      wrapped: true,

      choiceItems: C2Choice.listFrom<int, TimeOfDay>(
        source: timeList,
        value: (i, v) => i,
        label: (i, v) => DateFormat.jm().format(DateTime(now.year, now.month, now.day, v.hour,v.minute)),
      ),
    );
  }
}
