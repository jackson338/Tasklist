import 'package:flutter/material.dart';

class TaskMod {
  String task;
  String iconName;
  String finish;
  String id;
  TaskMod({
    @required this.task,
    @required this.iconName,
    @required this.id,
    @required this.finish,
  });
}