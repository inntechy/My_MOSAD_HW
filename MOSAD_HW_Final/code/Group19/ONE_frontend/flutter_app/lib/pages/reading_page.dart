import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image/network.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';

//文章阅读页面
//inntechy 2019.12.24

//文章类
class ArticleContent {
  int id;
  String contentType;
  String title;
  String author;
  String photoUrl;
  String content;
}

//主页面
class ReadingPage extends StatefulWidget{
  final vol;
  ReadingPage({this.vol});//创建时，传递vol参数
  @override
  createState() => new ReadingPageState();
}

class ReadingPageState extends State<ReadingPage>{
  SharedPreferences prefs;
  //pop菜单相关
  final _scanffoldKey = GlobalKey<ScaffoldState>();
  var _fontsize = 18.0;
  var _fontFamily = 'Ming';
  void _showMenuSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (context1,state){
              return new Container(
                height: 280,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text("字体大小",style: TextStyle(fontSize: 22),),
                      margin: EdgeInsets.all(20),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(15),),
                        Text("小"),
                        Padding(padding: EdgeInsets.all(15),),
                        Expanded(
                          child: CupertinoSlider(
                            value: _fontsize,
                            min: 12,
                            max: 32,
                            //divisions: 100,
                            onChanged: (double newvalue){
                              _fontsize = newvalue;
                              setState(() {});
                              state((){});
                            },
                            onChangeEnd: (double newvalue){
                              saveConfigs(articleFontSize: newvalue);
                            },
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(15),),
                        Text("大"),
                        Padding(padding: EdgeInsets.all(15),),
                      ],
                    ),
                    Container(
                      child: Text("字体选择",style: TextStyle(fontSize: 22),),
                      margin: EdgeInsets.all(10),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            child: CupertinoButton(
                              child: Text('宋体',
                                style: TextStyle(
                                  fontFamily: 'Song'
                                ),
                              ),
                              color: Colors.blue,
                              onPressed: (){
                                _fontFamily = 'Song';
                                setState(() {});
                                saveConfigs(articleFontFamily: _fontFamily);
                              },
                            ),
                          )
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            child: CupertinoButton(
                              child: Text('明体',
                                style: TextStyle(
                                  fontFamily: 'Ming'
                                ),
                              ),
                              color: Colors.blue,
                              onPressed: (){
                                _fontFamily = 'Ming';
                                setState(() {});
                                saveConfigs(articleFontFamily: _fontFamily);
                              },
                            ),
                          )
                        ),
                      ],
                    )
                  ],
                )
              );
            },
          );
          
        });
  }

  //网络请求
  bool isExpanded = false;
  ArticleContent content;
  bool isLoadSuccess = false;
  Future<void> requestArticle() async {
    try {
      var response =
          await Dio().get("http://ftp.yuask.cn:54321/api/article/"+widget.vol.toString());
      content = new ArticleContent();
      var data = response.data;

      content.id = data["ID_vol"];
      content.contentType = data["content_type"];
      content.title = data["title"];
      content.author = data["auth"];
      content.photoUrl = data["photo_url"];
      content.content = data["content"];
      isLoadSuccess = true;
    } on Exception {
      isLoadSuccess = false;
    } finally {
      setState(() {});
      resetFavorIcon();
    }
  }

  //初始化
  @override
  void initState() {
    super.initState();
    initPrefs();
    requestArticle();
  }
  //ui
  List<IconData> _favorIcons = new List()..add(Icons.bookmark_border)..add(Icons.bookmark);
  var _iconIndex = 0;
  @override
  Widget build(BuildContext context) {
    if(!isLoadSuccess){
      return Scaffold();
    }else return new Scaffold(
      key: _scanffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("${content.contentType}"),
            floating: true,
            actions: <Widget>[
              GestureDetector(
                onTap: (){
                  _setFavoriteArticle(idVol: content.id);
                },
                child: Container(
                  child: Icon(_favorIcons[_iconIndex]),
                  //child: Text(_iconIndex.toString()),
                  padding: EdgeInsets.all(16),
                ),
              ),
              GestureDetector(
                onTap: () {
                  var url = "http://www.wufazhuce.com/one/"+widget.vol.toString().substring(0,4);
                  ShareExtend.share(url, "text");
                },
                child: Container(
                  child: Icon(Icons.share),
                  padding: EdgeInsets.all(16),
                ),
              ),
              GestureDetector(
                onTap: () => _showMenuSheet(),
                child: Container(
                  child: Icon(Icons.more_vert),
                  padding: EdgeInsets.all(16),
                ),
              ),
            ],
            //flexibleSpace: Placeholder(),
            //expandedHeight: 200,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index){
                switch (index) {
                  case 0: //picture
                    return Image(image: NetworkImageWithRetry(content.photoUrl));
                    break;
                  case 1://title
                    return Container(
                      child: Text("${content.title}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      margin: EdgeInsets.fromLTRB(20, 20, 0, 5),
                    );
                    break;
                  case 2://author
                    return Container(
                      child: Text(
                        "文 / "+"${content.author}",
                        style: TextStyle(color: Color(0xffa9a9a9)),
                      ),
                      margin: EdgeInsets.fromLTRB(20, 5, 0, 20),
                    );
                    break;
                  case 3:
                    return Container(
                      child: Text(
                        "${content.content}",
                        style: TextStyle(
                          fontSize: _fontsize,
                          fontFamily: _fontFamily,
                          //fontWeight: FontWeight.bold,
                        ),
                        strutStyle: StrutStyle(
                          height: 2
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    );
                    break;
                  default:return null;
                }
              },
              childCount: 4,
            ),
          )
        ],
      ),
    );
  }

  //初始化prefs
  initPrefs() async {
    try{
      prefs = await SharedPreferences.getInstance();
    }
    finally{
      resetUIbySettings();
    }
  }

  //将字体设置储存于本地
  saveConfigs({String articleFontFamily, double articleFontSize}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(articleFontFamily != null)prefs.setString('fontFamily', articleFontFamily);
    if(articleFontSize != null)prefs.setDouble('fontSize', articleFontSize);
  }

  //获取本地设置
  getLocal({key}) async {
    prefs = await SharedPreferences.getInstance();
    var result = await prefs.get(key);
    return result;
  }
  //按设置更新ui
  resetUIbySettings() async {
    var ff = await getLocal(key:'fontFamily');
    var fs = await getLocal(key:'fontSize');
    if(ff != null){
      _fontFamily = ff;
    }
    if(fs != null){
      _fontsize = fs;
    }
    setState(() {});
  }
  //收藏文章到本地or取消收藏
  void _setFavoriteArticle({idVol}) async {
    bool flag;
    if(_iconIndex == 0){
      _iconIndex = 1;
      flag = true;
    }else{
      _iconIndex = 0;
      flag = false;
    }
    setState(() {});
    List favorList = await prefs.get('favorList');
    List<String> tempList = new List();
    if(favorList!=null) tempList = List<String>.from(favorList);
    if(flag){//点击时是未收藏状态
      tempList.add(idVol.toString());
    }else{
      tempList.remove(idVol.toString());
    }
    prefs.setStringList('favorList', tempList);
  }
  //判断是否收藏过
  Future<bool> _isFavor({int idVol}) async {
    List favorList = await getLocal(key: 'favorList');
    for (var items in favorList) {
      if(items == idVol.toString())return true;
    }
    return false;
  }
  //更新右上角收藏图标
  resetFavorIcon() async {
    try{
      if(await _isFavor(idVol:content.id)){
        _iconIndex = 1;
      }
    }finally{
      setState(() {});
    }
  }
}