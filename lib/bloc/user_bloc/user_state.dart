import 'package:chat_baba/helper/enums_helper.dart';
import 'package:chat_baba/model/response/app_user_response.dart';

class UserState {
  AppUserResponse? currentUser;
  List<AppUserResponse>? userList;
  List<AppUserResponse>? participantsInCurrentChat;
  ProcessState? userProcessState;
  ProcessState? deleteUserProcessState;
  ProcessState? getUsersByIdsProcessState;
  String? errorMsg;

  UserState(
      {this.userProcessState = ProcessState.none,
      this.userList,
      this.currentUser,
      this.deleteUserProcessState = ProcessState.none,
      this.getUsersByIdsProcessState = ProcessState.none,
      this.participantsInCurrentChat,
      this.errorMsg});

  UserState copyWith(
      {List<AppUserResponse>? userList,
      AppUserResponse? currentUser,
      List<AppUserResponse>? participantsInCurrentChat,
      ProcessState? userProcessState,
      ProcessState? deleteUserProcessState,
      ProcessState? getUsersByIdsProcessState,
      String? errorMsg}) {
    return UserState(
        userList: userList ?? this.userList,
        userProcessState: userProcessState ?? this.userProcessState,
        participantsInCurrentChat:
            participantsInCurrentChat ?? this.participantsInCurrentChat,
        deleteUserProcessState:
            deleteUserProcessState ?? this.deleteUserProcessState,
        getUsersByIdsProcessState:
            getUsersByIdsProcessState ?? this.getUsersByIdsProcessState,
        currentUser: currentUser ?? this.currentUser,
        errorMsg: errorMsg ?? this.errorMsg);
  }
}
