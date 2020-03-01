import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import './config/index.dart';
import './provide/current_index_provide.dart';
import 'package:provide/provide.dart';
import './pages/index_page.dart';
import './provide/category_provide.dart';
import './provide/category_goods_list_provide.dart';
import 'routers/routes.dart';
import 'package:fluro/fluro.dart';
import './routers/application.dart';
import './provide/details_info_provide.dart';



void main(){

  var currentIndexProvide = CurrentIndexProvide();
  var categoryProvide = CategoryProvide();
  var cateporyGoodsListProvide = CategoryGoodsListProvide();
  var detailsInfoProvide = DetailsInfoProvide();
  var providers = Providers();

  providers

    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide))
    ..provide(Provider<CategoryProvide>.value(categoryProvide))
    ..provide(Provider<CategoryGoodsListProvide>.value(cateporyGoodsListProvide))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide));

  runApp(ProviderNode(child: MyApp(), providers: providers));



}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        title: KString.mainTitle,//标题
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Application.router.generator,
        //定制主题
        theme: ThemeData(
          primaryColor: KColor.primaryColor,
        ),
        home: IndexPage(),
      ),
    );
  }


}


