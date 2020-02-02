import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';

//目录页面
//inntechy 2019.12.26

//封面类
class CoverPageItem {
  int vol;
  String year;
  String day;
  String month;
  String photoUrl;
}

//主页面
class VolListPage extends StatefulWidget {
  final Function(int) _selectOneVol;

  VolListPage(this._selectOneVol);
  @override
  createState() => VolListPageState();
}

class VolListPageState extends State<VolListPage> {
  List<CoverPageItem> _pageItems = new List();

  @override
  void initState() {
    super.initState();
    requestMenu();
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ONE IS ALL"),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, //每行2列
            childAspectRatio: 1.15 //显示区域宽高相等
            ),
        itemCount: _pageItems.length,
        itemBuilder: (context, index) => cells(context, index),
      ),
    );
  }

  //cell
  Widget cells(BuildContext context, int index) {
    return InkWell(
        child: Container(
          margin: EdgeInsets.all(10),
          //adding: EdgeInsets.all(10),
          //color: Color.fromARGB(0xff, 155, 155, 155),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Column(
            children: <Widget>[
              Image(image: NetworkImageWithRetry(_pageItems[index].photoUrl)),
              Expanded(
                  child: Center(
                child: Text(
                  _pageItems[index].year +
                      "/" +
                      _pageItems[index].month +
                      "/" +
                      _pageItems[index].day,
                  style: TextStyle(fontSize: 18, color: Color(0xffa9a9a9)),
                ),
              ))
            ],
          ),
        ),
        onTap: () {
          widget._selectOneVol(_pageItems[index].vol);
        });
  }

  //网络请求
  bool isExpanded = false;
  bool isLoadSuccess = false;
  Future<void> requestMenu() async {
    try {
      var response = await Dio().get("http://ftp.yuask.cn:54321/api/menu_list");
      var data = response.data;
      for (var item in data) {
        CoverPageItem temp = new CoverPageItem();
        temp.vol = item["ID_vol"];
        temp.year = item["release_year"].toString();
        temp.month = (item["release_month"] < 10 ? "0" : "") +
            item["release_month"].toString();
        temp.day = (item["release_day"] < 10 ? "0" : "") +
            item["release_day"].toString();
        temp.photoUrl = item["photo_url"];
        _pageItems.add(temp);
      }
      isLoadSuccess = true;
    } on Exception {
      isLoadSuccess = false;
    } finally {
      setState(() {});
    }
  }
}
