import 'package:chat_baba/helper/constants.dart';
import 'package:chat_baba/helper/nav_helper.dart';
import 'package:chat_baba/values/color_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              color: CBColors.yellow,
              child: Transform.scale(
                scale: 2,
                child: SvgPicture.asset(
                  assetsMap['bg_image'] ?? "",
                  fit: BoxFit.cover,
                  colorFilter:
                      const ColorFilter.mode(CBColors.grey, BlendMode.srcIn),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.sizeOf(context).height * 0.54,
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                padding: const EdgeInsets.all(15),
                child: SvgPicture.asset(
                  assetsMap['onboarding_img'] ?? "",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.4,
              left: 0.1,
              right: 0.1,
              child: Container(
                height: MediaQuery.sizeOf(context).height,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        textMap["onboarding_text"] ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            assetsMap['shield_icon'] ?? "",
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            textMap["secure_messages"] ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: (){
                          openScreen(signIn);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text(textMap["get_started"] ?? "",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
