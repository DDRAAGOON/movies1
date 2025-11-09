
import 'package:flutter/material.dart';

class Customelevatedbuttom extends StatelessWidget {
  Customelevatedbuttom({super.key,this.elevatedchild,this.elevatedcolor,required this.onPressed,this.borderSideColor});
  Widget ?elevatedchild;
  Color? elevatedcolor;
  Color ? borderSideColor;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return ElevatedButton(

        style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: height*0.013,
                horizontal: width*0.02
            ),
            backgroundColor: elevatedcolor,shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color:Colors.orange),
            borderRadius: BorderRadiusGeometry.circular(16))),
        onPressed:  onPressed,
        child:elevatedchild);
  }
}
