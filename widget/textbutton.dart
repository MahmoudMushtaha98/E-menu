
import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget({
    super.key,
    required this.text, required this.function,
  });
final VoidCallback function;

  final String text;

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return TextButton(

      onPressed: function,
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(212, 175, 55, 1),
            borderRadius: BorderRadius.all(Radius.circular(10)
            )
        ),
        alignment: Alignment.center,
        width: sizeWidth * 0.5,
        height: sizeHeight * 0.06,
        padding: const EdgeInsets.all(10.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
