import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:reader_parser2/reader_parser2.dart';
import 'package:reader_parser2/h_parser/h_parser.dart';
import 'test_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await ReaderParser2.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
        floatingActionButton: FloatingActionButton(child: Text("click"),onPressed: (){
          parseTest();
        },),
      ),
    );
  }

  void parseTest(){
    var parser = HParser(DATA);
    var r1 = parser.parseRuleString("tag.h1.0@ownText");
    print(DateTime.now());
    var bId = parser.parseRuleRaw("id.list@dd");
    var bSize = parser.queryBatchSize(bId);
    for(var i=0;i< bSize;i++){
      var r2 = parser.parseRuleStringForParent(bId, "a@text", i);
      var r3 = parser.parseRuleStringForParent(bId, "a@href", i);
      print("${r2}->${r3}");
    }
    parser.destoryBatch(bId);
    parser.destory();
    print(r1);
    print(DateTime.now());
  }
}
