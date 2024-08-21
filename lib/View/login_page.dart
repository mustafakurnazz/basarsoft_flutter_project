import 'package:basarsoft/View/home_page.dart';
import 'package:basarsoft/View/sign_up.dart';
import 'package:basarsoft/Widget/form_container.dart';
import 'package:flutter/material.dart';
import 'package:basarsoft/Sevice/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuthService auth = FirebaseAuthService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
             children: [
            const Text("Giriş Yap", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
            const SizedBox(height: 100,),
            FormContainer(
              controller: emailController,
              hintText: "email",
            ),
            const SizedBox(height: 30,),
            FormContainer(
              controller: passwordController,
              hintText: "şifre",
              obsurcetext: true,
            ),
            const SizedBox(height: 30,),
            GestureDetector(
              onTap: signIn,
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: Text("Giriş Yap", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),)
              )
            ),
            const SizedBox(height: 10,),
             GestureDetector(
              onTap: () {
                auth.signInWithGoogleFirebase(context);
              },
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.google, color: Colors.white,),
                    SizedBox(width: 5,),
                    Text("Google ile Giriş Yap", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  ],
                ),)
              )
            ),
            const SizedBox(height: 10,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Henüz hesabın yok mu ?"),
              const SizedBox(width: 5,),
              GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignUpPage()), (route) => false);
                },
                child: const Text("Kayıt Ol", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
              )
            ],
            )
          ],
          ),
        ),
      ),
    );
  }
 void signIn() async {
    String email = emailController.text;
    String password = passwordController.text;

    User? user = await auth.signIn(email, password);

    if (user == null) {
      print("error");
    } else {
     Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(
      totalDistance: 5.5, 
      totalDuration: const Duration(hours: 1, minutes: 30), 
      count: 10,
      )));
    }
  }
}