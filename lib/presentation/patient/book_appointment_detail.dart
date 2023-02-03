import 'package:flutter/material.dart';
import 'package:meni_medical/components/custom_button.dart';
import 'package:meni_medical/components/my_dropdownbutton.dart';
import 'package:meni_medical/data/database_helper.dart';

import '../../components/text_form_field.dart';

class BookAppointmentDetail extends StatefulWidget {
  DateTime appointmentStart;
  String doctorUid;
  DateTime appointmentEnd;


  BookAppointmentDetail(
      {required this.appointmentStart, required this.doctorUid, required this.appointmentEnd,});

  @override
  State<BookAppointmentDetail> createState() => _BookAppointmentDetailState();
}

class _BookAppointmentDetailState extends State<BookAppointmentDetail> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? patientFullname;
  String? patientGender;
  String? patientAge;
  String? patientProblem;
  List gender = ['--Select--', 'Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    print(widget.appointmentEnd);
    print(widget.appointmentStart);
    DatabaseHelper dbHelper = DatabaseHelper(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title:
            Text('Patient Details', style: TextStyle(color: Colors.black)),
            leading: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Full name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    MyTextField(
                      labelText: 'Full Name',
                      onchanged: (value) => patientFullname = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Full Name';
                        }
                        return null;
                      },
                      inputType: TextInputType.text,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Gender',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    MyDropdownButton(
                      itemList: gender,
                      callback: (value) {
                        patientGender = gender[value];
                      },

                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Age',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    MyTextField(
                      labelText: 'Age',
                      onchanged: (value) => patientAge = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Age';
                        }
                        return null;
                      },
                      inputType: TextInputType.number,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'State Your Problem',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: MyTextField(
                        maxLines: 10,
                        inputType: TextInputType.multiline,
                        labelText: 'Describe',
                        hintText: '....',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some description';
                          }
                        },
                        onchanged: (value) => patientProblem = value,
                      ),
                    ),
                    CustomButton(
                      buttonText: 'Submit',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          bool check = await dbHelper.createAnAppointment(
                              patientFullName: patientFullname!,
                              patientGender: patientGender!,
                              patientAge: patientAge!,
                              doctorUid: widget.doctorUid,
                              patientProblem: patientProblem!,
                              appointmentStart: widget.appointmentStart,
                              appointmentEnd: widget.appointmentEnd);
                          setState(() {
                            _isLoading = check;
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black12,
            ),
          ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }
}
