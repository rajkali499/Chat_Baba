import 'dart:collection';

abstract class BaseModel<T> {
  String id = "";
  String imageUrl = "";
  int updateOn = DateTime.now().millisecondsSinceEpoch;
  int createOn = DateTime.now().millisecondsSinceEpoch;
  T fromMap(LinkedHashMap<dynamic, dynamic> json);
  Map<String,dynamic> toJson();
}