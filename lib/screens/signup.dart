import 'package:expensr/services/auth.dart';
import 'package:expensr/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:expensr/screens/login.dart';
import 'package:expensr/utils/button2.dart';
import 'package:expensr/utils/textfield.dart';

class Signup extends StatefulWidget {
  static const String routeName = '/signup';

  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  bool _isLoading = false;

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String username = usernameController.text.trim();

    try {
      String res = await AuthService().signUpUser(
        email: email,
        password: password,
        username: username,
        context: context,
      );

      if (res == 'success') {
        showSnackBar(
            'Signup successful! Please login with same credentials', context);
        Navigator.of(context).pop();
      } else {
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar('Error: $e', context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'Sign up to Expenser',
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ReusableTextField(
                labelText: 'Username',
                controller: usernameController,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ReusableTextField(
                labelText: 'Email',
                controller: emailController,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ReusableTextField(
                labelText: 'Password',
                controller: passwordController,
                obscureText: true,
              ),
            ),
            const SizedBox(height: 40),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ReusableButton2(
                    text: 'Sign Up',
                    onPressed: signUpUser,
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
            const SizedBox(height: 60),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                'By continuing, you agree to our Terms of Service \n                         and Privacy Policy.',
                style: TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(fontSize: 15),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
