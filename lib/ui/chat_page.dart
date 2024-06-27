import 'dart:collection';
import 'dart:ffi';

import 'package:chat_baba/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_baba/bloc/chat_bloc/chat_event.dart';
import 'package:chat_baba/bloc/chat_bloc/chat_state.dart';
import 'package:chat_baba/bloc/user_bloc/user_bloc.dart';
import 'package:chat_baba/bloc/user_bloc/user_state.dart';
import 'package:chat_baba/helper/constants.dart';
import 'package:chat_baba/helper/dependency.dart';
import 'package:chat_baba/helper/dialog_helper.dart';
import 'package:chat_baba/helper/enums_helper.dart';
import 'package:chat_baba/helper/utils.dart';
import 'package:chat_baba/model/request/send_message_request.dart';
import 'package:chat_baba/model/response/get_chats_response.dart';
import 'package:chat_baba/model/response/get_messages_response.dart';
import 'package:chat_baba/values/color_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatelessWidget {
  final LinkedHashMap<dynamic, dynamic> args;

  ChatPage({super.key, required this.args}) {
    if (args.containsKey("chat")) {
      chatsResponse = args["chat"];
    }
  }

  GetChatsResponse chatsResponse = GetChatsResponse();
  bool typing = false;
  final TextEditingController _chatController = TextEditingController();
  final _listController = ScrollController();

  @override
  Widget build(BuildContext context) {
    getChatBloc()?.initSocket(chatId: chatsResponse.id ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());

    return PopScope(
      onPopInvoked: (val) {
        getChatBloc()?.disposeChat();
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state.getMessagesOnChatProcessState == ProcessState.failed) {
                showMessage(state.errorMsg ?? "", MessageType.Fail);
                state.errorMsg = "";
              }
            },
          ),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {},
          ),
        ],
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  color: Colors.black,
                  child: Transform.scale(
                    scale: 3,
                    child: SvgPicture.asset(
                      assetsMap['bg_image'] ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10.0,
                  left: 1,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            buildCircleAvatarFromUrl(
                                imageUrl: chatsResponse.imageUrl ?? "",
                                needBorder: false,
                                isGroup: chatsResponse.isGroupChat ?? false),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chatsResponse.name ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(color: Colors.white),
                                    ),
                                    Visibility(
                                      visible:
                                          !(chatsResponse.isGroupChat ?? false),
                                      child: Text(
                                        textMap["online"] ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(color: Colors.green),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        const Icon(Icons.more_vert_outlined)
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 95,
                  left: 1,
                  right: 1,
                  bottom: 0.1,
                  child: Container(
                    height: MediaQuery.sizeOf(context).height,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Expanded(
                          child: BlocBuilder<ChatBloc, ChatState>(
                            buildWhen: (previous, current) =>
                                (previous.sendMessageState !=
                                    current.sendMessageState) ||
                                (previous.getMessagesOnChatProcessState !=
                                    current.getMessagesOnChatProcessState),
                            builder: (context, state) {
                              if (state.getMessagesOnChatProcessState ==
                                  ProcessState.loading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              WidgetsBinding.instance.addPostFrameCallback(
                                  (_) => scrollToBottom());
                              return buildChatList(
                                  context,
                                  state.messagesOnChats ?? [],
                                  getChatBloc()?.currentUserId ?? "");
                            },
                          ),
                        ),
                        buildBottomChatContainer()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildChatList(BuildContext context, List<GetMessagesResponse> messages,
      String currentUserId) {
    Map<String, List<GetMessagesResponse>> groupedMessages = {};

    // Group messages by date
    for (var message in messages) {
      String dateKey = DateFormat('yyyy-MM-dd').format(
          DateTime.parse(message.createdAt ?? DateTime.now().toString()));
      if (groupedMessages[dateKey] == null) {
        groupedMessages[dateKey] = [];
      }
      groupedMessages[dateKey]!.add(message);
    }

    List<String> sortedKeys = groupedMessages.keys.toList()..sort();

    return CustomScrollView(
      controller: _listController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              String dateKey = sortedKeys[index];
              List<GetMessagesResponse> messagesOnDate =
                  groupedMessages[dateKey]!;
              String dateOnMsg = DateFormat('EEEE, MMMM d, yyyy').format(
                  DateTime.parse(messagesOnDate[0].createdAt ??
                      DateTime.now().toString()));
              String currentDate =
                  DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
              String dateString =
                  dateOnMsg == currentDate ? "Today" : dateOnMsg;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      dateString,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold, color: CBColors.grey),
                    ),
                  ),
                  ...messagesOnDate.map((message) {
                    bool isCurrentUser = message.senderId == currentUserId;
                    return isCurrentUser
                        ? buildMessageWidget(context: context, message: message)
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: buildMessageWidget(
                                context: context,
                                message: message,
                                isSender: false),
                          );
                  }).toList(),
                ],
              );
            },
            childCount: groupedMessages.length,
          ),
        ),
      ],
    );
  }

  Widget buildMessageWidget({
    required BuildContext context,
    required GetMessagesResponse message,
    bool isSender = true,
  }) {
    var dateTime =
        getLocalDateAndTime(message.createdAt ?? DateTime.now().toString());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.7),
            child: Container(
              decoration: BoxDecoration(
                  color: (message.senderId ?? "") ==
                          (getChatBloc()?.currentUserId ?? "")
                      ? CBColors.chatBodyBg1.withOpacity(0.5)
                      : CBColors.chatBodyBg2.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              padding: const EdgeInsets.all(10),
              child: Text(
                (message.content ?? ""),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Visibility(
                visible: (message.chatId ?? "").isEmpty,
                child: const Icon(
                  Icons.access_time_filled,
                  color: Colors.black,
                  size: 10,
                ),
              ),
              Visibility(
                visible: (message.chatId ?? "").isNotEmpty,
                child: Row(
                  children: [
                    Text(
                      dateTime.time,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.black45, fontSize: 10),
                    ),
                    Visibility(
                      visible: isSender,
                      child: const Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.blueAccent,
                            size: 10,
                          ),
                          Positioned(
                            left: 2.5,
                            child: Icon(
                              Icons.check,
                              color: Colors.blueAccent,
                              size: 10,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildBottomChatContainer() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: CBColors.borderGrey),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: StatefulBuilder(builder: (context, refresh) {
        return Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: SvgPicture.asset(
                  height: 25, width: 25, assetsMap["add_icon"] ?? ""),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _chatController,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () {
                    sendMessage(context);
                    refreshButton(
                        refresh: refresh, value: _chatController.text);
                  },
                  onChanged: (val) {
                    refreshButton(refresh: refresh, value: val);
                  },
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: textMap["type_message"] ?? "",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.black),
                    border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    disabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
              child: VerticalDivider(thickness: 0.2),
            ),
            typing
                ? IconButton(
                    highlightColor: CBColors.amber,
                    splashColor: CBColors.amber,
                    onPressed: () {
                      sendMessage(context);
                      refreshButton(
                          refresh: refresh, value: _chatController.text);
                    },
                    icon: const Icon(
                      size: 20,
                      Icons.send,
                      color: Colors.black,
                    ))
                : SvgPicture.asset(
                    height: 25, width: 25, assetsMap["microphone_icon"] ?? ""),
          ],
        );
      }),
    );
  }

  void clearState() {
    _chatController.dispose();
  }

  void refreshButton(
      {required String value, required Function(void Function()) refresh}) {
    refresh(() {
      if (_chatController.text.isNotEmpty) {
        typing = true;
      } else {
        typing = false;
      }
    });
  }

  void sendMessage(BuildContext context) {
    if (_chatController.text.isNotEmpty) {
      (getChatBloc()?.state.messagesOnChats ?? []).add(GetMessagesResponse(
          content: _chatController.text,
          senderId: (getChatBloc()?.currentUserId),
          createdAt: DateTime.now().toString()));
      getChatBloc()?.add(SendMessageEvent(
          sendMessageRequest: SendMessageRequest(
              content: _chatController.text, chatId: chatsResponse.id)));
      _chatController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    }
  }

  void scrollToBottom() {
    if (_listController.hasClients) {
      _listController
          .jumpTo(_listController.positions.last.maxScrollExtent + 10);
    }
  }
}
