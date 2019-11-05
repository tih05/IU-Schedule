import 'package:flutter/material.dart';
import 'main.dart';
class NavButton extends StatelessWidget {
  NavButtonModel state;
  List<NavButtonModel> pages;
  DayPageState context;
  NavButton(this.state, this.pages, this.context);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          this.context.setState(() {
            for (NavButtonModel model in this.context.pages)
              model.isSelected = false;
            state.isSelected = true;
            this.context.pageId = state.id;
            this.context.pageController.animateToPage(state.id,
                duration: Duration(milliseconds: 300), curve: Curves.decelerate);
          });
        },
        child: new Text(state.text,
            style: new TextStyle(
                color: state.isSelected ? Color(0xFF2D87F1) : Colors.white,
                fontSize: 29)));
  }
}

void pressed() {
  print("press");
}



Widget buildNavBar(DayPageState context) {
  List<Widget> list = new List<Widget>();
  for (NavButtonModel state in context.pages) {
    list.add(new NavButton(state, context.pages, context));
  }
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: list),
  );
}


class NavButtonModel {
  int id;
  bool isSelected;
  String text;

  NavButtonModel(this.id, this.isSelected, this.text);
}