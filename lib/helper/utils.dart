import 'package:chat_baba/helper/constants.dart';
import 'package:chat_baba/helper/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

getLocalFormat(String value) {
  if (value.isEmpty) {
    return value;
  }
  var df = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
  try {
    DateTime time = df.parse(value, true);
    DateTime now = DateTime.now();
    var duration = now.difference(time);
    if (duration.inHours > 24) {
      return DateFormat("MMM dd , hh:mm a").format(time);
    } else if (duration.inHours >= 1) {
      return "${duration.inHours} hour(s) ago";
    } else if (duration.inMinutes >= 1) {
      return "${duration.inMinutes} minute(s) ago";
    } else {
      return "Just Now";
    }
  } catch (e) {
    return value;
  }
}

({String date, String time}) getLocalDateAndTime(String value) {
  if (value.isEmpty) {
    return (date: '', time: '');
  }
  var df;
  if(value.contains("T")) {
     df = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
  }else{
    df = DateFormat("yyyy-MM-dd' 'HH:mm:ss.SSS");
  }
  try {
    DateTime time = df.parse(value, true);

    String formattedDate = DateFormat("MMM dd, yyyy").format(time);
    String formattedTime = DateFormat("hh:mm a").format(time);

    return (date: formattedDate, time: formattedTime);
  } catch (e) {
    return (date: '', time: '');
  }
}

Widget buildCircleAvatarFromUrl(
    {required String imageUrl,
    Size? size,
    Color? outerLayerColor,
    bool isSvg = false,
    bool isGroup = false,
    needBorder = true}) {
  return Container(
    decoration: BoxDecoration(
        border: needBorder
            ? Border.all(color: outerLayerColor ?? Colors.amber)
            : null,
        borderRadius: BorderRadius.circular(50)),
    height: 50,
    width: 50,
    padding: const EdgeInsets.all(3),
    child: ClipOval(
      child: (imageUrl).isNotEmpty && (imageUrl) != "string"
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              frameBuilder: (BuildContext context, Widget child, int? frame,
                  bool? wasSynchronouslyLoaded) {
                return child;
              },
              errorBuilder: (context, obj, trace) {
                return isSvg
                    ? SvgPicture.asset(
                        assetsMap['call_icon'] ?? "",
                        // Your SVG asset
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        assetsMap[isGroup ? "users_icon" : "user_icon"] ?? "",
                        fit: BoxFit.cover,
                      );
              },
            )
          : isSvg
              ? SvgPicture.asset(
                  assetsMap['call_icon'] ?? "",
                  // Your SVG asset
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  assetsMap[isGroup ? "users_icon" : "user_icon"] ?? "",
                  fit: BoxFit.cover,
                ),
    ),
  );
}

void showLoading(BuildContext context) {
  LoadingOverlay().show(context);
}

void hideLoading() {
  LoadingOverlay().hide();
}
