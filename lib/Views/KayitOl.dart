// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:io';

import 'package:e_commerce/Views/GirisSayfa.dart';
import 'package:e_commerce/Views/NavigationBar.dart';
import 'package:e_commerce/Views/Splash.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _soyadController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File image = File(pickedFile.path);

      try {
        final User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          final Reference storageRef = FirebaseStorage.instance
              .ref()
              .child('user_profiles')
              .child(user.uid)
              .child('profile.jpg');

          UploadTask uploadTask = storageRef.putFile(image);
          await uploadTask.whenComplete(() async {
            print("Resim Yüklendi");
            String imageURL = await storageRef.getDownloadURL();
            print("Resim URL: $imageURL");

            setState(() {});
          });
        }
      } catch (e) {
        print("Profil fotoğrafı yüklenirken hata oluştu: $e");
      }
    } else {
      print("Resim Seçilmedi");
    }
  }

  Future<String> _getProfileImageURL() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profiles')
          .child(user.uid)
          .child('profile.jpg');

      // Profil resmi yüklendiyse URL'i al
      try {
        String imageURL = await storageRef.getDownloadURL();
        return imageURL;
      } catch (e) {
        return "";
      }
    }

    return "";
  }

  Future<void> _kayitOl() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _sifreController.text,
      );
      User? user = userCredential.user;
      user?.updateDisplayName("${_adController.text} ${_soyadController.text}");

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Kayıt Başarılı. ",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashView(),
          ),
        );
      }
    } catch (e) {
      print('Kullanıcı kayıt olurken hata oluştu: $e');
    }
  }

  Widget _profilFoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: FutureBuilder<String>(
            future: _getProfileImageURL(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String imageURL = snapshot.data!;
                return CircleAvatar(
                  maxRadius: 40,
                  backgroundImage: NetworkImage(imageURL),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () {
              _pickAndUploadImage();
            },
            child: const Text("Resim yükle"),
          ),
        ),
      ],
    );
  }

  Widget _ad() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          decoration: BoxDecoration(
            color: const Color(0xffFFC300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _adController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Ad',
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

  Widget _soyad() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          decoration: BoxDecoration(
            color: const Color(0xffFFC300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _soyadController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Soyad',
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

  Widget _mail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          decoration: BoxDecoration(
            color: const Color(0xffFFC300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _emailController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Eposta',
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

  Widget _sifre() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          decoration: BoxDecoration(
            color: const Color(0xffFFC300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _sifreController,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Şifre',
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

  Widget _kayitOlButton() {
    return Center(
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: TextButton(
            onPressed: _kayitOl,
            child: const Text(
              "Kayıt Ol",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _girisYap() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Bir hesabınız var mı?"),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPageView(),
                ),
              );
            },
            child: const Text(
              "Giriş Yap",
              style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
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
          SizedBox(
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
                    "Hoşgeldiniz \nKayıt Ol",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  _profilFoto(),
                  SizedBox(height: 10),
                  _ad(),
                  SizedBox(height: 10),
                  _soyad(),
                  SizedBox(height: 30),
                  _mail(),
                  SizedBox(height: 10),
                  _sifre(),
                  SizedBox(height: 30),
                  _kayitOlButton(),
                  SizedBox(height: 30),
                  _girisYap()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
