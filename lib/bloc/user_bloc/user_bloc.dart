import 'dart:async';

import 'package:chat_baba/bloc/user_bloc/user_event.dart';
import 'package:chat_baba/bloc/user_bloc/user_state.dart';
import 'package:chat_baba/helper/dependency.dart';
import 'package:chat_baba/helper/enums_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState()) {
    on<GetUsersEvent>(_getUsers);

    on<DeleteUserEvent>(_onDeleteUser);

    on<GetUsersByIdsEvent>(_onGetUsersByIds);

    on<GetCurrentUser>(_onGetCurrentUser);
  }

  Future<FutureOr<void>> _getUsers(
      GetUsersEvent event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(userProcessState: ProcessState.loading));
      var userList = await getRepo().getAllUsers();
      emit(state.copyWith(
          userProcessState: ProcessState.done, userList: userList));
      emit(state.copyWith(userProcessState: ProcessState.none));
    } catch (e) {
      emit(state.copyWith(
        userProcessState: ProcessState.failed,
      ));
    }
  }

  FutureOr<void> _onDeleteUser(event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(deleteUserProcessState: ProcessState.loading));
      var res = await getRepo().deleteUser();
      emit(state.copyWith(deleteUserProcessState: ProcessState.done));
      emit(state.copyWith(deleteUserProcessState: ProcessState.none));
    } catch (e) {
      emit(state.copyWith(userProcessState: ProcessState.failed));
    }
  }

  Future<FutureOr<void>> _onGetUsersByIds(
      GetUsersByIdsEvent event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(getUsersByIdsProcessState: ProcessState.loading));
      if ((state.userList ?? []).isEmpty) {
        var usersByIds =
            await getRepo().getUsersByIds(participantIds: event.participantIds);
        emit(state.copyWith(
            participantsInCurrentChat: usersByIds,
            getUsersByIdsProcessState: ProcessState.done));
        emit(state.copyWith(getUsersByIdsProcessState: ProcessState.none));
      } else {
        var usersByIds = state.userList
            ?.where((e) => event.participantIds.contains(e.id ?? ""))
            .toList();
        emit(state.copyWith(
            participantsInCurrentChat: usersByIds,
            getUsersByIdsProcessState: ProcessState.done));
        emit(state.copyWith(getUsersByIdsProcessState: ProcessState.none));
      }
    } catch (e) {
      emit(state.copyWith(getUsersByIdsProcessState: ProcessState.failed));
    }
  }

  Future<FutureOr<void>> _onGetCurrentUser(
      GetCurrentUser event, Emitter<UserState> emit) async {
    try {
      var user = await getRepo().getCurrentUser();
      emit(state.copyWith(currentUser: user));
    } catch (e) {}
  }
}
