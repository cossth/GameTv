import 'package:flutter/material.dart';
import 'package:game_tv/abstraction/login_service.dart';
import 'package:game_tv/pages/home/home_page.dart';
import 'package:game_tv/provider/user_service_provider.dart';
import 'package:provider/provider.dart';

import '../utils.dart';

class Login extends StatefulWidget {
  static const route = '/login';

  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController =
          TextEditingController(text: credentials.keys.first),
      _passwordController =
          TextEditingController(text: credentials.values.first);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<UserService>(builder: (context, userService, child) {
      final width = MediaQuery.of(context).size.width;
      userValidator([String? value]) {
        final val = value ?? _usernameController.text;
        if (val.length > 12 || val.length < 3) {
          return 'Username should be 3 to 12 characters.';
        }
        return null;
      }

      passValidator([String? value]) {
        final val = value ?? _passwordController.text;
        if (val.length > 12 || val.length < 3) {
          return 'Password should be 3 to 12 characters.';
        }
        return null;
      }

      onLogin() {
        if (userValidator() == null && passValidator() == null) {
          return () async {
            await userService.login(
              _usernameController.text,
              _passwordController.text,
            );
            if (userService.isAuthenticated) {
              Navigator.of(context).popAndPushNamed(HomePage.route);
            }
          };
        }
        return null;
      }

      return SafeArea(
        child: Container(
          // color: Colors.grey,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(40),
                child: Image(
                  image: AssetImage('assets/images/game.tv-logo.png'),
                  width: 0.5 * width,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Username'),
                      validator: userValidator,
                      controller: _usernameController,
                      onChanged: (value) {
                        /// To Trigger Validation, Is there a better approach??
                        /// Can Have better UX
                        _formKey.currentState?.validate();
                        setState(() {});
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Password'),
                      validator: passValidator,
                      obscureText: true,
                      controller: _passwordController,
                      onChanged: (value) {
                        /// To Trigger Validation, Is there a better approach??
                        _formKey.currentState?.validate();
                        setState(() {});
                      },
                    ),
                    if (userService.error?.isNotEmpty ?? false)
                      Text(
                        'Error : ' + (userService.error ?? 'None'),
                        style: TextStyle(color: Colors.red),
                      ),
                    HS(5),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onLogin(),
                        child: Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }));
  }
}
