import 'package:flutter/material.dart';
import 'package:meni_medical/components/constant.dart';

Map timeSelect = ({
  '09:00 am': const TimeOfDay(hour: 9, minute: 0),
  '09:30 am': const TimeOfDay(hour: 9, minute: 30),
  '10:00 am': const TimeOfDay(hour: 10, minute: 0),
  '10:30 am': const TimeOfDay(hour: 10, minute: 30),
  '11:00 am': const TimeOfDay(hour: 11, minute: 0),
  '11:30 am': const TimeOfDay(hour: 11, minute: 30),
  '12:00 pm': const TimeOfDay(hour: 12, minute: 0),
  '12:30 pm': const TimeOfDay(hour: 12, minute: 30),
  '01:00 pm': const TimeOfDay(hour: 13, minute: 0),
  '01:30 pm': const TimeOfDay(hour: 13, minute: 30),
  '02:00 pm': const TimeOfDay(hour: 14, minute: 0),
  '02:30 pm': const TimeOfDay(hour: 14, minute: 30),
  '03:00 pm': const TimeOfDay(hour: 15, minute: 0),
  '03:30 pm': const TimeOfDay(hour: 15, minute: 30),
  '04:00 pm': const TimeOfDay(hour: 16, minute: 0),
  '04:30 pm': const TimeOfDay(hour: 16, minute: 30),
  '05:00 pm': const TimeOfDay(hour: 17, minute: 0),
  '05:30 pm': const TimeOfDay(hour: 17, minute: 30),
});

final List<bool> isTimeSelect = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
];

class MyTimePicker extends StatefulWidget {
  final Function callback;
  const MyTimePicker({Key? key, required this.callback}) : super(key: key);

  @override
  State<MyTimePicker> createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
          childAspectRatio: 1,
          crossAxisSpacing: 0,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: timeSelect.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                widget.callback(timeSelect.values.elementAt(index));
                for (int i = 0; i < isTimeSelect.length; i++) {
                  isTimeSelect[i] = (i == index);
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color:
                      isTimeSelect[index] == true ? MyConstant.mainColor : null,
                  border: Border.all(color: MyConstant.mainColor,width: 2)),
              child: Text(
                timeSelect.keys.toList()[index],style: TextStyle(fontSize: 9),
              ),
            ),
          );
        });
  }
}
