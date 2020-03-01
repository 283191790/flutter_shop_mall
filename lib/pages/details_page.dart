import 'package:flutter/material.dart';
import 'package:flutter_shop_mall/service/service_method.dart';
import '../config/index.dart';
import 'dart:convert';
import '../service/service_method.dart';
import 'package:provide/provide.dart';
import '../provide/details_info_provide.dart';

class DetailsPage extends StatelessWidget {

  final String goodsId;

  DetailsPage(this.goodsId);
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
        print("返回上一页");
        Navigator.pop(context);
      },
      ),
      title: Text(KString.detailsPageTitle),
      ),
      body: FutureBuilder(
        future: _getGoodsInfo(context),
                builder:(context,snapshot){
                  if(snapshot.hasData){
                    return Stack(
                      children: <Widget>[
                        ListView(
                          children:<Widget>[

                          ]
                        ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child:Text("底部组件") ,
                      ),
                      ],
                    );
                  }else{
                    return Text("加载中");
                  }
                } 
            ),
              )
              );
          }
        
          Future _getGoodsInfo(BuildContext context) async{
            await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
          }
}