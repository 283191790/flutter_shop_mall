import 'package:flutter/material.dart';
import 'package:flutter_shop_mall/service/service_method.dart';
import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop_mall/config/color.dart';
import 'package:flutter_shop_mall/config/string.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



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
            List<Map> category = (data['data']['category']as List).cast(); //分类
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