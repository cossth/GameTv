import 'package:flutter/material.dart';
import 'package:game_tv/components/card.dart';
import 'package:game_tv/pages/login/login_page.dart';
import 'package:game_tv/provider/tournament_saervice_provider.dart';
import 'package:game_tv/provider/user_service_provider.dart';
import 'package:provider/provider.dart';

import '../utils.dart';

class HomePage extends StatelessWidget {
  static const route = '/home';
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<UserService>(builder: (context, userService, child) {
      void logoutCb() {
        Navigator.of(context).popAndPushNamed(Login.route);
      }

      final user = userService.user;

      return SafeArea(
        child: Column(children: [
          AppBar(
            actions: [
              TextButton(
                child: Text('Logout'),
                onPressed: () {
                  userService.logout(logoutCb);
                },
              )
            ],
            title: Text(user.title),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Text(
              'Recommended for you',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Consumer<TournamentService>(builder: (_, t) {
            return Flexible(
              child: ListView.builder(
                itemBuilder: (ctx, i) {
                  final tournament = t.getItem(i);
                  return RecommendedCard(
                    tournament: tournament,
                  );
                },
                itemCount: t.count,
              ),
            );
          }),
          SliverToBoxAdapter(child: HS(16))
        ]),
      );
    }));
  }
}
