import 'package:chat_baba/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat_baba/bloc/auth_bloc/auth_state.dart';
import 'package:chat_baba/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_baba/bloc/user_bloc/user_bloc.dart';
import 'package:chat_baba/helper/api_helper.dart';
import 'package:chat_baba/helper/api_service_helper.dart';
import 'package:chat_baba/helper/app_repository.dart';
import 'package:chat_baba/helper/nav_observer.dart';
import 'package:chat_baba/helper/storage_helper.dart';
import 'package:provider/provider.dart';

ServiceHelper getService(){
  ServiceHelper? helper;
  if(NavObserver.navKey.currentContext!=null){
    helper = NavObserver.navKey.currentContext!.read<AppRepository>().helper;
  }
  return helper ?? ServiceHelper();
}

StorageHelper getStorage() {
  StorageHelper? helper;
  if(NavObserver.navKey.currentContext!=null){
    helper = NavObserver.navKey.currentContext!.read<AppRepository>().storage;
  }
  return helper ?? StorageHelper();
}

AppRepository getRepo(){
  AppRepository? repository;
  if(NavObserver.navKey.currentContext!=null){
    repository = NavObserver.navKey.currentContext!.read<AppRepository>();
  }
  return repository ?? AppRepository(ApiServiceHelper(),ApiHelper(), StorageHelper());
}

AuthBloc? getAuthBloc() {
  AuthBloc? authBloc;
  if(NavObserver.navKey.currentContext!=null){
      authBloc = NavObserver.navKey.currentContext!.read<AuthBloc>();
  }
  return authBloc;
}

ChatBloc? getChatBloc() {
  ChatBloc? chatBloc;
  if(NavObserver.navKey.currentContext!=null){
    chatBloc = NavObserver.navKey.currentContext!.read<ChatBloc>();
  }
  return chatBloc;
}

UserBloc? getUserBloc() {
  UserBloc? userBloc;
  if(NavObserver.navKey.currentContext!=null){
    userBloc = NavObserver.navKey.currentContext!.read<UserBloc>();
  }
  return userBloc;
}



