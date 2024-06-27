import 'package:chat_baba/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat_baba/bloc/auth_bloc/auth_event.dart';
import 'package:chat_baba/helper/constants.dart';
import 'package:chat_baba/helper/nav_helper.dart';
import 'package:chat_baba/model/request/create_user_request.dart';
import 'package:chat_baba/values/color_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.title});

  final String title;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndex,
          builder: (context, int value, _) {
            return navBarItems[value].child ?? Container();
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex.value = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorColor: Colors.transparent,
        selectedIndex: selectedIndex.value,
        destinations: List.generate(
          navBarItems.length,
          (index) => NavigationDestination(
              icon: SvgPicture.asset(navBarItems[index].selectedIcon ?? "",
                  colorFilter:
                      const ColorFilter.mode(CBColors.grey, BlendMode.srcIn),
                  semanticsLabel: navBarItems[index].label ?? ""),
              selectedIcon: SvgPicture.asset(
                  navBarItems[index].selectedIcon ?? "",
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  semanticsLabel: navBarItems[index].label ?? ""),
              label: navBarItems[index].label ?? ""),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        onPressed: () {
          openScreen(users);
          // context.read<AuthBloc>().add(CreateUserEvent(
          //     request: CreateUserRequest(
          //         name: "Kali",
          //         imageUrl: "",
          //         mobile: "9788022074",
          //         email: "kali@gmail.com",
          //         password: "kali1234")));
        },
        tooltip: 'Register',
        child: SvgPicture.asset(assetsMap["add_icon"]??""),
      ),
    );
  }
}
