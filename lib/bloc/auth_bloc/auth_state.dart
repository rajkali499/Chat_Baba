import 'package:chat_baba/model/response/app_user_response.dart';

class AuthStateResponse {
  final AuthState state;
  AppUserResponse? user;
  final String error;
  LoadStatus loadStatus = LoadStatus.loadingSuccess;

  AuthStateResponse(
      {this.state = AuthState.unAuth, this.error = "", this.user,this.loadStatus = LoadStatus.loadingSuccess});

  AuthStateResponse copyWith({AuthState? state, AppUserResponse? user, String? error,bool? isRankVisible,
    bool? isChallengesVisible,bool? isEditName,LoadStatus? loadStatus }) {
    return AuthStateResponse(
        state: state ?? this.state,
        user: user ?? this.user,
        error: error ?? this.error,
        loadStatus: loadStatus ?? this.loadStatus
    );
  }
}

enum AuthState { unAuth, authenticating, authenticated, failed }

enum LoadStatus {loading , loadingFail, loadingSuccess}