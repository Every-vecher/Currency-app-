import 'package:flutter/material.dart';
import 'package:test_app/utils/colors.dart';

class Loading extends StatelessWidget{
  final Color color;
  final double size;
  Loading({this.color = AppColors.black, this.size = 36});

  @override
  Widget build(BuildContext context) => Center(
      child: Container(
          height: size,
          width: size,
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color)
          )));
}