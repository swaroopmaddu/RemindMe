import 'package:flutter/material.dart';
import 'package:remindme/home.dart';
import 'package:remindme/addtodo.dart';
import 'package:remindme/alltodos.dart';

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => Home(),
  "/addtodo": (BuildContext context) => AddToDo(),
  "/alltodo": (BuildContext context) => All(),
};
