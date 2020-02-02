import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/reading_page.dart';
import 'package:flutter_image/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

//收藏页面
//inntechy 2019.12.27


class FavoritePage extends StatefulWidget{
  @override
  createState() => FavoritePageState();
}

class FavoritePageState extends State<FavoritePage>{
  var _listDataID = List();
  bool _idLoadFinished = false;
  @override
  Widget build(BuildContext context) {
    if(_idLoadFinished){
      return Scaffold(
        appBar: AppBar(title: Text('我的收藏'),),
        body: _createListView(),
      );
    }else return Scaffold();
  }

  @override
  void initState(){
    super.initState();
    getData();
  }

  //获取收藏列表
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _listDataID = List<String>.from(await prefs.get('favorList'));
    _idLoadFinished = true;
    setState(() {});
  }
  //删除指定的文章
  favorListDelAt(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorList', _listDataID);
  }

  Widget _createListView() {
    if(_listDataID.length == 0) return Center(child:Text('还没有收藏过文章呢，去首页看看吧'));
    else return ListView.builder(
      itemCount: _listDataID.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key:  Key('key${_listDataID[index]}'),
          child: ArticlesInfoCell(id: _listDataID[index]),
          direction: DismissDirection.endToStart,
          onDismissed: (direction){
            // 删除后刷新列表，以达到真正的删除
            _listDataID.removeAt(index);
            setState(() {});
            favorListDelAt(index);
          },
          background: Container(
            color: Colors.red,
            // 这里使用 ListTile 因为可以快速设置左右两端的Icon
            child: ListTile(
              trailing: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          confirmDismiss: (direction)async{
            var _confirmContent;
            var _alertDialog;
            if (direction == DismissDirection.endToStart) {
              // 从右向左  也就是删除
              _confirmContent = '确定取消收藏这篇文章吗？';
              _alertDialog = _createDialog(
                _confirmContent,
                () {
                  // 展示 SnackBar
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('取消成功'),
                    duration: Duration(milliseconds: 400),
                  ));
                  Navigator.of(context).pop(true);
                },
                () {
                  // 展示 SnackBar
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('保留成功'),
                    duration: Duration(milliseconds: 400),
                  ));
                  Navigator.of(context).pop(false);
                },
              );
            }
            var isDismiss = await showDialog(
                context: context,
                builder: (context) {
                  return _alertDialog;
                });
            return isDismiss;
          },
        );
      },
    );
  }
  //提示框
  Widget _createDialog(String _confirmContent, Function sureFunction, Function cancelFunction) {
    return CupertinoAlertDialog(
      title: Text('删除'),
      content: Text(_confirmContent),
      actions: <Widget>[
        FlatButton(onPressed: sureFunction, child: Text('确认',style: TextStyle(color: Colors.redAccent),)),
        FlatButton(onPressed: cancelFunction, child: Text('取消')),
      ],
    );
  }

}

//以下是listview 的 cell
class ArticleInfo{
  int id;
  String contentType;
  String title;
  String author;
  String photoUrl;
  String foreword;
}

class ArticlesInfoCell extends StatefulWidget{
  final id;
  ArticlesInfoCell({this.id});
  @override
  createState() => new ArticlesInfoCellState();
}

class ArticlesInfoCellState extends State<ArticlesInfoCell>{
  @override
  Widget build(BuildContext context) {
    
    if(!isLoadSuccess)return Container();
    else return InkWell(
      child: Container(
        height: 120,
        decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        margin: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Image(
              image: NetworkImageWithRetry(info.photoUrl),
              width: 130,
              height: 120,
              fit: BoxFit.fill,
            ),
            Expanded(
              child:
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      "${info.contentType}",
                      style: TextStyle(color: Color(0xffa9a9a9)),
                    ),
                    margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  Expanded(
                    child:  
                    Container(
                      child: Text("${info.title}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      margin: EdgeInsets.all(5),
                    ),
                  ),
                  Container(
                    child: Text(
                      "文 / "+"${info.author}",
                      style: TextStyle(color: Color(0xffa9a9a9)),
                    ),
                    margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                ],
              )
            )
          ],
        )
      ),
      onTap: ()=>_clickArticle(info.id),
    );
  }

  @override
  void initState(){
    super.initState();
    requestArticle();
  }
  
  //网络请求
  bool isExpanded = false;
  ArticleInfo info;
  bool isLoadSuccess = false;
  Future<void> requestArticle() async {
    try {
      var response =
          await Dio().get("http://ftp.yuask.cn:54321/api/article/"+widget.id.toString());
      info = new ArticleInfo();
      var data = response.data;
      info.id = data["ID_vol"];
      info.contentType = data["content_type"];
      info.title = data["title"];
      if(info.title.length > 14){
      }
      info.author = data["auth"];
      info.photoUrl = data["photo_url"];
      info.foreword = data["foreword"];
      isLoadSuccess = true;
    } on Exception {
      isLoadSuccess = false;
    } finally {
      if(mounted){
        setState(() {});
      }
    }
  }
  //文章跳转
  void _clickArticle(id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReadingPage(
                  vol: id,
                )));
  }
}