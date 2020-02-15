import 'package:flutter/material.dart';
import '../config/index.dart';
import '../service/service_method.dart';
import 'package:provide/provide.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'dart:convert';
import '../model/category_model.dart';
import '../provide/category_provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//主分类页面
class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(KString.categoryTitle),
      ),
      body: Container(
        child:Row(children: <Widget>[
          LeftCategoryNav(),
          Column(children: <Widget>[
            RightCategoryNav(),
            CategoryGoodsList(),
          ],)

        ],)
      ),

    );
    
  }
}

//左侧分类
class LeftCategoryNav extends StatefulWidget {
  LeftCategoryNav({Key key}) : super(key: key);

  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {

  List list = [];
  var listIndex =0;

  
  @override
  void initState() { 
    super.initState();
    _getCategory();
  }


  @override
  Widget build(BuildContext context) {
    return Provide<CategoryProvide>(
      builder: (context,child,val){
        //获取商品列表
        listIndex = val.firstCategoryIndex;

        return Container(
          width:ScreenUtil().setWidth(180),
          decoration: BoxDecoration(
            border:Border(right: BorderSide(width:1,color:KColor.defaultBorderColor)),
          ),
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context,index){
              return _leftInkWel(index);
            }
        ),
        );
      },
    );
  }

  Widget _leftInkWel(int index){
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;

    return InkWell(
      onTap: () {
        var secondCategoryLisd = list[index].secondCategoryVO;
        var firstCategoryId = list[index].firstCategoryId;
        Provide.value<CategoryProvide>(context).changeFirstCategory(firstCategoryId, index);
        Provide.value<CategoryProvide>(context).getSecondCategory(secondCategoryLisd, firstCategoryId);
        //获取商品列表
      },
      child: Container(
        height: ScreenUtil().setHeight(90),
        padding: EdgeInsets.only(left: 10, top: 10),
        decoration: BoxDecoration(
          color: isClick ? Color.fromRGBO(236, 238, 239, 1.0) : Colors.white,
        border: Border(
          bottom:BorderSide(width: 1,color:KColor.defaultBorderColor),
          left: BorderSide(width: 2,color: isClick? KColor.primaryColor:Colors.white),
          ),
        ),
        child: Text(
          list[index].firstCategoryName,
          style:TextStyle(
            color:isClick?KColor.primaryColor:Colors.black,
            fontSize:ScreenUtil().setSp(28),
          ),
        ),
      ),
    );
  }


  //获取分类数据
_getCategory() async {
  await request('getCategory',formData:null).then((val){
    var data = json.decode(val.toString());
    CategoryModel category = new CategoryModel.fromJson(data);

    setState(() {
      list = category.data;
    });

    Provide.value<CategoryProvide>(context).getSecondCategory(list[0].secondCategoryVO, '0');
  });

}
}
//右侧分类
class RightCategoryNav extends StatefulWidget {
  RightCategoryNav({Key key}) : super(key: key);

  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Provide<CategoryProvide>(
        builder:(context,child,categoryProvide){
          return Container(
            height:ScreenUtil().setHeight(80),
            width:ScreenUtil().setWidth(570),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 1,color: KColor.defaultBorderColor),
              ),
            ),
            child: ListView.builder(
              scrollDirection:Axis.horizontal,
                itemCount: categoryProvide.secondCategoryList.length,
                itemBuilder: (context,index){
                  return _rightInkWel(index,categoryProvide.secondCategoryList[index]);
                },
            ),
          );
          } 
        ),
    );
    
  }
  Widget _rightInkWel(int index,SecondCategoryVO item){

    bool isClick = false;
    isClick = (index == Provide.value<CategoryProvide>(context).secondCategoryIndex) ? true : false;

    return InkWell(
      onTap: () {
 
        Provide.value<CategoryProvide>(context).changeSecondIndex(index, item.secondCategoryId);
        //获取商品列表
      },
      child: Container(
        padding:EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child:Text(
          item.secondCategoryName,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(28),
            color: isClick ? KColor.defaultBorderColor : Colors.black,
          ),
        )
      )
    );
  }




}

//商品列表

class CategoryGoodsList extends StatefulWidget {
  CategoryGoodsList({Key key}) : super(key: key);

  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  @override
  Widget build(BuildContext context) {
    return  Text("商品列表");
    
  }
}

