import 'package:flutter/material.dart';

class BottomNavigationBarModel {
  String? selectedIcon;
  String? unSelectedIcon;
  String? label;
  Widget? child;
  BottomNavigationBarModel(
      {this.label, this.child, this.selectedIcon, this.unSelectedIcon});
}