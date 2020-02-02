import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'reading_page.dart';
import 'package:flutter_image/network.dart';
import 'big_photo.dart';
import 'package:share_extend/share_extend.dart';
import 'package:flutter_app/model/weather.dart';
import 'package:transparent_image/transparent_image.dart';

class ArticleContent {
  int id;
  String contentType;
  String title;
  String author;
  String photoUrl;
  String foreWord;
}

class ReqContent {
  int vol;
  int year;
  int month;
  int day;
  String motto;
  String mottoAuthor;
  String photoUrl;
  String photoAuthor;
  int articleCounts;
  List<ArticleContent> articleContent;
}

class MainScreen extends StatefulWidget {
  final _mainScreenState = MainScreenState();
  void switchToVol(int vol) {
    _mainScreenState._pageController
        .jumpToPage(_mainScreenState._todayVol - vol);
  }

  @override
  createState() => _mainScreenState;
}

class MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  final _pageController = PageController();
  int _todayVol;

  Future<void> _requestTodayVol() async {
    try {
      var response =
          await Dio().get("http://ftp.yuask.cn:54321/api/today_list");
      _todayVol = response.data["vol"];
      setState(() {});
    } on Exception {}
  }

  void _jumpToToday() {
    _pageController.animateToPage(0,
        curve: Curves.easeInOut, duration: Duration(milliseconds: 200));
  }

  // 首页加载后让其一直保持，在目录页选择就可以直接跳转
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _requestTodayVol();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget mainScreenWidget;
    if (_todayVol == null) {
      mainScreenWidget = Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: RefreshIndicator(
          child: ListView(
            children: <Widget>[
              Center(
                  child: Text(
                "Loading failed, slide down to refresh",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              )),
            ],
          ),
          onRefresh: _requestTodayVol,
        ),
      );
    } else {
      mainScreenWidget = PageView.builder(
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            return Page(index == 0, _todayVol - index, _jumpToToday);
          });
    }
    return mainScreenWidget;
  }
}

class Page extends StatefulWidget {
  final bool _isToday;
  final int _vol;
  final Function() _jumpToToday;
  Page(this._isToday, this._vol, this._jumpToToday);

  @override
  createState() => PageState();
}

class PageState extends State<Page> {
  static const _monthAry = [
    "Jan.",
    "Feb.",
    "Mar.",
    "Apr.",
    "May.",
    "June.",
    "July.",
    "Aug.",
    "Sept.",
    "Oct.",
    "Nov.",
    "Dec."
  ];
  bool _isExpanded = false;
  ReqContent _content;
  bool _isLoadSuccess = false;
  Future<String> _weather;//获取天气
  String weatherData;

  Future<void> requestOneArticle(int vol) async {
    try {
      var response = await Dio()
          .get("http://ftp.yuask.cn:54321/api/list/" + vol.toString());

      _content = new ReqContent();
      var data = response.data;

      _content.vol = data["vol"];
      _content.year = data["year"];
      _content.month = data["month"];
      _content.day = data["day"];
      _content.motto = data["motto"];
      _content.mottoAuthor = data["motto_auth"];
      _content.photoUrl = data["photo_url"];
      _content.photoAuthor = data["photo_auth"];
      _content.articleCounts = data["articles_count"];

      _content.articleContent = List<ArticleContent>(_content.articleCounts);
      var article = data["articles_list"];
      for (int i = 0; i < _content.articleCounts; ++i) {
        var temp = ArticleContent();
        temp.id = article[i]["ID_vol"];
        temp.contentType = article[i]["content_type"];
        temp.title = article[i]["title"];
        temp.author = article[i]["auth"];
        temp.photoUrl = article[i]["photo_url"];
        temp.foreWord = article[i]["foreword"];
        _content.articleContent[i] = temp;
      }

      _isLoadSuccess = true;
    } on Exception {
      _isLoadSuccess = false;
    } finally {
      if(mounted){
        setState(() {});
      }
    }
  }

  void _clickArticle(id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReadingPage(
                  vol: id,
                )));
  }

  void _jumpToBigPhoto(String url) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BigPhoto(url)));
  }

  @override
  void initState() {
    super.initState();
    requestOneArticle(widget._vol);
    var temp = WeatherData();
    _weather = temp.getWeatherStr();//获取天气
  }

  @override
  Widget build(BuildContext context) {
    Widget titleWidget;
    if (_content != null) {
      titleWidget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(
                text: _content.day.toString(),
                style: TextStyle(fontSize: 40, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: _monthAry[_content.month - 1],
                      style: TextStyle(fontSize: 15)),
                  TextSpan(
                      text: _content.year.toString(),
                      style: TextStyle(fontSize: 15)),
                ]),
          ),
          if (!widget._isToday)
            ButtonTheme(
              minWidth: 40,
              child: FlatButton(
                child: Text("今天"),
                textColor: Colors.black,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                onPressed: widget._jumpToToday,
              ),
            )
            else FutureBuilder(
              future: _weather,
              builder: (context, snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(child: Text('加载中…',style: TextStyle(fontSize: 12,color: Colors.grey),));
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('网络请求出错',style: TextStyle(fontSize: 12,color: Colors.grey),),
                      );
                    }
                    return Text(snapshot.data,style: TextStyle(fontSize: 12,color: Colors.grey),);
                  default:
                    return null;
                }
              },
            )
        ],
      );
    }

    Widget bodyWidget;
    if (_content == null) {
      bodyWidget = Align(
        alignment: Alignment(0, -1),
        child: Text(
          "Loading...",
          style: TextStyle(fontSize: 30, color: Colors.grey),
        ),
      );
    } else {
      if (!_isLoadSuccess) {
        bodyWidget = ListView(
          children: <Widget>[
            Center(
                child: Text(
              "Loading failed, slide down to refresh",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ))
          ],
        );
      } else {
        bodyWidget = ListView.separated(
            itemCount: _content.articleCounts + 2,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: Color.fromRGBO(230, 230, 230, 1),
                thickness: 6,
                height: 6,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              // 头图部分
              if (index == 0) {
                return Column(
                  children: <Widget>[
                    GestureDetector(
                      child: FadeInImage(
                        height: 240,
                        placeholder: MemoryImage(kTransparentImage),
                          image: NetworkImageWithRetry(_content.photoUrl)),
                      onTap: () {
                        _jumpToBigPhoto(_content.photoUrl);
                      },
                    ),
                    Center(
                      child: Padding(
                        child: Text(
                          "摄影 | " + _content.photoAuthor,
                          style: TextStyle(color: Colors.grey),
                        ),
                        padding: EdgeInsets.all(15),
                      ),
                    ),
                    Center(
                      child: Padding(
                        child: Text(
                          _content.motto,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        padding: EdgeInsets.only(
                            left: 40, right: 40, top: 15, bottom: 15),
                      ),
                    ),
                    Center(
                      child: Padding(
                        child: Text(
                          _content.mottoAuthor,
                          style: TextStyle(color: Colors.grey),
                        ),
                        padding: EdgeInsets.only(
                            left: 40, right: 40, top: 15, bottom: 15),
                      ),
                    ),
                  ],
                );
              }
              // 伸缩列表
              else if (index == 1) {
                var previewList = List<Widget>(_content.articleCounts);
                for (int i = 0; i < previewList.length; ++i) {
                  previewList[i] = InkWell(
                    onTap: () {
                      _clickArticle(_content.articleContent[i].id);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 14,
                            ),
                            padding: EdgeInsets.only(right: 10),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(_content.articleContent[i].contentType),
                              Text(_content.articleContent[i].title)
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }
                return ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      this._isExpanded = !isExpanded;
                    });
                  },
                  children: <ExpansionPanel>[
                    ExpansionPanel(
                      // 伸缩列表头
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return Align(
                          alignment: Alignment(-1, 0), // 垂直居中
                          child: Padding(
                            child: Text(
                              "一个 VOL." + _content.vol.toString(),
                              style: TextStyle(
                                  color: Color.fromRGBO(80, 80, 80, 1)),
                            ),
                            padding: EdgeInsets.only(left: 30),
                          ),
                        );
                      },
                      // 伸缩列表主体
                      body: Column(
                        children: previewList,
                      ),
                      canTapOnHeader: true,
                      isExpanded: this._isExpanded,
                    )
                  ],
                );
              }
              // 主体文章列表
              else {
                var article = _content.articleContent[index - 2];
                return InkWell(
                  onTap: () {
                    _clickArticle(article.id);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // 分类
                        Padding(
                          padding: EdgeInsets.all(0),
                          child: Center(
                            child: Text(
                              "- " + article.contentType + " -",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),

                        // 题目
                        Text(
                          article.title,
                          style: TextStyle(fontSize: 22),
                        ),

                        // 作者
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            article.author,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),

                        // 图片
                        Image(image: NetworkImageWithRetry(article.photoUrl)),

                        // 前言
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 30),
                          child: Text(
                            article.foreWord,
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ), // ma

                        // 日期和分享
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            if (widget._isToday)
                              Text(
                                "今天",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              )
                            else
                              Text(
                                _content.month.toString() +
                                    "月" +
                                    _content.day.toString() +
                                    "日",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            Row(
                              children: <Widget>[
                                InkWell(
                                  child: Icon(
                                    Icons.share,
                                    color: Colors.grey,
                                  ),
                                  onTap: (){
                                    var url = "http://www.wufazhuce.com/one/"+_content.vol.toString();
                                    ShareExtend.share(url, "text");
                                  },
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
            });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: titleWidget,
      ),
      body: RefreshIndicator(
        child: bodyWidget,
        onRefresh: () async {
          requestOneArticle(widget._vol);
        },
      ),
    );
  }
}
