import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ForecastWid extends StatelessWidget {
  String day,state,deg;
  ForecastWid(this.day,this.deg,this.state,{super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,children: [
      Text(day),
       Text(state),
        Text(deg)
       
    ],);
  }
}