import 'package:flutter/material.dart';
import 'package:meni_medical/components/constant.dart';
import 'package:meni_medical/components/custom_button.dart';
import 'package:meni_medical/components/custom_time_picker.dart';
import 'package:meni_medical/data/database_helper.dart';
import 'package:meni_medical/presentation/patient/book_appointment_detail.dart';

import '../../components/my_dropdownbutton.dart';

Map durationMap = ({
  '--Select--': 0,
  '15 minutes': 15,
  '30 minutes': 30,
  '45 minutes': 45,
  '1 hour': 60
});

class BookAppointmentPage extends StatefulWidget {
  String doctorUid;
  bool reSchedule;
  String? appointmentUid;

  BookAppointmentPage(
      {required this.doctorUid,
      required this.reSchedule,
      this.appointmentUid});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  int? durations;

  TimeOfDay? timeAppointment;

  DateTime selectedDate = DateTime.now();

  DateTime mainDate = DateTime.now();

  var counter = 0;

  bool isSelect = false;

  DateTime checkTime() {
    if (DateTime.now().isAfter(
        DateTime(mainDate.year, mainDate.month, mainDate.day, 18, 00))) {
      return DateTime(mainDate.year, mainDate.month, mainDate.day + 1);
    } else {
      return mainDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    DatabaseHelper dbHelper = DatabaseHelper(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Book Appointment', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              CalendarDatePicker(
                firstDate: checkTime(),
                initialDate: checkTime(),
                lastDate: DateTime(DateTime.now().year, DateTime.now().month + 6),
                onDateChanged: (DateTime value) {
                  setState(() {
                    selectedDate = value;
                  });
                },
              ),
              const Text(
                'Select Time',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 150,
                child: TimePickerWidget(selectedDate: checkTime(), callback: (value) => timeAppointment = value,
                ),
              ),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Select Duration',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              MyDropdownButton(
                itemList: durationMap.keys.toList(),
                callback: (value) =>
                    durations = durationMap.values.elementAt(value),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.reSchedule == false
                    ? CustomButton(
                        buttonText: 'Next',
                        onPressed: () {
                          print(timeAppointment);
                          final currentTime = DateTime(
                              mainDate.year,
                              mainDate.month,
                              mainDate.day,
                              timeAppointment!.hour,
                              timeAppointment!.minute);
                          if (durations != 0) {
                            if (durations != null &&
                                timeAppointment != null &&
                                (currentTime.isAfter(DateTime.now()) ||
                                    selectedDate != mainDate)) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookAppointmentDetail(
                                      appointmentStart: DateTime(
                                          selectedDate.year,
                                          selectedDate.month,
                                          selectedDate.day,
                                          timeAppointment!.hour,
                                          timeAppointment!.minute),
                                      doctorUid: widget.doctorUid,
                                      appointmentEnd: DateTime(
                                              selectedDate.year,
                                              selectedDate.month,
                                              selectedDate.day,
                                              timeAppointment!.hour,
                                              timeAppointment!.minute)
                                          .add(Duration(minutes: durations!)),
                                    ),
                                  ));
                            } else if (currentTime.isBefore(DateTime.now())) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Select Valid Time')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Select Duration or Time')));
                            }
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                    Text('Select Duration or Time')));
                          }
                        },
                      )
                    : CustomButton(
                        buttonText: 'Re-schedule',
                        onPressed: () async {
                          print(widget.appointmentUid);
                          final currentTime = DateTime(
                              mainDate.year,
                              mainDate.month,
                              mainDate.day,
                              timeAppointment!.hour,
                              timeAppointment!.minute);
                          if (durations != null &&
                              timeAppointment != null &&
                              (currentTime.isAfter(DateTime.now()) ||
                                  selectedDate != mainDate)) {
                            await dbHelper.ReScheduleAnAppointment(
                                appointmentStart: DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    timeAppointment!.hour,
                                    timeAppointment!.minute),
                                appointmentEnd: DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    timeAppointment!.hour,
                                    timeAppointment!.minute),
                                appointmentUid: widget.appointmentUid!,
                                doctorUid: widget.doctorUid);
                          } else if (currentTime.isBefore(DateTime.now())) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Select Valid Time')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Select Duration or Time')));
                          }
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
