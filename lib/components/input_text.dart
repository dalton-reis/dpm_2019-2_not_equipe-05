import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;

  InputText({this.controller, this.labelText, this.hint, this.icon, this.keyboardType});

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {

  final Color colorOfTexts = Colors.lightBlueAccent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.controller,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.lightBlue,
        ),
        decoration: InputDecoration(
          prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
          helperText: widget.hint,
          helperStyle: TextStyle(
            fontSize: 16.0,
          ),
          labelText: widget.labelText,
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.controller.value == null ? Colors.blueGrey : Colors.green,
              width: 1.5,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.5,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
        keyboardType: widget.keyboardType,
      ),
    );
  }
}


