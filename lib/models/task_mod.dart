import 'package:flutter/material.dart';

class TaskMod {
  String task;
  String iconName;
  String finish;
  String id;
  int year;
  int month;
  int day;
  TaskMod({
    @required this.task,
    @required this.iconName,
    @required this.finish,
    @required this.id,
    this.year,
    this.month,
    this.day,
  });
}
