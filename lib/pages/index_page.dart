import 'package:provide/provide.dart';
import 'package:flutter/material.dart';
import '../config/index.dart';
import 'home_page.dart';
import 'category_page.dart';
import 'cart_page.dart';
import 'member_page.dart';
import '../provide/current_index_provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class IndexPage extends StatelessWidget {

  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home,color: Colors.pink,),
      title: Text(KString.homeTitle,style: TextStyle(color: Colors.black),),//首页
  ),
    BottomNavigationBarItem(
      icon: Icon(Icons.category,color: Colors.pink,),
      title: Text(KString.categoryTitle,style: TextStyle(color: Colors.black),),//分类
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart,color: Colors.pink,),
      title: Text(KString.shoppingCartTitle,style: TextStyle(color: Colors.black),),//购物车
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person,color: Colors.pink,),
      title: Text(KString.memberTitle,style: TextStyle(color: Colors.black),),//会员中心
    ),
  ];

  final List<Widget> tabBodies = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage()
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750,height: 1334)..init(context);
    return Provide<CurrentIndexProvide>(

      builder: (context,child,val){

        //取到当前索引状态值
        int currentIndex = Provide.value<CurrentIndexProvide>(context).currentIndex;
        return Scaffold(
          backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            items: bottomTabs,
            onTap: (index){
              Provide.value<CurrentIndexProvide>(context).changeIndex(index);
            },
          ),
          body: IndexedStack(
            index: currentIndex,
            children:tabBodies,
          ),
        );

      },

    );


  }

}