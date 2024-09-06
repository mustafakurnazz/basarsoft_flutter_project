import 'package:basarsoft/View/logIn/auth_view_model.dart';
import 'package:basarsoft/View/logIn/login_view.dart';
import 'package:basarsoft/core/widget/form_container.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthViewModel _authViewModel = AuthViewModel(); 

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Kayıt Ol",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 100),
              FormContainer(
                controller: nameController,
                hintText: "ad/soyad",
                validator: (String? value) {
                  if (value != null && value.isEmpty) {
                    return "Kullanıcı adı boş olamaz";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              FormContainer(
                controller: emailController,
                hintText: "Email",
              ),
              const SizedBox(height: 30),
              FormContainer(
                controller: passwordController,
                hintText: "şifre",
                obsurcetext: true,
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                   String name = nameController.text;
                   String email = emailController.text;
                   String password = passwordController.text;
                   _authViewModel.signUp(email, password, name, context);
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Kayıt Ol",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Zaten hesabın var mı ?"),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Giriş Yap",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
