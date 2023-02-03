import 'package:flutter/material.dart';
import '../bottom_nav_items.dart';

class HomePage extends StatefulWidget {
  bool isDoctor;

  HomePage({required this.isDoctor});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.isDoctor == false ? patientNavigationPages[_selectindex] : doctorNavigationPages[_selectindex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: BottomNavigationBar(
          currentIndex: _selectindex,
          onTap: (value) => setState(() {
            _selectindex = value;
          }),
          elevation: 2,
          selectedLabelStyle:
          TextStyle(fontWeight: FontWeight.bold),
          showUnselectedLabels: false,
          // type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home,color: Color(0xFF555FD2)),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month,color: Color(0xFF555FD2)),
              label: 'Appointment',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person,color: Color(0xFF555FD2)),
                label: 'user',
            ),
          ],
        ),
      ),
    );
  }
}
