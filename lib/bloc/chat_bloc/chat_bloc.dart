import 'dart:async';
import 'dart:convert';

import 'package:chat_baba/bloc/chat_bloc/chat_event.dart';
import 'package:chat_baba/bloc/chat_bloc/chat_state.dart';
import 'package:chat_baba/helper/api_helper.dart';
import 'package:chat_baba/helper/dependency.dart';
import 'package:chat_baba/helper/enums_helper.dart';
import 'package:chat_baba/model/response/get_messages_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_client/web_socket_client.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState()) {
    on<GetChatsEvent>(_getChats);

    on<CreateChatEvent>(_createChat);

    on<DeleteChatEvent>(_onDeleteChat);

    on<GetMessagesEvent>(_onGetMessagesEvent);

    on<SendMessageEvent>(_onSendMessageEvent);

    on<RefreshChatEvent>(_refreshChatEvent);
  }

  String currentUserId = "";
  var _socket;

  _getChats(GetChatsEvent event, Emitter emit) async {
    emit(state.copyWith(chatProcessState: ProcessState.loading));
    var getAllChats = await getRepo().getChats();
    emit(state.copyWith(
        chatProcessState: ProcessState.done, chatsResponse: getAllChats));
    emit(state.copyWith(
      chatProcessState: ProcessState.none,
    ));
  }

  Future<FutureOr<void>> _createChat(
      CreateChatEvent event, Emitter<ChatState> emit) async {
    try {
      emit(state.copyWith(createChatProcessState: ProcessState.loading));
      var res = await getRepo()
          .createChat(createChatRequest: event.createChatRequest);
      if ((res.id ?? "").isEmpty) {
        emit(state.copyWith(
            createChatProcessState: ProcessState.failed,
            errorMsg: "Something went wrong"));
      } else {
        emit(state.copyWith(createChatProcessState: ProcessState.done));
        emit(state.copyWith(createChatProcessState: ProcessState.none));
      }
    } catch (e) {
      emit(state.copyWith(
          createChatProcessState: ProcessState.failed,
          errorMsg: "Something went wrong"));
    }
  }

  Future<FutureOr<void>> _onDeleteChat(
      DeleteChatEvent event, Emitter<ChatState> emit) async {
    try {
      emit(state.copyWith(deleteChatProcessState: ProcessState.loading));
      var res = await getRepo().deleteChat(event.chatId);
      emit(state.copyWith(deleteChatProcessState: ProcessState.done));
      emit(state.copyWith(deleteChatProcessState: ProcessState.none));
    } catch (e) {
      emit(state.copyWith(
          deleteChatProcessState: ProcessState.failed,
          errorMsg: "Deletion failed"));
    }
  }

  Future<FutureOr<void>> _onGetMessagesEvent(
      GetMessagesEvent event, Emitter<ChatState> emit) async {
    try {
      emit(state.copyWith(getMessagesOnChatProcessState: ProcessState.loading));
      var messageList = await getRepo().getAllMessagesOnChat(
        chatId: event.chatId,
      );
      emit(state.copyWith(
          getMessagesOnChatProcessState: ProcessState.done,
          messagesOnChats: messageList));
      emit(state.copyWith(
        getMessagesOnChatProcessState: ProcessState.none,
      ));
    } catch (e) {
      emit(state.copyWith(
        getMessagesOnChatProcessState: ProcessState.failed,
      ));
    }
  }

  Future<FutureOr<void>> _onSendMessageEvent(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    try {
      emit(state.copyWith(sendMessageState: ProcessState.loading));
      var res = await getRepo().sendMessage(event.sendMessageRequest);
      emit(state.copyWith(sendMessageState: ProcessState.done));

      await Future.delayed(const Duration(microseconds: 100), () {
        emit(state.copyWith(sendMessageState: ProcessState.none));
      });
    } catch (e) {
      emit(state.copyWith(
          sendMessageState: ProcessState.failed,
          errorMsg: "Something went wrong"));
      debugPrint(e.toString());
    }
  }

  initSocket({required String chatId}) async {
    var backoff = const ConstantBackoff(Duration(seconds: 1));
    final uri = Uri.parse('ws:${socketUrl}ws/$chatId?? ' '}');
    _socket =
        WebSocket(uri, backoff: backoff, timeout: const Duration(seconds: 5));
    // currentUserId = (await getRepo().getCurrentUser())?.id ?? "";
    _socket.connection
        .listen((state) => debugPrint('state: "${state.toString()}"'));
    // Listen for incoming messages.
    _socket.messages.listen((message) {
      if (message != "User left the chat") {
        debugPrint("on Receive ${jsonDecode(message)}");
      }

      final jsonMessage = jsonDecode(message);
      if (jsonMessage is Map) {
        final newMessage = GetMessagesResponse.fromJson(jsonMessage);

        // Find the index of the message with the same ID, if it exists
        int? existingIndex = state.messagesOnChats
            ?.indexWhere((msg) => msg.id == newMessage.id && msg.content == msg.content);
        if ((existingIndex ?? -1) != -1) {
          // Update the existing message
          state.messagesOnChats?[existingIndex ?? -1] = newMessage;
        } else {
          // Add the new message
          state.messagesOnChats?.insert(0,newMessage);
        }
        getChatBloc()?.add(RefreshChatEvent());
      }
    });
  }

  disposeChat() {
    _socket.close();
  }

  Future<FutureOr<void>> _refreshChatEvent(
      RefreshChatEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(
        sendMessageState: ProcessState.done,
        messagesOnChats: state.messagesOnChats));
    await Future.delayed(const Duration(microseconds: 100), () {
      emit(state.copyWith(sendMessageState: ProcessState.none));
    });
  }
}
