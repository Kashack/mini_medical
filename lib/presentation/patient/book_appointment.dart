import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meni_medical/components/custom_button.dart';
import 'package:meni_medical/components/my_time_picker.dart';
import 'package:meni_medical/presentation/patient/book_appointment_detail.dart';

import '../../components/my_dropdownbutton.dart';

Map durationMap =
    ({'--Select--': 0, '15 minutes': 15, '30 minutes': 30, '45 minutes': 45});

class BookAppointmentPage extends StatelessWidget {
  String doctorUid;
  int? durations;
  bool re_schedule;
  TimeOfDay? timeAppointment;
  DateTime selectedDate = DateTime.now();
  var counter = 0;
  bool isSelect = false;

  BookAppointmentPage({required this.doctorUid, required this.re_schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Book Appointment', style: TextStyle(color: Colors.black)),
        leading: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              CalendarDatePicker(
                firstDate: DateTime.now(),
                initialDate: DateTime.now(),
                lastDate:
                    DateTime(DateTime.now().year, DateTime.now().month + 6),
                onDateChanged: (DateTime value) {
                  selectedDate = value;
                },
              ),
              Text(
                'Select Time',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                  height: 150,
                  child: MyTimePicker(
                    callback: (value) => timeAppointment = value,
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                child: re_schedule == false
                    ? CustomButton(
                        buttonText: 'Next',
                        onPressed: () {
                          if (durations != null || timeAppointment != null) {
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
                                    doctorUid: doctorUid,
                                    appointmentEnd: DateTime(
                                            selectedDate.year,
                                            selectedDate.month,
                                            selectedDate.day,
                                            timeAppointment!.hour,
                                            timeAppointment!.minute)
                                        .add(Duration(minutes: durations!)),
                                  ),
                                ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Select Duration')));
                          }
                        },
                      )
                    : CustomButton(
                        buttonText: 'Re-schedule',
                        onPressed: () {},
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
