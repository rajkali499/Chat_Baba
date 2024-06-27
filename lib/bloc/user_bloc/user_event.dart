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

class GetCurrentUser extends UserEvent {
  GetCurrentUser();
}
