import 'package:chat_baba/model/bottom_navigation_bar_model.dart';
import 'package:chat_baba/ui/calls_page.dart';
import 'package:chat_baba/ui/messages_page.dart';
import 'package:chat_baba/ui/profile_page.dart';
import 'package:chat_baba/ui/search_page.dart';
import 'package:flutter/material.dart';

List<BottomNavigationBarModel> navBarItems = [
  BottomNavigationBarModel(
      label: "Messages",
      selectedIcon: assetsMap["message_icon"],
      unSelectedIcon: assetsMap["message_icon"],
      child: const MessagePage()),
  BottomNavigationBarModel(
      label: "Calls",
      selectedIcon: assetsMap["call_icon"],
      unSelectedIcon: assetsMap["call_icon"],
      child: const CallPage()),
  BottomNavigationBarModel(
      label: "Profile",
      selectedIcon: assetsMap["profile_icon"],
      unSelectedIcon: assetsMap["profile_icon"],
      child: const ProfilePage()),
  BottomNavigationBarModel(
      label: "Search",
      selectedIcon: assetsMap["search_icon"],
      unSelectedIcon: assetsMap["search_icon"],
      child: const SearchPage()),
];

Map<String, String>  assetsMap = {
  "message_icon": "assets/message.svg",
  "call_icon": "assets/calls.svg",
  "profile_icon": "assets/profile.svg",
  "search_icon": "assets/search.svg",
  "bg_image": "assets/bg_image.svg",
  "add_icon": "assets/add_icon.svg",
  "user_icon": "assets/user_icon.png",
  "users_icon": "assets/users_icon.png",
  "microphone_icon": "assets/microphone_icon.svg",
};

Map<String, String> textMap = {
  "empty_chat_list":
      "There are currently no chats. Start a conversation to get started...😊",
  "contacts": "Contacts",
  "create_new_group": "Create New Group",
  "enter_group_name": "Enter Group Name",
  "done": "Done",
  "cancel": "Cancel",
  "are_you_sure_want_to_delete": "Are you sure want to Delete?😮",
  "yes": "Yes",
  "no": "No",
  "online": "Online",
  "type_message": "Type Message",
};

ValueNotifier<int> selectedIndex = ValueNotifier(0);
