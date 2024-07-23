import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/Screens/signup.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../bottombar.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            Text(
              'Hello Again!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28.px,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5.px),
            Text(
              'Welcome Back You’ve Been Missed!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.px,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30.px),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      hintStyle: TextStyle(fontSize: 16.px, fontWeight: FontWeight.w500),
                      helperText: 'AlissonBecker@gmail.com',
                      helperStyle: TextStyle(fontSize: 14.px, fontWeight: FontWeight.w400),
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
                  SizedBox(height: 20.px),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(fontSize: 16.px, fontWeight: FontWeight.w500),
                      helperText: 'Enter your password',
                      helperStyle: TextStyle(fontSize: 14.px, fontWeight: FontWeight.w400),
                      prefix: Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Password';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 35.px),
            TextButton(
              onPressed: () async {
                await _loginInWithEmailAndPassword(_emailController.text, _passwordController.text);
                // Navigate to home screen only if authentication is successful
                if (_auth.currentUser != null) {
                  print("User Not Null");
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar()));
                }
              },
              child: Text(
                'Login',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.px,
                  color: Colors.black,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                fixedSize: const Size(335, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.px)),
              ),
            ),
            SizedBox(height: 25.px),
            InkWell(
              onTap: () async{
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
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don’t have an Account?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
                  },
                  child: const Text('Sign Up for Free'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _loginInWithEmailAndPassword(String email, String password) async {
    try {
      print("email: $email");
      print("password: $password");
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        print("User signed in: ${user.email}"); // Debug log
        Get.snackbar("User signed in: ", "${user.email}", margin: EdgeInsets.all(30), snackPosition: SnackPosition.TOP);
      } else {
        print("No user found");
        Get.snackbar("No user found", "", margin: EdgeInsets.all(30), snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      print("Failed to sign in: $e"); // Debug log
      Get.snackbar("Failed to sign in with email and password: ", "$e", margin: EdgeInsets.all(30), snackPosition: SnackPosition.TOP);
    }
  }
  Future<void> UserSignInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        print("googleUser not nul");
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;
        if (user != null) {
          Get.snackbar("User signed in:", "${user.email}", margin: EdgeInsets.all(30), snackPosition: SnackPosition.TOP);
          Get.to(BottomBar());
        }
      }
    } catch (e) {
      Get.snackbar("Failed to sign in with Google", "$e", margin: EdgeInsets.all(30), snackPosition: SnackPosition.TOP);
    }
  }
}
