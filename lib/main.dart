import 'package:flutter/material.dart';
import './config/index.dart';
import './provide/current_index_provide.dart';
import 'package:provide/provide.dart';
import './pages/index_page.dart';
import './provide/category_provide.dart';





void main(){

  var currentIndexProvide = CurrentIndexProvide();
  var categoryProvide = CategoryProvide();

  var providers = Providers();

  providers

    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide))
    ..provide(Provider<CategoryProvide>.value(categoryProvide));

  runApp(ProviderNode(child: MyApp(), providers: providers));



}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    return Container(
      child: MaterialApp(
        title: KString.mainTitle,//标题
        debugShowCheckedModeBanner: false,

        //定制主题
        theme: ThemeData(
          primaryColor: KColor.primaryColor,
        ),
        home: IndexPage(),
      ),
    );
  }


}


