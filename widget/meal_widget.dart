import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../screen/half_screen.dart';

class MealWidget extends StatefulWidget {
  final String mealName;
  final String mealComponent;
  final String price;

  const MealWidget({
    Key? key,
    required this.mealName,
    required this.mealComponent,
    required this.price,
  }) : super(key: key);

  @override
  _MealWidgetState createState() => _MealWidgetState();
}

class _MealWidgetState extends State<MealWidget> {
  File? _image;

  Future<void> getImage() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: () {

        showModalBottomSheet(context: context, builder: (context) {
          return HalfScreen(price: widget.price,mealName: widget.mealName,mealComponent: widget.mealComponent,image: _image,);
        },);
      },
      child: ListTile(
        leading: Container(
          width: MediaQuery.of(context).size.width*0.18,
          height: MediaQuery.of(context).size.height*0.13,
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
          child: GestureDetector(
            onTap: getImage,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: _image == null
                  ? Icon(Icons.add_a_photo)
                  : Image.file(_image!, fit: BoxFit.cover),
            ),
          ),
        ),
        title: Text(widget.mealName),
        subtitle: Text(
          widget.mealComponent,
          maxLines: 2,
          style: TextStyle(overflow: TextOverflow.ellipsis),
        ),
        trailing: Text(
          '${widget.price} JOD',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
