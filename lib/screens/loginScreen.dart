import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:litewritten/screens/homeScreen.dart';
import 'package:litewritten/screens/registrationScreen.dart';
import 'package:quickalert/quickalert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();

  bool isShown = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      spacing: 14,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/logo.png', width: 180),
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000742),
                          ),
                        ),
                        Text(
                          "Login to your account",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000742),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                          controller: emailCtrl,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF000742)),
                            ),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                          obscureText: isShown,
                          controller: passCtrl,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                isShown = !isShown;
                                setState(() {});
                              },
                              icon:
                                  isShown
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Password",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF000742)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Forgot password? ",
                                style: TextStyle(color: Color(0xFF000742)),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  foregroundColor: Color(0xFF000742),
                                ),
                                onPressed: () {},
                                child: Text("click here"),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: handleLogin,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFF000742),
                            minimumSize: Size(180, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text("Login"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Color(0xFF000742)),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0),
                      foregroundColor: Color(0xFF000742),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => RegistrationScreen(),
                        ),
                      );
                    },
                    child: Text("Sign Up"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleLogin() async {
    if (formKey.currentState!.validate()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        barrierDismissible: false,
      );
      try {
        UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: emailCtrl.text,
              password: passCtrl.text,
            );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(uid: user.user!.uid),
          ),
        );
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Something went wrong",
          text: e.message,
        );
      }
    }
  }
}
