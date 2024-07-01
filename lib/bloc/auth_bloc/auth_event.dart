import 'package:chat_baba/model/request/create_user_request.dart';

class AuthEvent {

}

class CreateUserEvent extends AuthEvent {
  CreateUserRequest? request;
  CreateUserEvent({this.request});
}

class LoginEvent extends AuthEvent {
  String email;
  String password;
  LoginEvent({required this.email,required this.password});
}

class LogoutEvent extends AuthEvent {
  LogoutEvent();
}