import 'dart:collection';

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
import 'package:chat_baba/model/response/app_user_response.dart';
import 'package:chat_baba/model/response/get_chats_response.dart';
import 'package:chat_baba/model/response/get_messages_response.dart';
import 'package:chat_baba/values/color_codes.dart';
import 'package:flutter/material.dart';
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
  bool isFirstTime = true;
  final GlobalKey _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    getChatBloc()?.initSocket(chatId: chatsResponse.id ?? '');

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

                              return buildChatList(
                                  context,
                                  state.messagesOnChats ?? [],
                                  getUserBloc()?.state.currentUser?.id ?? "",
                                  chatsResponse.isGroupChat ?? false);
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
      String currentUserId, bool isGroupChat) {
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

    List<String> sortedKeys = groupedMessages.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      controller: _listController,
      key: _listKey,
      reverse: true,
      itemCount: groupedMessages.length,
      itemBuilder: (context, index) {
        String dateKey = sortedKeys[index];
        List<GetMessagesResponse> messagesOnDate = groupedMessages[dateKey]!;
        String dateOnMsg = DateFormat('EEEE, MMMM d, yyyy').format(
            DateTime.parse(
                messagesOnDate[0].createdAt ?? DateTime.now().toString()));
        String currentDate =
            DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
        String dateString = dateOnMsg == currentDate ? "Today" : dateOnMsg;

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
            ...messagesOnDate.reversed.map((message) {
              bool isCurrentUser = message.senderId == currentUserId;
              return isCurrentUser
                  ? buildMessageWidget(
                      context: context,
                      message: message,
                      isGroupChat: isGroupChat)
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: buildMessageWidget(
                          context: context,
                          message: message,
                          isGroupChat: isGroupChat,
                          isSender: false),
                    );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget buildMessageWidget({
    required BuildContext context,
    required GetMessagesResponse message,
    bool isSender = true,
    bool isGroupChat = false,
  }) {
    var dateTime =
        getLocalDateAndTime(message.createdAt ?? DateTime.now().toString());
    if (isGroupChat) {
      return buildGroupMessageWidget(
          context: context,
          message: message,
          isGroupChat: isGroupChat,
          isSender: isSender,
          dateTime: dateTime.time);
    }
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
                  color: isSender
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
            mainAxisAlignment:
                isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                (dateTime.time),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(
                width: 5,
              ),
              isSender
                  ? Icon(
                      message.id?.isNotEmpty ?? false
                          ? Icons.done_all
                          : Icons.done_rounded,
                      color: message.id?.isNotEmpty ?? false
                          ? Colors.blue
                          : Colors.grey,
                      size: 14)
                  : Container()
            ],
          )
        ],
      ),
    );
  }

  Widget buildGroupMessageWidget({
    required BuildContext context,
    required GetMessagesResponse message,
    required String dateTime,
    bool isSender = true,
    bool isGroupChat = false,
  }) {
    var res = getUserBloc()
            ?.state
            .participantsInCurrentChat
            ?.where((user) => user.id == message.senderId)
            .toList() ??
        [];
    print("object $res ${getUserBloc()?.state.participantsInCurrentChat}");
    var userOfCurrentMessage = res.isNotEmpty ? res.first : AppUserResponse();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isSender)
            Text(
              userOfCurrentMessage.name ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.7),
            child: Container(
              decoration: BoxDecoration(
                  color: isSender
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
            mainAxisAlignment:
                isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Visibility(
                visible: isGroupChat && !isSender,
                child: CircleAvatar(
                  radius: 10,
                  child: ClipOval(
                    child: Image.network(
                      "https://static.vecteezy.com/system/resources/previews/002/002/403/large_2x/man-with-beard-avatar-character-isolated-icon-free-vector.jpg",
                      fit: BoxFit.cover,
                    ),
                  )
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                dateTime,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(
                width: 5,
              ),
              isSender
                  ? Icon(
                      message.id?.isNotEmpty ?? false
                          ? Icons.done_all
                          : Icons.done_rounded,
                      color: message.id?.isNotEmpty ?? false
                          ? Colors.blue
                          : Colors.grey,
                      size: 14)
                  : Container()
            ],
          )
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
                shape: BoxShape.circle,
              ),
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
                ? Center(
                    child: IconButton(
                        highlightColor: CBColors.amber,
                        splashColor: CBColors.amber,
                        onPressed: () {
                          sendMessage(context);
                          refreshButton(
                              refresh: refresh, value: _chatController.text);
                        },
                        icon: const Icon(
                          size: 15,
                          Icons.send,
                          color: Colors.black,
                        )),
                  )
                : SvgPicture.asset(
                    height: 25, width: 25, assetsMap["microphone_icon"] ?? ""),
          ],
        );
      }),
    );
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

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listController.animateTo(
        _listController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void sendMessage(BuildContext context) {
    if (_chatController.text.isEmpty) return;

    getChatBloc()?.add(SendMessageEvent(
        sendMessageRequest: SendMessageRequest(
      chatId: chatsResponse.id ?? '',
      content: _chatController.text,
    )));

    _chatController.clear();
    typing = false;
    scrollToBottom();
  }
}
