import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'constant.dart';

class TimePickerWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function callback;

  const TimePickerWidget(
      {super.key, required this.selectedDate, required this.callback});

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  int tag = 0;
  DateTime now = DateTime.now();
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);

  List<TimeOfDay> timeList = [];

  generateTimeList() {
    if (widget.selectedDate.day == now.day) {
      startTime = TimeOfDay(hour: now.hour, minute: now.minute);
      if (startTime.hour < 9) {
        startTime = const TimeOfDay(hour: 9, minute: 0);
      } else if (startTime.minute < 30) {
        startTime = TimeOfDay(hour: now.hour, minute: 30);
      } else if (startTime.minute > 30) {
        startTime = TimeOfDay(hour: now.hour + 1, minute: 0);
      }
    }
    for (int i = 0; i <= 20; i++) {
      timeList.add(startTime);
      if (startTime.hour == 17) {
        break;
      }
      if (startTime.minute == 30) {
        startTime = TimeOfDay(hour: startTime.hour + 1, minute: 00);
      } else {
        startTime =
            TimeOfDay(hour: startTime.hour, minute: startTime.minute + 30);
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
    widget.callback(timeList.first);
    // return ChipsChoice<int>.single(
    //   value: tag,
    //   onChanged: (val) => setState(() {
    //     widget.callback(timeList[val]);
    //     tag = val;
    //   }),
    //   wrapped: true,
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   mainAxisSize: MainAxisSize.max,
    //   choiceItems: C2Choice.listFrom<int, TimeOfDay>(
    //     source: timeList,
    //     value: (i, v) => i,
    //     label: (i, v) => DateFormat.jm()
    //         .format(DateTime(now.year, now.month, now.day, v.hour, v.minute)),
    //   ),
    // );
    return GridView(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        childAspectRatio: 0.9,
        mainAxisSpacing: 16,
        crossAxisSpacing: 8,
      ),
      scrollDirection: Axis.horizontal,
      children: List.generate(
        timeList.length,
        (index) => ChoiceChip(
          label: Text(DateFormat.jm().format(DateTime(now.year, now.month,
              now.day, timeList[index].hour, timeList[index].minute))),
          selected: tag == index,
          backgroundColor: Colors.white,
          selectedColor: MyConstant.mainColor,
          labelStyle: tag == index ? const TextStyle(color: Colors.white) : const TextStyle(color: Colors.black) ,
          labelPadding: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            side: tag == index ? BorderSide.none: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(100)
          ),
          onSelected: (selected) {
            setState(() {
              tag = (selected ? index : null)!;
            });
          },
        ),
      ),
    );
  }
}
