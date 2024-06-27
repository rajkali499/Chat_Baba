
import 'dart:collection';

import 'package:chat_baba/helper/constants.dart';
import 'package:chat_baba/helper/nav_helper.dart';
import 'package:chat_baba/helper/nav_observer.dart';
import 'package:flutter/material.dart';

enum MessageType { Sucess, Fail, Warning, Info }

Future showMessage(String message, MessageType type) async {
  bool isShowing = true;
  if (NavObserver.navKey.currentState == null) return;
  showDialog(
      context: NavObserver.navKey.currentState!.context,
      barrierColor: Colors.black38,
      //isDismissible: true,
      //backgroundColor: Colors.transparent,
      builder: (ctx) {
        var icon = Icons.check;
        var color = Colors.grey;
        switch (type) {
          case MessageType.Fail:
            icon = Icons.clear;
            color = Colors.red;
            break;
          case MessageType.Sucess:
            icon = Icons.check;
            color = Colors.green;
            break;
          case MessageType.Warning:
            icon = Icons.warning_amber;
            color = Colors.orange;
            break;
          case MessageType.Info:
            icon = Icons.info_outline;
            color = Colors.blue;
            break;
        }
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: MediaQuery.of(ctx).size.width < 500
                    ? MediaQuery.of(ctx).size.width - 40
                    : 500,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: color,
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 25,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: Text(
                          message,
                          style: const TextStyle(color: Colors.white, fontSize: 22),
                        ))
                  ],
                ),
              ),
            ),
          ),
        );
      }).then((_) {
    isShowing = false;
  });
  await Future.delayed(const Duration(milliseconds: 1500), () {
    if (isShowing && NavObserver.navKey.currentState != null) {
      Navigator.of(NavObserver.navKey.currentState!.context).pop();
    }
  });
}

Future<dynamic> confirmationDialog(BuildContext context, {String? msg}) async {
  return await showDialog<dynamic>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Material(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(msg?? textMap["are_you_sure_want_to_delete"] ?? ""),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          back(LinkedHashMap.from({"confirmation": false}));
                        },
                        child: Text(textMap["no"] ?? ""),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          back(LinkedHashMap.from({"confirmation": true}));
                        },
                        child: Text(textMap["yes"] ?? ""),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}