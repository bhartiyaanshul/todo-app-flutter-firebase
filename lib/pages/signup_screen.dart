import 'package:flutter/material.dart';
import 'package:todo_firebase/pages/auth_services.dart';
import 'package:todo_firebase/pages/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("SIGNUP", style: TextStyle(fontSize: 30)),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(hintText: "Enter you email"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration:
                    const InputDecoration(hintText: "Enter you password"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                signup();
                emailController.clear();
                passwordController.clear();
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have account? "),
                InkWell(
                  onTap: () => goToLogin(context),
                  child:
                      const Text("Login", style: TextStyle(color: Colors.red)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

  signup() async {
    final user = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text
      );
    if (user != null) {
      print("User Created Successfully");
      goToLogin(context);
    }
  }
}
