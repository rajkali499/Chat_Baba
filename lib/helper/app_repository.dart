import 'dart:async';

import 'package:chat_baba/helper/api_helper.dart';
import 'package:chat_baba/helper/api_service_helper.dart';
import 'package:chat_baba/model/request/create_chat_request.dart';
import 'package:chat_baba/model/request/send_message_request.dart';
import 'package:chat_baba/model/response/get_chats_response.dart';
import 'package:chat_baba/model/request/create_user_request.dart';
import 'package:chat_baba/model/response/create_user_response.dart';
import 'package:chat_baba/model/response/get_messages_response.dart';
import 'dependency.dart';
import 'package:chat_baba/helper/storage_helper.dart';
import 'package:chat_baba/model/response/app_user_response.dart';

class AppRepository {
  ApiServiceHelper helper;
  ApiHelper apiHelper;
  StorageHelper storage;

  AppRepository(this.helper, this.apiHelper, this.storage);

  Future<AppUserResponse?> login(String email, String password) async {
    try {
      return await helper.login(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateUserResponse?> register(
      CreateUserRequest createUserRequest) async {
    return await helper.signupUser(createUserRequest);
  }

  Future<AppUserResponse?> getCurrentUser() async {
    try {
      return getAuthBloc()?.state.user ?? await helper.currentUser();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GetChatsResponse>> getChats() async {
    return await helper.getChats();
  }

  Future<List<AppUserResponse>> getMyUsers() async {
    return await helper.getMyUser();
  }

  Future<List<AppUserResponse>> getAllUsers() async {
    try {
      return await helper.getAllUser();
    } catch (e) {
      rethrow;
    }
  }

  Future<GetChatsResponse> createChat(
      {required CreateChatRequest createChatRequest}) async {
    try {
      return await helper.createChat(createChatRequest: createChatRequest);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteChat(String chatId) async {
    try {
      return await helper.deleteChat(chatId);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteUser() async {
    try {
      return await helper.deleteUser();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AppUserResponse>> getUsersByIds(
      {required List<String> participantIds}) async {
    try {
      return await helper.getUsersByIds(participantIds: participantIds);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GetMessagesResponse>> getAllMessagesOnChat(
      {required String chatId}) async {
    try {
      return await helper.getAllMessagesOnChat(chatId: chatId);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetMessagesResponse> sendMessage(SendMessageRequest sendMessageRequest) async {
    try{
      return await helper.sendMessage(sendMessageRequest);
    }catch(e){
      rethrow;
    }
  }
}
