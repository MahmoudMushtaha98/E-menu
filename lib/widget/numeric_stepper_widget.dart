import 'package:flutter/material.dart';

class NumericStepperWidget extends StatefulWidget {
   NumericStepperWidget({super.key, required this.onChange});

   final ValueChanged<int> onChange;

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
      widget.onChange(_numValue);
    });
  }

  void _decrement() {
    setState(() {
      _numValue--;
      _isAddButtonPressed = false;
      widget.onChange(_numValue);
    });
  }

  int get numValue => _numValue;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle
          ),
          child: IconButton(
            onPressed: _numValue > 0 ? _decrement : null,
            icon: const Icon(Icons.remove,color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "$_numValue",
            style: const TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle
          ),
          child: IconButton(
            onPressed: _increment,
            icon: const Icon(Icons.add,color: Colors.white),
            color: _isAddButtonPressed ? Colors.green : null,
          ),
        ),
      ],
    );
  }
}