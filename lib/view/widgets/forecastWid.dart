import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ForecastWid extends StatelessWidget {
  String day,state,deg,icon_code;
  ForecastWid(this.day,this.deg,this.state,this.icon_code,{super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,children: [
        Text(day),
        Image.network('http://openweathermap.org/img/wn/${icon_code}@2x.png',height: 50,width: 50,),
         Text(state),
          Text(deg)
         
      ],),
    );
  }
}