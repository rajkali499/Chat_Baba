import 'dart:collection';

import 'package:chat_baba/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_baba/bloc/chat_bloc/chat_event.dart';
import 'package:chat_baba/bloc/chat_bloc/chat_state.dart';
import 'package:chat_baba/bloc/user_bloc/user_event.dart';
import 'package:chat_baba/helper/constants.dart';
import 'package:chat_baba/helper/dependency.dart';
import 'package:chat_baba/helper/dialog_helper.dart';
import 'package:chat_baba/helper/enums_helper.dart';
import 'package:chat_baba/helper/nav_helper.dart';
import 'package:chat_baba/helper/utils.dart';
import 'package:chat_baba/model/response/get_chats_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with SingleTickerProviderStateMixin {
  double _animationPosition = 0.85;
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();
  ChatState _chatState = ChatState();

  @override
  void initState() {
    super.initState();
    getChatBloc()?.add(GetChatsEvent());
    _draggableController.addListener(() {
      setState(() {
        _animationPosition =
            _draggableController.pixelsToSize(_draggableController.pixels);
        // debugPrint(_animationPosition.toString());
      });
    });
  }

  @override
  void dispose() {
    _draggableController.dispose();
    super.dispose();
  }

  Widget _buildAvatar(String name) {
    double radius = (1 - _animationPosition);
    bool isSmall = (1 - _animationPosition) < 0.3;
    // debugPrint("name $name");
    // debugPrint("radius $radius");
    // debugPrint("isSmall $isSmall");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          isSmall
              ? Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.amber),
                      color: name == "Add Story" ? Colors.black : null,
                      borderRadius: BorderRadius.circular(
                          radius * (MediaQuery.sizeOf(context).width / 4))),
                  height: radius * (MediaQuery.sizeOf(context).width / 2),
                  width: radius * (MediaQuery.sizeOf(context).width / 2),
                  padding: const EdgeInsets.all(3),
                  child: name != "Add Story"
                      ? ClipOval(
                          child: Image.network(
                            "https://static.vecteezy.com/system/resources/previews/002/002/403/large_2x/man-with-beard-avatar-character-isolated-icon-free-vector.jpg",
                            fit: BoxFit.cover,
                          ),
                        )
                      : SvgPicture.asset(
                          (assetsMap['add_icon'] ?? ""),
                          fit: BoxFit.cover,
                        ),
                )
              : Container(
                  width: radius * (MediaQuery.sizeOf(context).width),
                  height: (MediaQuery.sizeOf(context).height * 0.7) * radius,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: name == "Add Story"
                        ? Colors.black
                        : Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: name != "Add Story"
                        ? Image.network(
                            "https://static.vecteezy.com/system/resources/previews/002/002/403/large_2x/man-with-beard-avatar-character-isolated-icon-free-vector.jpg",
                            fit: BoxFit.cover,
                          )
                        : SvgPicture.asset(
                            (assetsMap['add_icon'] ?? ""),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
          const SizedBox(height: 10.0),
          Text(name, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<ChatBloc, ChatState>(
            listener: (context, state) {
              _chatState = state;
              if (state.deleteChatProcessState ==
                  ProcessState.failed) {
                showMessage(state.errorMsg ?? "", MessageType.Fail);
                state.errorMsg = "";
              } else if (state.deleteChatProcessState ==
                  ProcessState.done) {
                showMessage("Deletion Success", MessageType.Sucess);
              }
            },
          ),
        ],
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height *
                        0.9, // Adjust the height as needed
                    width: double.infinity,
                    color: Colors.black,
                    child: Transform.scale(
                      scale: 3,
                      child: SvgPicture.asset(
                        assetsMap['bg_image'] ?? "", // Your SVG asset
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10.0,
                    left: 5,
                    child: RichText(
                      text: TextSpan(
                          text: "Welcome back, ",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: Colors.white),
                          children: [
                            TextSpan(
                              text: "Kali 👋",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            )
                          ]),
                    ),
                  ),
                  Positioned(
                    top: 60.0,
                    left: 3,
                    right: 3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var name in [
                            'Add Story',
                            'Pranav',
                            'Ayesha',
                            'Roshni',
                            'Kaushik',
                            'Dad',
                            'Ayesha',
                            'Roshni',
                            'Kaushik',
                            'Dad'
                          ])
                            _buildAvatar(name),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              DraggableScrollableSheet(
                initialChildSize: (MediaQuery.sizeOf(context).height * 0.8) /
                    MediaQuery.sizeOf(context).height,
                minChildSize: (MediaQuery.sizeOf(context).height * 0.1) /
                    MediaQuery.sizeOf(context).height,
                maxChildSize: (MediaQuery.sizeOf(context).height * 0.8) /
                    MediaQuery.sizeOf(context).height,
                controller: _draggableController,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Material(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: BlocBuilder<ChatBloc, ChatState>(
                      buildWhen: (previous, current) {
                        return (previous.chatProcessState !=
                            current.chatProcessState);
                      },
                      builder: (context, state) {
                        if (_chatState.chatProcessState ==
                            ProcessState.loading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return buildListView(
                            scrollController, _chatState.chatsResponse);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }

  Widget buildListView(ScrollController scrollController,
      List<GetChatsResponse>? chatsResponse) {
    if ((chatsResponse ?? []).isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            textMap["empty_chat_list"] ?? "",
            maxLines: 3,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }
    return ListView.builder(
      controller: scrollController,
      itemCount: chatsResponse?.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                getUserBloc()?.add(GetUsersByIdsEvent(participantIds: chatsResponse?[index].participantIds ?? []));
                getChatBloc()?.add(GetMessagesEvent(chatId: chatsResponse?[index].id ?? ""));
                openScreen(chat,args: LinkedHashMap.from({"chat" : chatsResponse?[index]}));
              },
              child: Dismissible(
                background: Container(
                  decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius:
                      BorderRadius.all(Radius.circular(15))),
                  child: const Icon(Icons.info_outline_rounded),
                ),
                secondaryBackground: Container(
                  decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius:
                      BorderRadius.all(Radius.circular(15))),
                  child: const Icon(Icons.delete),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    var res = await confirmationDialog(context);
                    return res?["confirmation"] ?? false;
                  }
                  return false;
                },
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    getChatBloc()?.add(DeleteChatEvent(chatId: chatsResponse?[index].id??""));
                  }
                },
                key: UniqueKey(),
                child: ListTile(
                  leading: buildCircleAvatarFromUrl(
                      imageUrl: chatsResponse?[index].imageUrl ?? "",
                      size: MediaQuery.sizeOf(context),
                      outerLayerColor: Colors.orangeAccent,
                      isGroup: chatsResponse?[index].isGroupChat ?? false),
                  title: Text(chatsResponse?[index].name ?? ""),
                  subtitle:
                      Text(chatsResponse?[index].lastMessage?.content ?? ""),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(getLocalFormat(chatsResponse?[index].updatedAt ?? "")),
                      const Icon(Icons.check, color: Colors.grey, size: 16.0),
                    ],
                  ),
                ),
              ),
            ),
            if (index < (chatsResponse?.length ?? 0))
              const Divider(
                height: 2,
                thickness: 0.3,
              )
          ],
        );
      },
    );
  }
}
