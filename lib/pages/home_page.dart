import 'package:flutter/material.dart';
import 'package:flutter_shop_mall/config/font.dart';
import 'package:flutter_shop_mall/model/category_model.dart';
import 'package:flutter_shop_mall/service/service_method.dart';
import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop_mall/config/color.dart';
import 'package:flutter_shop_mall/config/string.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/index.dart';
import '../provide/category_provide.dart';
import '../provide/current_index_provide.dart';
import 'package:provide/provide.dart';


class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {

  //火爆专区分页
  int page = 1;
  //火爆专区数据
  List<Map>hotGoodsList = [];

  //防止刷新处理，保持当前状态
  @override
  bool get wantKeepAlive => true;

  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  //diff

  @override
  void initState() {
    super.initState();
    print("首页刷新了");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      body: FutureBuilder(
        future: request('homePageContent', formData: null),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            print(data);
            List<Map> swiperDataList =
                (data['data']['slides'] as List).cast(); //Swipe图
            List<Map> navigatorList =
                (data['data']['category'] as List).cast(); //分类
            List<Map> recommendList =
                (data['data']['recommend'] as List).cast(); //商品推荐
            List<Map> floor1 = (data['data']['floor1'] as List).cast(); //底部商品推荐
            Map fp1 = data['data']['floor1Pic']; //广告

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
                  FloorPic(
                    floorPic: fp1,
                  ),
                  Floor(
                    floor: floor1,
                  ),
                  _hotGoods(),
                ],
              ),
              loadMore: () async {
                print("开始加载更多");
                _getHotGoods();
              },
            );
          } else {
            return Center(
              child: Text('加载中'),
            );
          }
        },
      ),
    );
  }

  void _getHotGoods(){
    var formPage ={'page':page};
    request("getHotGoods",formData: formPage).then((val){

      var data = json.decode(val.toString());
      List<Map> newGoodsList=(data['data']as List).cast();
      //设置火爆专区数据列表
      setState(() {
        hotGoodsList.addAll(newGoodsList);
      });

    });

  }
  //火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration:BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(width: 0.5,color: KColor.defaultBorderColor),
      )
    ) ,
    //火爆专区
    child: Text(KString.hotGoodsTitle,style: TextStyle(color: KColor.homeSubTitleTextColor),),
  );



  //火爆专区子项
  Widget _wrapList(){
    if(hotGoodsList.length!=0){
      List<Widget> ListWidget = hotGoodsList.map((val){

        return InkWell(
          onTap: (){
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children:<Widget>[
                Image.network(
                  val['image'],
                  width: ScreenUtil().setWidth(375),
                  height: 200,
                    fit: BoxFit.cover,
                ),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['presentPrice']}',style: TextStyle(color: KColor.presentPriceTextColor),),
                    Text('￥${val['oriPrice']}',style: TextStyle(color: KColor.oriPriceTextColor),),
                  ],
                )
              ]
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,
          children: ListWidget,
      );

    }else{
      return Text('');
    }



  }
  //火爆专区组合
  Widget _hotGoods(){
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList(),
        ],
      ),

    );
  }
}

//轮播组建编写
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;

  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {},
              child: Image.network(
                "${swiperDataList[index]['image']}",
                fit: BoxFit.cover,
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
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item, index) {
    
    return InkWell(
      onTap: () {
        //跳转分类页面
        _goCategory(context, index, item['firstCategoryId']);
      },
      child: 
      
      Column(
        children: <Widget>[
          Container(
            width:ScreenUtil().setHeight(85),
            child:Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          ),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (navigatorList.length > 10) {
      //判断分类个数
      navigatorList.removeRange(10, navigatorList.length);
    }

    var tempIndex = -1;
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5.0),
      //分类数量
      height: ScreenUtil().setHeight(140),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        //禁止滚动
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: navigatorList.map((item) {
          tempIndex++;
          return _gridViewItemUI(context, item, tempIndex);
        }).toList(),
      ),
    );
  }
  void _goCategory(context,int index,String categoryId) async{
    await request('getCategory',formData: null).then((val){
      var data = json.decode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      List list = category.data;
      Provide.value<CategoryProvide>(context).changeFirstCategory(categoryId, index);
      Provide.value<CategoryProvide>(context).getSecondCategory(list[index].secondCategoryVO, categoryId);
      Provide.value<CurrentIndexProvide>(context).changeIndex(1);
    });


  }
}

//商品标题
class RecommendList extends StatelessWidget {
  final List recommendList;

  RecommendList({Key key, this.recommendList}) : super(key: key);

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
            bottom: BorderSide(width: 0.5, color: KColor.defaultBorderColor)),
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
          itemCount: 8, //recommendList.length, 商品推荐长度数量
          itemBuilder: (context, index) {
            return _item(index, context);
          }),
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
                recommendList[index]['image'],
                fit: BoxFit.cover,
              ),
            ),
            Text(
              '￥${recommendList[index]['presentPrice']}',
              style: TextStyle(color: KColor.presentPriceTextColor),
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

//商品中间广告
class FloorPic extends StatelessWidget {
  final Map floorPic;

  FloorPic({Key key, this.floorPic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: InkWell(
        child: Image.network(
          floorPic['PICTURE_ADDRESS'],
          fit: BoxFit.cover,
        ),
        onTap: () {},
      ),
    );
  }
}

//商品推荐下层
class Floor extends StatelessWidget {
  List<Map> floor;

  Floor({Key key, this.floor}) : super(key: key);

  void jumpDetail(context,String goodId){
    //跳转到详情界面
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          //左侧商品
          Expanded(
            child: Column(
              children: <Widget>[
                //左上角大图
                Container(
                  padding: EdgeInsets.only(top: 4),
                  height: ScreenUtil().setHeight(400),
                  child: InkWell(
                    child: Image.network(
                      floor[0]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: (){
                      jumpDetail(context,floor[0]['goodsId']);
                    },
                  ),
                ),
                //左下角小图
                Container(
                  padding: EdgeInsets.only(top: 1,right: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                      floor[1]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: (){
                      jumpDetail(context,floor[1]['goodsId']);
                    },
                  ),
                )

              ],
            ),
          ),
          //右侧商品
          Expanded(
            child: Column(
              children: <Widget>[
                //右上角图
                Container(
                  padding: EdgeInsets.only(top: 1,left: 1,bottom: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                      floor[2]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: (){
                      jumpDetail(context,floor[2]['goodsId']);
                    },
                  ),
                ),
                //右中间图
                Container(
                  padding: EdgeInsets.only(top: 1,left: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                      floor[3]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: (){
                      jumpDetail(context,floor[3]['goodsId']);
                    },
                  ),
                ),
                //右下角图
                Container(
                  padding: EdgeInsets.only(top: 1,left: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                      floor[4]['image'],
                      fit: BoxFit.cover,
                    ),
                    onTap: (){
                      jumpDetail(context,floor[4]['goodsId']);
                    },
                  ),
                )

              ],
            ),
          ),

        ],
      ),
    );
  }
}

