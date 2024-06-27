import 'dart:async';
import 'package:chat_baba/bloc/auth_bloc/auth_event.dart';
import 'package:chat_baba/bloc/auth_bloc/auth_state.dart';
import 'package:chat_baba/bloc/user_bloc/user_event.dart';
import 'package:chat_baba/helper/dependency.dart';
import 'package:chat_baba/model/request/create_user_request.dart';
import 'package:chat_baba/model/response/app_user_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthStateResponse> {
  AuthBloc(AuthStateResponse authStateResponse) : super(AuthStateResponse()) {
    on<CreateUserEvent>(_onCreateUser);
    on<LoginEvent>(_onLoginEvent);
  }

  _onCreateUser(CreateUserEvent event, Emitter<AuthStateResponse> emit) async {
    emit(state);
    var result = await getRepo().register(event.request ?? CreateUserRequest());
    AppUserResponse? user;
    if ((result?.accessToken ?? "").isNotEmpty) {
      user = await getRepo().getCurrentUser();
      debugPrint(user?.toJson().toString());
    }
    emit(state.copyWith(
        state: AuthState.authenticated, user: user ?? AppUserResponse()));
  }

  Future<FutureOr<void>> _onLoginEvent(
      LoginEvent event, Emitter<AuthStateResponse> emit) async {
    try {
      emit(state.copyWith(
        state: AuthState.authenticating,
      ));
      var user = await getRepo().login(event.email, event.password);
      emit(state.copyWith(
        state: AuthState.authenticated,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        state: AuthState.failed,
        error: "Something Went Wrong",
      ));
    }
  }
}
