import 'package:flutter/material.dart';
import 'package:todo_firebase/pages/auth_services.dart';
import 'package:todo_firebase/pages/homepage2.dart';
import 'package:todo_firebase/pages/signUp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Center(child: Text("Login Page",style: TextStyle(color: Colors.white, fontSize: 25))),
      //   backgroundColor: const Color.fromARGB(255, 189, 172, 250),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("LOGIN", style: TextStyle(fontSize: 30)),
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
                login();
                emailController.clear();
                passwordController.clear();
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have account? "),
                InkWell(
                  onTap: () => goToSignUp(context),
                  child:
                      const Text("SignUp", style: TextStyle(color: Colors.red)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  goToSignUp(BuildContext context) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      );

  Future<void> login() async {
    final user = await _auth.loginUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);

    if (user != null) {
      print("User Logged In");
      Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const HomePage2()));
    }
  }
}
