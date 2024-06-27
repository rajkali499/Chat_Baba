import 'package:chat_baba/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat_baba/bloc/auth_bloc/auth_event.dart';
import 'package:chat_baba/bloc/auth_bloc/auth_state.dart';
import 'package:chat_baba/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_baba/bloc/user_bloc/user_bloc.dart';
import 'package:chat_baba/env/dev_env.dart';
import 'package:chat_baba/env/env.dart';
import 'package:chat_baba/helper/api_helper.dart';
import 'package:chat_baba/helper/api_service_helper.dart';
import 'package:chat_baba/helper/app_repository.dart';
import 'package:chat_baba/helper/dependency.dart';
import 'package:chat_baba/helper/nav_helper.dart';
import 'package:chat_baba/helper/nav_observer.dart';
import 'package:chat_baba/helper/storage_helper.dart';
import 'package:chat_baba/values/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

Env environment = DevEnv();
AppRepository repo =
    AppRepository(ApiServiceHelper(), ApiHelper(), StorageHelper());
AuthBloc authBloc = AuthBloc(AuthStateResponse());
ChatBloc chatBloc = ChatBloc();
UserBloc userBloc = UserBloc();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => repo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => authBloc),
          BlocProvider<ChatBloc>(create: (context) => chatBloc),
          BlocProvider<UserBloc>(create: (context) => userBloc),
        ],
        child: MaterialApp(
          navigatorObservers: [NavObserver.instance],
          navigatorKey: NavObserver.navKey,
          title: "Chat Baba",
          debugShowCheckedModeBanner: false,
          theme: light(),
          darkTheme: dark(),
          initialRoute: route,
          onGenerateRoute: generateRoute,
          builder: (context, child) {
            // getAuthBloc()?.add(
            //     LoginEvent(email: "hariprasath@gmail.com", password: "Hari@123"));
            return Scaffold(
              body: child,
            );
          },
        ),
      ),
    );
  }
}
