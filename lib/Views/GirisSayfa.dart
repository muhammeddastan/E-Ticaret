// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:e_commerce/Services/AuthServices.dart';
import 'package:e_commerce/Views/KayitOl.dart';
import 'package:e_commerce/Views/NavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  State<LoginPageView> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageView> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Kullanıcı oturumu kontrol etmek için initState içinde kulanıyoruz
    checkUserLoginStatus();
  }

  Future<void> checkUserLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Kullanıcı oturum açık ise ana sayfaya yönlendirin.
      await Future.delayed(Duration.zero);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationScreen(),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Kullanıcı giriş işlemi
  Future<void> _loginUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Firebase üzerinden giriş yapma işlemi
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Giriş Yapıldı.",
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          backgroundColor: Colors.amber,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationScreen(),
        ),
      );
    } catch (e) {
      // Giriş sırasında bir hata olursa hata mesajını gösterin.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Hata'),
            content: Text('Giriş yapılırken bir hata oluştu: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'E-Posta',
          style: TextStyle(
              color: Colors.amber, fontSize: 17.0, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          decoration: BoxDecoration(
            color: Color(0xffFFC300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _emailController, // Emaili kontrol etmek için
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Eposta Adresinizi Giriniz',
              hintStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Şifre',
          style: TextStyle(
              color: Colors.amber, fontSize: 17.0, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          decoration: BoxDecoration(
            color: Color(0xffFFC300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _passwordController, // Şifreyi kontrol etmek için
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Şifrenizi Giriniz',
              hintStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildForgotPassTF() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => print('Şifremi unuttum butonuna basıldı'),
        child: const Text(
          'Şifremi Unuttum',
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildLoginButtonTF() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(30)),
        height: 50,
        width: 150,
        child: Center(
          child: TextButton(
            onPressed: _loginUser, // Giriş yapma işlevi
            child: const Text(
              "Giriş Yap",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _googleAuth() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: Container(
              height: 50,
              width: 220,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 15)),
                  Image.asset("assets/logo/google.png", height: 30),
                  Padding(padding: EdgeInsets.only(left: 7)),
                  Text(
                    "Google ile Giriş Yap",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            onTap: () => AuthService().signInWithGoogle(context),
          ),
          Padding(padding: EdgeInsets.all(5)),
          InkWell(
            child: Container(
              height: 50,
              width: 220,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 15)),
                  Image.asset("assets/logo/facebook.png", height: 30),
                  Padding(padding: EdgeInsets.only(left: 7)),
                  Text(
                    "Facebook ile Giriş Yap",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }

  Widget _signUp() {
    return Padding(
      padding: const EdgeInsets.only(left: 200, top: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            "Hesabınız Yok Mu?",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpView(),
                ),
              );
            },
            child: const Text(
              "Kayıt Ol",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffFFC300),
                  Color(0xffFCCB2D),
                  Color(0xffFED95F),
                  Color(0xffFDE288),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 180.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 90.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hoşgeldiniz \nGiriş Yap",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 70.0),
                  _buildEmailTF(),
                  const SizedBox(height: 15),
                  _buildPasswordTF(),
                  _buildForgotPassTF(),
                  const SizedBox(height: 30),
                  _buildLoginButtonTF(),
                  const SizedBox(height: 20),
                  _googleAuth(),
                  _signUp()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
