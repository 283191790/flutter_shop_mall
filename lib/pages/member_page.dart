import 'package:flutter/material.dart';
import '../config/index.dart';

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(KString.memberTitle),//会员中心
      ),
      body: ListView(
        children:<Widget>[
          _topHeader(),
          _orderTitle(),
          _orderType(),
          _actionList(),
        ],
        ),
    );
  }
}

Widget _topHeader() {
  return Container(
  );
}

Widget _orderTitle() {
  return Container(
  );
}

Widget _orderType() {
  return Container(
  );
}

Widget _actionList() {
  return Container(
  );
}