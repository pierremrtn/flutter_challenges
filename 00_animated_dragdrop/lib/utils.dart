import 'package:flutter/widgets.dart';

RenderBox findBox(GlobalKey key) {
  return key.currentContext!.findRenderObject() as RenderBox;
}

RenderBox? findBoxOrNull(GlobalKey key) {
  return key.currentContext?.findRenderObject() as RenderBox?;
}

Offset findOffset(GlobalKey key) {
  final box = key.currentContext!.findRenderObject() as RenderBox;
  return box.localToGlobal(Offset.zero);
}
