import 'package:expensr/screens/bottom_bar.dart';
import 'package:expensr/screens/signup.dart';
import 'package:expensr/services/auth.dart';
import 'package:expensr/utils/button2.dart';
import 'package:expensr/utils/snackbar.dart';
import 'package:expensr/utils/textfield.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static const String routeName = '/login';
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool _isLoading = false;

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthService().loginUser(
      email: email.text,
      password: password.text,
      context: context,
    );

    setState(() {
      _isLoading = false;
    });

    if (res == 'success') {
      showSnackBar('Login successful!', context);
      Navigator.pushNamedAndRemoveUntil(
          context, BottomBar.routeName, (route) => false);
    } else {
      showSnackBar(res, context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              size: 25,
            ),
          ),
        ),
        toolbarHeight: 100,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Log in to Expenser',
              style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ReusableTextField(
              labelText: 'Email',
              controller: email,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ReusableTextField(
              labelText: 'Password',
              controller: password,
              obscureText: true,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          ReusableButton2(
            text: 'Continue with Facebook',
            onPressed: () {},
          ),
          const SizedBox(
            height: 15,
          ),
          ReusableButton2(
            text: 'Continue with Google',
            onPressed: () {},
          ),
          const SizedBox(
            height: 15,
          ),
          ReusableButton2(
            text: 'Continue with Apple',
            onPressed: () {},
          ),
          const SizedBox(
            height: 15,
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ReusableButton2(
                  text: 'Log In',
                  onPressed: loginUser,
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
          const SizedBox(
            height: 25,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'By continuing, you agree too our Terms of Service \n                         and Privacy Policy.',
              style: TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Don\'t have an account? ',
                style: TextStyle(fontSize: 15),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Signup(),
                    ),
                  );
                },
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
