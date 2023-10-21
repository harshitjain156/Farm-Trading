import 'package:agro_millets/core/auth/application/auth.dart';
import 'package:agro_millets/core/auth/presentation/phone_otp.dart';
import 'package:agro_millets/core/auth/presentation/signup_page.dart';
import 'package:agro_millets/core/home/presentation/widgets/loading_widget.dart';
import 'package:agro_millets/globals.dart';
import 'package:agro_millets/main.dart';
import 'package:agro_millets/widgets/action_button.dart';
import 'package:agro_millets/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'forget_password.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late AuthManager _authManager;
  String email = "", password = "";

  @override
  void initState() {
    _authManager = AuthManager(context, ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      isLoading: _authManager.isLoading,
      child: _buildLoginPage(context),
    );
  }

  SingleChildScrollView _buildLoginPage(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          const SizedBox(height: kToolbarHeight),
          Image.asset(
            "assets/logo_app.png",
            height: 100,
            width: 100,
          ),
          SizedBox(height: 0.025 * getHeight(context)),
          const Center(
            child: Text(
              "Farm Trading",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Center(
            child: Text(
              "Cut the middle man between farmers and wholesalers",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(height: 0.025 * getHeight(context)),
          CustomTextField(
            onChanged: (v) => email = v,
            label: "Email",
            // value:"adhikariaarati68@gmail.com",
          ),
          const SizedBox(height: 10),
          CustomTextField(
            isPassword: true,
            onChanged: (v) => password = v,
            label: "Password",
            // value:"adhikariaarati68",
          ),
          SizedBox(height: 0.025 * getHeight(context)),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 200.0), // Add the desired padding value
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage()),
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          ActionButton(
            isFilled: false,
            onPressed: () async {
              var res = await _authManager.loginUsingEmailPassword(
                email: email.trim(),
                password: password.trim(),
              );
              if (res == 1 && mounted) {
                goToPage(context, const RolePage(), clearStack: true);
              }
            },
            text: "Log in",
          ),
          SizedBox(height: 0.015 * getHeight(context)),
          // GestureDetector(
          //   onTap: () async {
          //     var res = await _authManager.googleAuth();
          //     if (res == 1 && mounted) {
          //       goToPage(context, const RolePage(), clearStack: true);
          //     }
          //   },
          //   // text: "Login using Google",
          //   child: Container(
          //     height: 0.06 * getHeight(context),
          //     decoration: BoxDecoration(
          //       color: Theme.of(context).primaryColor,
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: const [
          //         Icon(
          //           MdiIcons.google,
          //           color: Colors.white,
          //         ),
          //         SizedBox(width: 10),
          //         Text(
          //           "Log in using Google",
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 16,
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),

          SizedBox(height: 0.015 * getHeight(context)),
          GestureDetector(
            onTap: () => goToPage(
                context,
                SignUpPage(
                  phone: '',
                )),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(text: "Don't have an account?"),
                  TextSpan(
                    text: " SignUp",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SizedBox(height: 0.015 * getHeight(context)),
          // ActionButton(
          //   isFilled: true,
          //   onPressed: () => goToPage(
          //     context,
          //     const SignUpPage(),
          //     clearStack: true,
          //   ),
          //   text: "Sign up",
          // ),
        ],
      ),
    );
  }
}
