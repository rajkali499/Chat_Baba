import 'package:chat_baba/model/request/change_user_password_request.dart';

sealed class UserEvent {}

class GetUsersEvent extends UserEvent {
  GetUsersEvent();
}

class DeleteUserEvent extends UserEvent {
  DeleteUserEvent();
}

class GetUsersByIdsEvent extends UserEvent {
  List<String> participantIds;

  GetUsersByIdsEvent({required this.participantIds});
}

class GetCurrentUserEvent extends UserEvent {
  GetCurrentUserEvent();
}

class ChangeUserPasswordEvent extends UserEvent {
  ChangeUserPasswordRequest changeUserPasswordRequest;

  ChangeUserPasswordEvent({required this.changeUserPasswordRequest});
}
