import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {

  List itemList;
  Function callback;
  MyDropdownButton({ required this.itemList, required this.callback});

  @override
  State<MyDropdownButton> createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  var dropdownValue;
  @override
  void initState() {
    dropdownValue = widget.itemList.indexOf(widget.itemList.first);
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      validator: (value) {
        if(value == 0){
          return 'Please select a value';
        }
      },
      isExpanded: true,
      style: TextStyle(
        color: Colors.black,
        overflow: TextOverflow.ellipsis,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        enabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xFF555FD2),)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xFF555FD2),)
        )
      ),
      value: dropdownValue,
      items: widget.itemList.map((value) {
        return DropdownMenuItem(
          child: Text(value),
          value: widget.itemList.indexOf(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          dropdownValue = value;
          widget.callback(value);
        });
      },
    );
  }
}