import 'package:enevtly/core/resourses/colors_manager.dart';
import 'package:enevtly/core/resourses/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String value;
  final void Function() onClick;
  const CustomButton({super.key, required this.value, required this.onClick});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primaryColor,
          padding: EdgeInsets.symmetric(vertical: screenHeight * (16 / 841)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          value,
          style: StylesManager.welcomeTitle.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
