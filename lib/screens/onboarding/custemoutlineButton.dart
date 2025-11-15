import 'package:flutter/material.dart';

class CustemOutlinebutton extends StatelessWidget {
  String textForOutlineButton;
  CustemOutlinebutton({super.key, required this.textForOutlineButton});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            clipBehavior: Clip.antiAlias,

            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.amber, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                textForOutlineButton,
                style: TextStyle(color: Colors.amber, fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
