import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodapp/bottombar.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _usernameController.text,
          'email': email,
        });

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar())); // Navigate to BottomBar
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Unknown error occurred");
      print("Firebase Auth Error: ${e.message}");
    } catch (e) {
      Get.snackbar("Error", "An unknown error occurred");
      print("Unknown Error: $e");
    }
  }

  Future<void> UserSignInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;
        if (user != null) {
          Get.snackbar("User signed in:", "${user.email}", margin: EdgeInsets.all(30), snackPosition: SnackPosition.TOP);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar())); // Navigate to BottomBar
        }
      }
    } catch (e) {
      Get.snackbar("Failed to sign in with Google", "$e", margin: EdgeInsets.all(30), snackPosition: SnackPosition.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Create Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28.px,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5.px),
            Text('Let’s Create Account Together',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.px,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20.px),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Your Name', hintStyle: TextStyle(fontSize: 16.px, fontWeight: FontWeight.w500),
                      helperText: 'Alisson Becker', helperStyle: TextStyle(fontSize: 14.px, fontWeight: FontWeight.w400),
                      prefix: Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email Address', hintStyle: TextStyle(fontSize: 16.px, fontWeight: FontWeight.w500),
                      helperText: 'AlissonBecker@gmail.com', helperStyle: TextStyle(fontSize: 14.px, fontWeight: FontWeight.w400),
                      prefix: Icon(Icons.alternate_email),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password', hintStyle: TextStyle(fontSize: 16.px, fontWeight: FontWeight.w500),
                      helperText: 'AlissonBecker@gmail.com', helperStyle: TextStyle(fontSize: 14.px, fontWeight: FontWeight.w400),
                      prefix: Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Email';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.px),
            TextButton(
              onPressed: () async {
                await signUpWithEmailAndPassword(_emailController.text, _passwordController.text);
              },
              child: Text('Sign Up',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.px,
                  color: Colors.black,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                fixedSize: const Size(335, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.px),
                ),
              ),
            ),
            SizedBox(height: 25.px),
            InkWell(
              onTap: () async {
                await UserSignInWithGoogle();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage("assets/google_icon.jpeg"),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  Text(
                    "Sign In with Google",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.px),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignIn()));
                  },
                  child: const Text('Sign In'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
