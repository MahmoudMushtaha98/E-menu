import 'package:flutter/material.dart';

class NumericStepperWidget extends StatefulWidget {


  @override
  _NumericStepperWidgetState createState() => _NumericStepperWidgetState();
}

class _NumericStepperWidgetState extends State<NumericStepperWidget> {
  int _numValue = 0;
  bool _isAddButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _numValue =1;
  }

  void _increment() {
    setState(() {
      _numValue++;
      _isAddButtonPressed = true;
    });
  }

  void _decrement() {
    setState(() {
      _numValue--;
      _isAddButtonPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle
          ),
          child: IconButton(
            onPressed: _numValue > 0 ? _decrement : null,
            icon: Icon(Icons.remove,color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "$_numValue",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(212, 175, 55, 1),
              shape: BoxShape.circle
          ),
          child: IconButton(
            onPressed: _increment,
            icon: Icon(Icons.add,color: Colors.white),
            color: _isAddButtonPressed ? Colors.green : null,
          ),
        ),
      ],
    );
  }
}