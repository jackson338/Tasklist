import 'package:flutter/material.dart';

class NoteMod {
  String question;
  String start;
  String end;
  String note;
  String id;
  double scaleVal;
  int num;
  bool slide_num;
  TextEditingController noteController;
  NoteMod({
    @required this.question,
    @required this.start,
    @required this.end,
    @required this.note,
    @required this.id,
    @required this.scaleVal,
    @required this.noteController,
    @required this.num,
    @required this.slide_num,
  });
}
