import 'package:chat_baba/model/request/create_chat_request.dart';
import 'package:chat_baba/model/request/create_user_request.dart';
import 'package:chat_baba/model/request/send_message_request.dart';
import 'package:flutter/material.dart';

sealed class ChatEvent {}

class GetChatsEvent extends ChatEvent {
  GetChatsEvent();
}

class CreateChatEvent extends ChatEvent {
  CreateChatRequest createChatRequest;

  CreateChatEvent({required this.createChatRequest});
}

class DeleteChatEvent extends ChatEvent {
  String chatId;

  DeleteChatEvent({required this.chatId});
}

class GetMessagesEvent extends ChatEvent {
  String chatId;

  GetMessagesEvent({required this.chatId});
}

class SendMessageEvent extends ChatEvent {
  SendMessageRequest sendMessageRequest;

  SendMessageEvent({required this.sendMessageRequest});
}

class RefreshChatEvent extends ChatEvent {
  RefreshChatEvent();
}
