
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'class.dart';
import 'lecture_button.dart';
import 'nav_bar.dart';

void main() {

  runApp(MyApp());
}

class DayPage extends StatefulWidget {
  @override
  DayPageState createState() => DayPageState();

}

class DayPageState extends State<DayPage> {
  List<NavButtonModel> pages = [
    NavButtonModel(0, false, "Mon"),
    NavButtonModel(1, false, "Tue"),
    NavButtonModel(2, false, "Wed"),
    NavButtonModel(3, false, "Thu"),
    NavButtonModel(4, false, "Fri")
  ];
  bool startFlag = true;
  int pageId = 0;
  String JsonURL =
      "https://jsonblob.com/api/jsonBlob/673f49ac-57a2-11e9-9f99-5dd508785bc0";
  PageController pageController;
  DayPageState() {
    if (startFlag) {
      pageId = DateTime.now().weekday - 1;
      if (pageId > 4) pageId = 0;
      pages[pageId].isSelected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) => new Container();
    var scaffold = new Scaffold(
        backgroundColor: new Color(0xFF323232),
        appBar: AppBar(
            brightness: Brightness.dark,
            title: Text("IU Schedule"),
            backgroundColor: new Color(0xFF323232),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => refresh(this),
              )
            ],
            leading: IconButton(
                icon: Icon(Icons.apps),
                onPressed: () =>
                    showDialog(context: context, builder: getJsonURLDialog))),
        body: Padding(
            padding: EdgeInsets.only(top: getStatusbarHeight(context) + 20),
            child: FutureBuilder(future: getJson(), builder: getPageView)),
        bottomNavigationBar: buildNavBar(this));

    return scaffold;
  }

  Future getJson() async {
    final directory = await getApplicationDocumentsDirectory();
    bool exist = await File(directory.path + '/IUSchedule.json').exists();
    if (exist)
      return File(directory.path + '/IUSchedule.json').readAsString();
    else {
      return http.get(JsonURL);
    }
  }

  void getJsonURLDialog(BuildContext context) {
    AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              autofocus: true,
              decoration:
                  new InputDecoration(labelText: 'JSON LINK', hintText: ''),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context);
            }),
        new FlatButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }

  Widget getPageView(BuildContext context, AsyncSnapshot snap) {
    List<Widget> list = new List();
    Map<String, List<Class>> data;
    if (snap.data is http.Response)
      data = getClassesFromJSON(snap.data.body);
    else
      data = getClassesFromJSON(snap.data);


      for (NavButtonModel model in pages) {
        if (data[model.text] != null) {
          List<Class> classes = data[model.text];
          list.add(new Scaffold(
            body: new ListView.builder(
                itemCount: classes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(child: new LectureButton(classes[index]));
                }),
            backgroundColor: new Color(0xFF323232),
          ));
      }
    }

    pageController = new PageController(initialPage: pageId);
    var pageView = new PageView(
        controller: pageController,
        onPageChanged: (id) {
          setState(() {
            for (NavButtonModel model in pages) model.isSelected = false;
            pages[id].isSelected = true;
          });
        },
        children: list);

    return pageView;
  }

  double getStatusbarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  void refresh(State state) async {
    final directory = await getApplicationDocumentsDirectory();
    File file = new File(directory.path + '/IUSchedule.json');
    http.Response response = await http.get(JsonURL);
    await file.writeAsString(response.body);
    state.setState(() {});
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      debugShowCheckedModeBanner: false,
      home: new DayPage(),
    );
  }
}
