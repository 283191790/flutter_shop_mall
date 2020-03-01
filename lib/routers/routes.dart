import 'package:fluro/fluro.dart';
import '../pages/details_page.dart';
import 'package:flutter/material.dart';
import '../routers/router_handler.dart';

class Routes{
  static String root = '/';
  static String detailsPage = '/detail';
  static void configureRoutes(Router router){
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params){
    print('没有找到');
  
  }
    );

    router.define(detailsPage, handler: detailsHandler);

  }

}