import 'package:chat_baba/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_baba/bloc/chat_bloc/chat_event.dart';
import 'package:chat_baba/bloc/chat_bloc/chat_state.dart';
import 'package:chat_baba/bloc/user_bloc/user_bloc.dart';
import 'package:chat_baba/bloc/user_bloc/user_event.dart';
import 'package:chat_baba/bloc/user_bloc/user_state.dart';
import 'package:chat_baba/helper/constants.dart';
import 'package:chat_baba/helper/dependency.dart';
import 'package:chat_baba/helper/dialog_helper.dart';
import 'package:chat_baba/helper/enums_helper.dart';
import 'package:chat_baba/helper/nav_helper.dart';
import 'package:chat_baba/helper/utils.dart';
import 'package:chat_baba/model/request/create_chat_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({
    super.key,
  });

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  UserState _userState = UserState();
  final Set<String> _participants = <String>{};

  @override
  void initState() {
    getUserBloc()?.add(GetUsersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<ChatBloc, ChatState>(
            listener: (context, state) {
              if ((state.errorMsg ?? "").isNotEmpty) {
                showMessage(state.errorMsg ?? '', MessageType.Fail);
                state.errorMsg = "";
              }
              if (state.createChatProcessState ==
                  ProcessState.loading) {
                showLoading(context);
              } else if (state.createChatProcessState ==
                  ProcessState.failed) {
                hideLoading();
              } else if (state.createChatProcessState ==
                  ProcessState.done) {
                hideLoading();
                openScreen(dashboard, requiresAsInitial: true);
              }
            },
          ),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state.deleteUserProcessState == ProcessState.done) {
                showMessage("User Deleted Successfully", MessageType.Sucess);
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text(textMap["contacts"] ?? ""),
          ),
          body: BlocConsumer<UserBloc, UserState>(
            listener: (BuildContext context, UserState state) {
              _userState = state;
            },
            buildWhen: (previous, current) =>
                previous.userProcessState != current.userProcessState,
            builder: (context, state) {
              if (_userState.userProcessState == ProcessState.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  itemCount: _userState.userList?.length ?? 0,
                  itemBuilder: (context, index) {
                    var user = _userState.userList?[index];
                    return Column(
                      children: [
                        Dismissible(
                          background: Container(
                            decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: const Icon(Icons.message),
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
                            return true;
                          },
                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              getUserBloc()?.add(DeleteUserEvent());
                            } else {
                              CreateChatRequest createChatRequest =
                                  CreateChatRequest(
                                      name: user?.name,
                                      isGroupChat: false,
                                      participantIds: [user?.id ?? ""],
                                      imageUrl: user?.imageUrl ?? "");
                              getChatBloc()?.add(CreateChatEvent(
                                  createChatRequest: createChatRequest));
                            }
                          },
                          key: UniqueKey(),
                          child: ListTile(
                            isThreeLine: true,
                            leading: buildCircleAvatarFromUrl(
                                imageUrl: user?.imageUrl ?? "",
                                size: MediaQuery.sizeOf(context),
                                outerLayerColor: Colors.blueAccent),
                            title: Row(
                              children: [
                                Text(user?.name ?? ""),
                                IconButton(
                                  icon: const Icon(Icons.message),
                                  onPressed: () {
                                    CreateChatRequest createChatRequest =
                                        CreateChatRequest(
                                            name: user?.name,
                                            isGroupChat: false,
                                            participantIds: [user?.id ?? ""],
                                            imageUrl: user?.imageUrl ?? "");
                                    getChatBloc()?.add(CreateChatEvent(
                                        createChatRequest: createChatRequest));
                                  },
                                ),
                              ],
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user?.email ?? ""),
                                Text(user?.mobile ?? ""),
                              ],
                            ),
                            trailing: IconButton(
                              icon: _participants.contains(user?.id ?? "")
                                  ? const Icon(Icons.check_box_outlined)
                                  : const Icon(
                                      Icons.check_box_outline_blank_rounded),
                              onPressed: () {
                                !_participants.contains(user?.id ?? "")
                                    ? _participants.add(user?.id ?? "")
                                    : _participants.remove(user?.id ?? "");
                                debugPrint(
                                    "participants ${_participants.length}");
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        if (index < (_userState.userList?.length ?? 0))
                          const Divider(
                            height: 2,
                            thickness: 0.3,
                          )
                      ],
                    );
                  });
            },
          ),
          floatingActionButton: Visibility(
            visible: _participants.isNotEmpty && _participants.length > 1,
            child: FloatingActionButton.extended(
                onPressed: () {
                  buildShowAdaptiveDialog(context);
                },
                label: Text(textMap["create_new_group"] ?? "")),
          ),
        ));
  }

  Future<dynamic> buildShowAdaptiveDialog(BuildContext context) {
    TextEditingController groupNameController = TextEditingController();
    return showAdaptiveDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                            ),
                            Positioned(
                                bottom: 10,
                                right: -2,
                                child: Icon(Icons.camera_alt))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(textMap["enter_group_name"] ?? ""),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: groupNameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                              disabledBorder: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  back(null);
                                },
                                child: Text(textMap["cancel"] ?? "")),
                            ElevatedButton(
                                onPressed: () {
                                  if (groupNameController.text.isNotEmpty) {
                                    back(null);
                                    CreateChatRequest createChatRequest =
                                        CreateChatRequest(
                                            name: groupNameController.text,
                                            isGroupChat:
                                                _participants.isNotEmpty,
                                            participantIds:
                                                _participants.toList(),
                                            imageUrl: "");
                                    getChatBloc()?.add(CreateChatEvent(
                                        createChatRequest: createChatRequest));
                                  }
                                },
                                child: Text(textMap["done"] ?? "")),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
