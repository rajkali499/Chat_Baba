import 'package:chat_baba/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat_baba/bloc/auth_bloc/auth_event.dart';
import 'package:chat_baba/bloc/auth_bloc/auth_state.dart';
import 'package:chat_baba/helper/constants.dart';
import 'package:chat_baba/helper/dependency.dart';
import 'package:chat_baba/helper/nav_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthStateResponse>(
      listener: (context, state) {
        if(state.state == AuthState.unAuth){
          openScreen(signIn, requiresAsInitial: true);
        }
      },
      child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Profile"),
          const SizedBox(height: 20,),
          ElevatedButton(onPressed: () {
            getAuthBloc()?.add(LogoutEvent());
          }, child: Text(textMap["logout"] ?? ""),)
        ],
      )),
    );
  }
}
