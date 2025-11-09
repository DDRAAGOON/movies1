import 'package:flutter/material.dart';
import 'package:movies1/Utls/colors.dart';
import 'package:movies1/Utls/textStyle.dart';
typedef Onvalidator=String? Function(String?)?;
class Customtextfield extends StatelessWidget {
  Customtextfield({
    super.key,
    this.hintText,
    required  this.borderSideColor,
    this.hintstyle,
    this.prefixicon,
    this.prefixiconcolor,
    this.labelstyle,
    this.suffixicon,
    this.labelText,
    this.preficiconstyle,
    this.validator,
    this.textInputType,
    this.obscuretext=false,
    required this.controller,
    this.maxline=1,
      this.fillcolor,
  });

  String? hintText;
  String? labelText;
  TextStyle? hintstyle=AppStyle.med14white;
  TextStyle? labelstyle;
  Color borderSideColor;
  Color? prefixiconcolor ;
  Widget? prefixicon;
  TextStyle? preficiconstyle;
  Widget? suffixicon;
  Onvalidator?validator;
  TextInputType? textInputType;
  bool obscuretext;
  TextEditingController controller ;
  int maxline;
  Color ?fillcolor=Colors.grey;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines:maxline ,
      controller:controller ,
      obscuringCharacter: '*',
      obscureText: obscuretext,
      keyboardType:textInputType ,
      validator: validator,
      decoration: InputDecoration(
        fillColor: fillcolor,
        prefixIconColor: prefixiconcolor,
        prefixIcon: prefixicon,
        prefixStyle: preficiconstyle,
        focusedBorder: buildOutlineInputBorder( ),
        enabledBorder: buildOutlineInputBorder( ),
        errorBorder: buildOutlineErrorInputBorder( ),
        focusedErrorBorder: buildOutlineErrorInputBorder(),
        labelText: labelText,
        labelStyle: labelstyle,
        hintText:hintText,
        hintStyle: hintstyle,
        suffixIcon: suffixicon,

      ),

    );
  }
  OutlineInputBorder buildOutlineInputBorder(   ){
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide:  BorderSide(color:borderSideColor,width: 2 )

    );
  }
  OutlineInputBorder buildOutlineErrorInputBorder(   ){
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide:  BorderSide(color:Colors.red,width: 2 )

    );
  }
}
