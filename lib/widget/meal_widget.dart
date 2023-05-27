import 'package:flutter/material.dart';
import '../model/save_order_model.dart';
import '../screen/half_screen.dart';

class MealWidget extends StatefulWidget {
  final String mealName;
  final String mealComponent;
  final String price;
  final ValueChanged<SaveOrderModel> saveOrder;

  const MealWidget({
    Key? key,
    required this.mealName,
    required this.mealComponent,
    required this.price, required this.saveOrder,
  }) : super(key: key);

  @override
  _MealWidgetState createState() => _MealWidgetState();
}

class _MealWidgetState extends State<MealWidget> {

SaveOrderModel? order;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: () async {
        // wait for a value to be returned from HalfScreen
        final result = await showModalBottomSheet(
          context: context,
          builder: (context) {
            return HalfScreen(mealName: widget.mealName,mealComponent: widget.mealComponent,price: widget.price,);
          },
        );
        // do something with the result
        widget.saveOrder(result);
      },
      child: ListTile(
        title: Text(widget.mealName,style: const TextStyle(color: Color.fromRGBO(212, 175, 55, 1)),),
        subtitle: Text(
          widget.mealComponent,
          maxLines: 2,
          style: const TextStyle(overflow: TextOverflow.ellipsis,color: Colors.grey),
        ),
        trailing: Text(
          '${widget.price} JOD',
          style: const TextStyle(fontSize: 18,color: Colors.grey),
        ),
      ),
    );
  }
}
