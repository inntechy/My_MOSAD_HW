import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: 'Helo',
      home: new FeedFlow(),
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
}

class FeedFlow extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new FeedFlowState();
  }
}

//主页面框架 appbar和底栏的配置信息在这
class FeedFlowState extends State<FeedFlow> {
  int _battaryLevel = 66;
  static const batteryMethonChannel = const MethodChannel('inntechy.hw4/battery');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Helo'),
        leading: Icon(Icons.camera_alt),
        actions: <Widget>[
          GestureDetector(
            onTap: _battaryIconOnTap,
            child: Container(
              child: Row(
                children: <Widget>[
                  Icon(Icons.battery_unknown),
                  Text('$_battaryLevel%')
                ],
              ),
              padding: EdgeInsets.all(16),
            ),
          )
        ],
        textTheme: TextTheme(
          title: TextStyle(
            fontFamily: 'Archyedt',
            color: Colors.black,
            fontSize: 25,
          ),
        ),
      ),
      body: FeedFlowListView(),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Icon(Icons.home,color: Colors.black,),),
              Expanded(child: Icon(Icons.search, color: Colors.grey,),),
              Expanded(child: Icon(Icons.add_box, color: Colors.grey,),),
              Expanded(child: Icon(Icons.favorite, color: Colors.grey,),),
              Expanded(child: Icon(Icons.account_box, color: Colors.grey,),),
            ],
          ),
        )
      ),
    );
  }

  //处理电池图标点击事件
  void _battaryIconOnTap() async {
    int battery = await _getBatteryLevel();
    setState(() {
      _battaryLevel = battery;
    });
  }

  //通过Channel获取电量信息
  Future<int> _getBatteryLevel() async {
    try {
      final int result = await batteryMethonChannel.invokeMethod('getBatteryLevel');
      return result;
    }on PlatformException catch (e) {
      log('Faild to get battery level: "${e.message}"');
      return -1;
    }
  }
}

//主界面的listview及其状态
class FeedFlowListView extends StatefulWidget{
  @override
  createState() => new FeedFlowListViewState();
}

class FeedFlowListViewState extends State<FeedFlowListView>{
  @override
  Widget build(BuildContext context){
    return ListView.builder(
      //padding: const EdgeInsets.all(8),
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) {  
        return _createPostView();
      }
    );
  }

  //返回一个cell的container
  Container _createPostView(){
    Container postView = new Container(
      child: Column(
        children: <Widget>[
          //头像 id行
          Row(
            //mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                //设置头像padding
                padding: const EdgeInsets.all(16),
                child: CircleAvatar(
                  //radius: 50,
                  backgroundImage: AssetImage('assets/imgs/dog.jpeg'),
                ),
              ),
              Text(
                'Andrew',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          //大图
          InkWell(
            child: Image(
              image: AssetImage('assets/imgs/timg.jpeg'),
            ),
            onTap: _pushDetail,
          ),
          
          //点赞行
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16),
                child: Icon(Icons.favorite_border),
              ),
              Container(
                //padding: const EdgeInsets.all(16),
                child: Icon(Icons.crop_3_2),
              ),
            ],
          ),
          //评论行
          Row(
            children: <Widget>[
              Container(
                //设置头像padding
                padding: const EdgeInsets.all(16),
                child: CircleAvatar(
                  //radius: 50,
                  backgroundImage: AssetImage('assets/imgs/dog.jpeg'),
                ),
              ),
              Expanded(
                child:new TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add a comment',
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
    return postView;
  }

  //跳转函数 跳转到图片详情页面
  void _pushDetail(){
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Andrew'),
               textTheme: TextTheme(
                title: TextStyle(
                  fontFamily: 'Archyedt',
                  color: Colors.black,
                  fontSize: 25,
                ),
               ),
            ),
            body:Center(
              child:Image(image: AssetImage('assets/imgs/timg.jpeg'),)
            ), 
          );
        }
      )
    );
  }
}


