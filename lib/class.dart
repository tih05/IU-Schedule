import 'dart:convert';

class Class {
  String name;
  String timeStart;
  String timeEnd;
  String type;
}

Map<String, List<Class>> getClassesFromJSON(String json) {
  Map<String, List<Class>> map = new Map<String, List<Class>>();
  List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri"];

    var data = jsonDecode(json);

  //print(data);
  for (String day in days) {
    if (data[day] != null) {
      List<Class> classes = new List<Class>();
      var clData = data[day];
      for (dynamic d in clData) {
        Class cl = new Class();
        cl.name = d['name'];
        cl.timeStart = d['timeStart'];
        cl.timeEnd = d['timeEnd'];
        cl.type = d['type'];
        classes.add(cl);
      }
      map.putIfAbsent(day, () => classes);
    }
  }

  return map;
}
