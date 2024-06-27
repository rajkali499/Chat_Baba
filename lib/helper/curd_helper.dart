import 'dart:collection';

import 'package:chat_baba/helper/api_service_helper.dart';
import 'package:chat_baba/helper/storage_helper.dart';
import 'package:chat_baba/model/base_model.dart';



class CurdHelper<T extends BaseModel> {
  StorageHelper storage;
  ServiceHelper service;
  String name;

  CurdHelper({
    required this.service,
    required this.storage,
    required this.name,
  });
}