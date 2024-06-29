import 'package:expensr/screens/login.dart';
import 'package:expensr/screens/signup.dart';
import 'package:expensr/utils/button.dart';
import 'package:flutter/material.dart';

class OnboardScreen extends StatefulWidget {
  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFB),
      body: Column(
        children: [
          Image.asset(
            "assets/bg.png",
            height: 500,
          ),
          Column(
            children: [
              const Text(
                'Welcome to Expenser',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: 400,
                child: const Text(
                  'Track all your expenses with us and start saving. Use our specialized tools and our technology to enhance your savings.',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 9.0,
                    height: 9.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Container(
                    width: 9.0,
                    height: 9.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Container(
                    width: 9.0,
                    height: 9.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ReusableButton(
                    text: 'Log in',
                    color: const Color(0xFFE8EDF2),
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    },
                  ),
                  ReusableButton(
                    text: 'Sign up',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Signup(),
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
