import 'package:chat_baba/helper/enums_helper.dart';
import 'package:chat_baba/model/response/get_chats_response.dart';
import 'package:chat_baba/model/response/get_messages_response.dart';

class ChatState {
  List<GetChatsResponse>? chatsResponse;
  List<GetMessagesResponse>? messagesOnChats;
  ProcessState? chatProcessState;
  ProcessState? createChatProcessState;
  ProcessState? deleteChatProcessState;
  ProcessState? getMessagesOnChatProcessState;
  ProcessState? sendMessageState;

  String? errorMsg;

  ChatState(
      {this.chatProcessState = ProcessState.none,
      this.chatsResponse,
      this.createChatProcessState = ProcessState.none,
      this.deleteChatProcessState = ProcessState.none,
      this.getMessagesOnChatProcessState = ProcessState.none,
      this.sendMessageState = ProcessState.none,
      this.messagesOnChats,
      this.errorMsg});

  ChatState copyWith(
      {List<GetChatsResponse>? chatsResponse,
      List<GetMessagesResponse>? messagesOnChats,
      ProcessState? chatProcessState,
      ProcessState? createChatProcessState,
      ProcessState? deleteChatProcessState,
      ProcessState? getMessagesOnChatProcessState,
      ProcessState? sendMessageState,
      String? errorMsg}) {
    return ChatState(
        chatProcessState: chatProcessState ?? this.chatProcessState,
        chatsResponse: chatsResponse ?? this.chatsResponse,
        createChatProcessState:
            createChatProcessState ?? this.createChatProcessState,
        deleteChatProcessState:
            deleteChatProcessState ?? this.deleteChatProcessState,
        getMessagesOnChatProcessState:
            getMessagesOnChatProcessState ?? this.getMessagesOnChatProcessState,
        messagesOnChats: messagesOnChats ?? this.messagesOnChats,
        sendMessageState: sendMessageState ?? this.sendMessageState,
        errorMsg: errorMsg ?? this.errorMsg);
  }
}
