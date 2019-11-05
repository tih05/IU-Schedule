import 'package:flutter/material.dart';
import 'class.dart';

class LectureButton extends StatelessWidget {
  Class data;

  LectureButton(this.data);

  Color getColor(String type) {
    switch (type) {
      case "lecture":
        return new Color(0xffC82F2F); //0xff8A3A3A
      case "tutorial":
        return new Color(0xffF0D90B); //0xff2E6AA1
      case "lab":
        return new Color(0xff0973D4); //0xffD98232
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Stack(children: <Widget>[
          Container(
            color: getColor(data.type),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(data.timeStart,
                      style: new TextStyle(fontSize: 20, color: Colors.white))
                ]),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(data.name,
                    style: new TextStyle(fontSize: 24, color: Colors.white)),
              ],
            ),
          ),
          Positioned(
            bottom: 2,
            right: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(data.timeEnd,
                    style: new TextStyle(fontSize: 20, color: Colors.white)),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
