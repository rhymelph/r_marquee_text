import 'package:flutter/material.dart';
import 'package:r_marquee_text/r_marquee_text.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '小麦部',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
           Center(
             child: RMarqueeText(
              direction: RMarqueeTextDirection.right,
              text: '羊肉串，10块5串',
          ),
           ),
          SizedBox(
            height: 20,
          ),
          RMarqueeText(
            direction: RMarqueeTextDirection.left,
            text: '煎饼果子，6块一个',
          ),
          SizedBox(
            height: 20,
          ),
          RMarqueeText(
            direction: RMarqueeTextDirection.top,
            text: '凉鞋，5块一双',
          ),
          SizedBox(
            height: 20,
          ),
          RMarqueeText(
            direction: RMarqueeTextDirection.bottom,
            text: '茶叶蛋，1.5块一个',
          ),
        ],
      ),
    );
  }
}