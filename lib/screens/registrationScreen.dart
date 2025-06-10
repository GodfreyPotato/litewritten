import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:litewritten/screens/loginScreen.dart';
import 'package:quickalert/quickalert.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var emailCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  var usernameCtrl = TextEditingController();
  var cpassCtrl = TextEditingController();
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
                          "Create an Account",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000742),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: usernameCtrl,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF000742)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: emailCtrl,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF000742)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: cpassCtrl,
                          obscureText: isShown,
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
                            labelText: "Confirm Password",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF000742)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value != passCtrl.text) {
                              return "Please check your password";
                            }
                            return null;
                          },
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: handleRegistration,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xFF000742),
                              minimumSize: Size(180, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text("Create"),
                          ),
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
                    "Already have an account? ",
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
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text("Log in"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleRegistration() async {
    if (formKey.currentState!.validate()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        barrierDismissible: false,
      );
      try {
        UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailCtrl.text,
              password: passCtrl.text,
            );

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.user!.uid)
            .set({"username": usernameCtrl.text, "email": emailCtrl.text});

        Navigator.of(context).pop();
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: "Account Created!",
        );

        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => LoginScreen()));
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: e.message,
          title: "Error Occured!",
        );
      }
    }
  }
}
