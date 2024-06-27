import 'dart:collection';
import 'package:chat_baba/helper/dependency.dart';
import 'package:chat_baba/helper/storage_helper.dart';
import 'package:chat_baba/model/request/create_chat_request.dart';
import 'package:chat_baba/model/request/send_message_request.dart';
import 'package:chat_baba/model/response/get_chats_response.dart';
import 'package:chat_baba/model/request/create_user_request.dart';
import 'package:chat_baba/model/response/app_user_response.dart';
import 'package:chat_baba/model/response/create_user_response.dart';
import 'package:chat_baba/model/response/get_messages_response.dart';

import 'api_helper.dart';

class ApiServiceHelper extends ServiceHelper {
  static final ApiServiceHelper shared = ApiServiceHelper();

  Future<AppUserResponse?> login(String email, String password) async {
    try {
      var body = {"email": email, "password": password};
      var res = await getRepo().apiHelper.makeReq(
          "${baseUrlAuth}auth/token", body,
          method: Method.POST, isToken: false, showError: false);
      print(res);
      await StorageHelper().setAccessToken(res["access_token"]);
      await StorageHelper().setRefreshToken(res["refresh_token"]);
      await StorageHelper().setIsLoggedIn(true);
      return await currentUser();
    } catch (e) {
      rethrow;
    }
  }

  Future<AppUserResponse?> currentUser() async {
    try {
      var userRes = await getRepo().apiHelper.makeReq(
          "${baseUrlAuth}user", null,
          method: Method.GET, isToken: true);
      return AppUserResponse.fromJson(Map.from(userRes) as LinkedHashMap);
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateUserResponse?> signupUser(
      CreateUserRequest createUserRequest) async {
    var body = createUserRequest.toJson();
    var userRes = await getRepo().apiHelper.makeReq(
        "${baseUrlAuth}create_user/", body,
        method: Method.POST, isToken: false);
    await StorageHelper().setAccessToken(userRes["access_token"]);
    await StorageHelper().setRefreshToken(userRes["refresh_token"]);
    await StorageHelper().setIsLoggedIn(true);
    return CreateUserResponse.fromJson(Map.from(userRes) as LinkedHashMap);
  }

  Future<AppUserResponse?> updateCurrentUser(AppUserResponse body) async {
    var userRes = await getRepo().apiHelper.makeReq(
        "${baseUrlAuth}user/", body.toJson(),
        method: Method.PUT, isToken: true);
    return AppUserResponse.fromJson(Map.from(userRes) as LinkedHashMap);
  }

  Future<String?> changesUserPass(Map<String, String> body,
      [String path = '']) async {
    var userRes = await getRepo().apiHelper.makeReq(
        "${baseUrlAuth}password_change/$path", body,
        method: Method.POST, isToken: false);
    return userRes["message"];
  }

  Future<List<AppUserResponse>> getMyUser() async {
    var getAllUser = await getRepo().apiHelper.makeReq(
        "${baseUrlAuth}my_users/", null,
        method: Method.GET, isToken: true, showError: false);
    return (getAllUser as List?)
            ?.map((e) => AppUserResponse.fromJson(Map.from(e) as LinkedHashMap))
            .toList() ??
        [];
  }

  Future<List<AppUserResponse>> getAllUser() async {
    try {
      var getAllUser = await getRepo().apiHelper.makeReq(
          "${baseUrlAuth}users/", null,
          method: Method.GET, isToken: true);
      return (getAllUser as List?)
              ?.map(
                  (e) => AppUserResponse.fromJson(Map.from(e) as LinkedHashMap))
              .toList() ??
          [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AppUserResponse>> getUsersByIds(
      {required List<String> participantIds}) async {
    try {
      var getAllUser = await getRepo().apiHelper.makeReq(
          "${baseUrlAuth}users_from_list/", participantIds,
          method: Method.POST, isToken: true);
      return (getAllUser as List?)
              ?.map(
                  (e) => AppUserResponse.fromJson(Map.from(e) as LinkedHashMap))
              .toList() ??
          [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GetChatsResponse>> getChats() async {
    var getAllChats = await getRepo().apiHelper.makeReq(
        "${baseUrlChat}chats", null,
        method: Method.GET, isToken: true);
    return (getAllChats as List?)
            ?.map(
                (e) => GetChatsResponse.fromJson(Map.from(e) as LinkedHashMap))
            .toList() ??
        [];
  }

  Future<GetChatsResponse> createChat(
      {required CreateChatRequest createChatRequest}) async {
    try {
      var getChat = await getRepo().apiHelper.makeReq(
            "${baseUrlChat}create_chat",
            createChatRequest.toJson(),
            method: Method.POST,
            isToken: true,
          );
      return GetChatsResponse.fromJson(
          Map.from(getChat ?? {}) as LinkedHashMap);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteChat(String chatId) async {
    try {
      var deleteRes = await getRepo().apiHelper.makeReq(
          "${baseUrlChat}chats/$chatId", null,
          method: Method.DELETE, isToken: true);
      return deleteRes;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteUser() async {
    try {
      var deleteRes = await getRepo().apiHelper.makeReq(
          "${baseUrlAuth}user", null,
          method: Method.DELETE, isToken: true);
      return deleteRes;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GetMessagesResponse>> getAllMessagesOnChat(
      {required String chatId}) async {
    try {
      var messageRes = await getRepo().apiHelper.makeReq(
          "${baseUrlChat}chats/$chatId/messages", null,
          method: Method.GET, isToken: true);
      return (messageRes as List?)
              ?.map((e) =>
                  GetMessagesResponse.fromJson(Map.from(e) as LinkedHashMap))
              .toList() ??
          [];
    } catch (e) {
      rethrow;
    }
  }

  Future<GetMessagesResponse> sendMessage(
      SendMessageRequest sendMessageRequest) async {
    try {
      var messageRes = await getRepo().apiHelper.makeReq(
          "${baseUrlChat}create_message", sendMessageRequest.toJson(),
          method: Method.POST, isToken: true);
      return GetMessagesResponse.fromJson(
          Map.from(messageRes) as LinkedHashMap);
    } catch (e) {
      rethrow;
    }
  }
}

class ServiceHelper {}

//   @override
//   Future<AppUserResponse?> login(String email, String password) async{
//     var isToken = await StorageHelper().getAccessToken() ?? "";
//     if(isToken.isEmpty) {
//       await token(email,password);
//     }
//
//
//
// }
