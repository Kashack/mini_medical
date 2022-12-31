import 'package:flutter/material.dart';
import 'package:meni_medical/components/constant.dart';
import 'package:meni_medical/presentation/patient/appointment_page/cancelled_appointment.dart';
import 'package:meni_medical/presentation/patient/appointment_page/completed_appointment.dart';
import 'package:meni_medical/presentation/patient/appointment_page/ongoing_appointment.dart';
import 'package:meni_medical/presentation/patient/appointment_page/upcoming_appointment.dart';

class PatientAppointment extends StatelessWidget {
  const PatientAppointment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('My Appointment',style: TextStyle(color: Colors.black)),
          bottom: const TabBar(
            indicatorColor: Color(0xFF555FD2),
            labelColor: Colors.black,
            isScrollable: true,
            tabs: [
              Tab(
                text: 'Upcoming',
              ),
              Tab(
                text: 'OnGoing',
              ),
              Tab(
                text: 'Completed',
              ),
              Tab(
                text: 'Cancelled',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UpcomingAppointment(),
            OngoingAppointment(),
            CompletedAppointment(),
            CancelledAppointment(),
          ],
        ),
      ),
    );
  }
}