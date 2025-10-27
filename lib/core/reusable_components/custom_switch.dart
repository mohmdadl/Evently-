import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:enevtly/core/resourses/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSwitch extends StatelessWidget {
  final SvgPicture image1;
  final SvgPicture image2;
  final int current;
  final void Function(int) onChanged;
  const CustomSwitch({
    super.key,
    required this.onChanged,
    required this.image1,
    required this.image2,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedToggleSwitch<int>.rolling(
      iconOpacity: 1,
      onChanged: onChanged,
      current: current,
      values: [0, 1],
      iconList: [image1, image2],
      indicatorSize: Size(screenWidth * (32 / 390), screenHeight * (32 / 841)),
      spacing: screenWidth * (10 / 390),
      height: screenHeight * (34 / 841),
      style: ToggleStyle(
        backgroundColor: Colors.transparent,
        indicatorColor: ColorsManager.primaryColor,
        borderColor: ColorsManager.primaryColor,
      ),
    );
  }
}
