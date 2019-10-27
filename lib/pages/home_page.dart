import 'package:flutter/material.dart';
import 'package:flutter_shop_mall/service/service_method.dart';
import 'dart:convert';


class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),      
      body:FutureBuilder(
        future: request('homePageContent',formData:null),
        builder: (context,snapshot){
          if(snapshot.hasData){
            
            var data = json.decode(snapshot.data.toString());
            print(data);
            return Container(child: Text(''),
            );

          }else{
            return Container(child: Text('加载中'),);
          }
        },
      ),
    );
  }
}