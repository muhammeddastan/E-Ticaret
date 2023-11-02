import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AyarlarView extends StatefulWidget {
  const AyarlarView({super.key});

  @override
  State<AyarlarView> createState() => _AyarlarViewState();
}

class _AyarlarViewState extends State<AyarlarView> {
  String? _ad;
  String? _soyad;
  String? _eposta;

  @override
  void initState() {
    super.initState();
    _getKullaniciAdSoyad();
    _ePosta();
  }

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

  Future<void> _updateUserInfo(String ad, String soyad, String eposta) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updateDisplayName('$ad $soyad');
        await user.updateEmail(eposta);
        setState(() {
          _ad = ad;
          _soyad = soyad;
          _eposta = eposta;
        });
      } catch (e) {
        print("Kullanıcı bilgileri güncellenirken hata oluştu: $e");
      }
    }
  }

  Future<void> _getKullaniciAdSoyad() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _ad = user.displayName?.split(" ").first ?? "";
        _soyad = user.displayName?.split(" ").last ?? "";
      });
    }
  }

  Future<void> _ePosta() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _eposta = user.email ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayarlar"),
        elevation: 0,
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: FutureBuilder<String>(
                  future: _getProfileImageURL(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      String imageURL = snapshot.data!;
                      return CircleAvatar(
                        maxRadius: 64,
                        backgroundImage: NetworkImage(imageURL),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
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
            const Padding(
              padding: EdgeInsets.only(left: 25.0, top: 30),
              child: Text(
                "Ad Soyad",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '$_ad'.toUpperCase(),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '$_soyad'.toUpperCase(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 25.0, top: 20),
              child: Text(
                "E-Posta",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('$_eposta'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
