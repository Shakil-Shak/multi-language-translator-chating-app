import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_language_firebase_chat_app/models/colors.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ButtonWidget extends StatelessWidget {
  String? btnText = "";
  var onClick;
  var btnController;
  final IconData? icon;

  ButtonWidget({this.btnText, this.onClick,required this.btnController,required this.icon});

  // Widget iconModel() {
  //   return IconButton(
  //     icon: icon!,
  //     onPressed: () {},
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      controller: btnController,
      onPressed: onClick,
      color: colorsModel.orangeLightColors,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            btnText!,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            icon,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
