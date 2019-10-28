import 'package:flutter/material.dart';
import 'package:flutter_shop_mall/config/font.dart';
import 'package:flutter_shop_mall/service/service_method.dart';
import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop_mall/config/color.dart';
import 'package:flutter_shop_mall/config/string.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/index.dart';



class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  //防止刷新处理，保持当前状态
  @override
  bool get wantKeepAlive =>true;

  GlobalKey<RefreshFooterState>_footerKey = new GlobalKey<RefreshFooterState>();
  //diff

  @override
  void initState(){
    super.initState();
    print("首页刷新了");
  }

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
            List<Map> swiperDataList = (data['data']['slides']as List).cast(); //Swipe图
            List<Map> navigatorList = (data['data']['category']as List).cast(); //分类
            List<Map> recommendList = (data['data']['recommend']as List).cast();//商品推荐
            List<Map> floor1 = (data['data']['floor1']as List).cast();//底部商品推荐
            Map fp1 =data['data']['floor1Pic'];//广告


      
            return EasyRefresh(
              refreshFooter: ClassicsFooter(
                key: _footerKey,
                bgColor: Colors.white,
                textColor: KColor.refreshTextColor,
                moreInfoColor: KColor.refreshTextColor,
                showMore: true,
                noMoreText: "",
                moreInfo: KString.loading,
                loadReadyText: KString.loadReadyText,
                ),
                child: ListView(
                  children: <Widget>[
                    SwiperDiy(
                      swiperDataList: swiperDataList,
                    ),
                    TopNavigator(
                      navigatorList: navigatorList,
                    ),
                    RecommendList(
                      recommendList: recommendList,
                    ),
                  ],
                ),
                loadMore: ()async{
                  print("开始加载更多");
                },
            );

          }else{
            return Center(
              child: Text('加载中'),
            );
          }
        },
      ),
    );
  }
}
//轮播组建编写
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key,this.swiperDataList}):super(key:key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Container(
      color: Colors.white,
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          return InkWell(
            onTap:(){},
            child:Image.network(
              "${swiperDataList[index]['image']}",
              fit:BoxFit.cover,
          ));
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}
//首页分类导航组建
class TopNavigator extends StatelessWidget{
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}):super(key: key);

  Widget _gridViewItemUI(BuildContext context,item,index){
    return InkWell(
      onTap: (){
        //跳转分类页面
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width: ScreenUtil().setWidth(95),),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(navigatorList.length > 10){  //判断分类个数
      navigatorList.removeRange(10, navigatorList.length);
    }

    var tempIndex = -1;
    return Container(
      color:Colors.white,
      margin: EdgeInsets.only(top: 5.0), //分类数量
      height: ScreenUtil().setHeight(140),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        //禁止滚动
        physics:NeverScrollableScrollPhysics(),
          crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: navigatorList.map((item){
          tempIndex++;
          return _gridViewItemUI(context, item, tempIndex);
    }).toList(),


      ),
    );
  }
}

//商品标题
class RecommendList extends StatelessWidget {
  final List recommendList;

  RecommendList({Key key, this.recommendList}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommedList(context),
        ],
      ),
    );
  }

  //推荐商品标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(width: 0.5, color: KColor.defaultBorderColor)
        ),
      ),
      child: Text(
        KString.recommendText,
        style: TextStyle(color: KColor.homeSubTitleTextColor),
      ),
    );
  }

  //商品推荐列表
  Widget _recommedList(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(280),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount:8,   //recommendList.length, 商品推荐长度数量
          itemBuilder: (context, index) {
            return _item(index, context);
          }
      ),
    );
  }

  Widget _item(index, context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: ScreenUtil().setWidth(280),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 0.5, color: KColor.defaultBorderColor),
          ),
        ),
        child: Column(
          children: <Widget>[
            //防止溢出
            Expanded(
              child: Image.network(
                recommendList[index]['image'], fit: BoxFit.cover,),
            ),
            Text(
              '￥${recommendList[index]['presentPrice']}',
              style: TextStyle(
                  color: KColor.presentPriceTextColor
              ),
            ),
            Text(
              '￥${recommendList[index]['oriPrice']}',
              style: KFont.oriPriceStyle,
            ),
          ],
        ),
      ),
    );
  }
}







