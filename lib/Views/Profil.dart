import 'package:e_commerce/Model/UrunlerModel.dart';
import 'package:e_commerce/Services/AuthServices.dart';
import 'package:e_commerce/Views/Admin/AdminPanel.dart';
import 'package:e_commerce/Views/Admin/NavigationScreen.dart';
import 'package:e_commerce/Views/Ayarlar.dart';
import 'package:e_commerce/Views/Favoriler.dart';
import 'package:e_commerce/Views/GirisSayfa.dart';
import 'package:e_commerce/Views/KayitOl.dart';
import 'package:e_commerce/Views/Sepetim.dart';
import 'package:e_commerce/Views/Siparisler.dart';
import 'package:e_commerce/Views/Splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce/Views/Ayarlar.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  String? _ad;
  String? _soyad;
  String? _eposta;
  String? _imageURL;

  @override
  void initState() {
    super.initState();
    _getKullaniciAdSoyad();
    _getProfileImageURL();
    _getEposta();
  }

  Future<void> _getProfileImageURL() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String uid = user.uid;
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profiles/$uid/profile.jpg');

      try {
        final String imageURL = await storageRef.getDownloadURL();
        setState(() {
          _imageURL = imageURL;
        });
      } catch (e) {
        print("Profil fotoğrafı yüklenirken hata oluştu: $e");
      }
    }
  }

  Future<void> _getKullaniciAdSoyad() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _ad = user.displayName?.split(" ").first; // Kullanıcı adı
        _soyad = user.displayName?.split(" ").last; // Kullanıcı soyadı
      });
    }
  }

  Future<void> _getEposta() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _eposta = user.email ?? "";
      });
    }
  }

  String adminUID = "44QMfjWxVqSdSuGrMNPCgHfUxwm2";

  Widget adminButton() {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Oturum açma durumu beklendiği sürece bir yükleme gösterebilirsiniz.
          return CircularProgressIndicator();
        } else if (!snapshot.hasData) {
          // Kullanıcı oturum açmamışsa "Admin" butonunu gösterme
          return SizedBox(); // Görünmez bir widget döndürebilirsiniz.
        } else {
          // Kullanıcı oturum açtıysa, UID'sini kontrol ederek "Admin" butonunu gösterme
          bool isAdmin = snapshot.data!.uid == adminUID;
          if (isAdmin) {
            return Padding(
              padding: const EdgeInsets.only(top: 220.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavigationAdminView(),
                    ),
                  );
                },
                child: Text(
                  "Admin Girişi",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.amber),
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.001),
        foregroundColor: Colors.amber,
        title: const Text(
          "Profil",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AyarlarView(),
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.gear,
              size: 30,
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: _imageURL != null
                              ? NetworkImage(_imageURL!)
                              : null,
                          backgroundColor: Colors.amber,
                          maxRadius: 30,
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$_ad $_soyad".toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 15),
                        ),
                        Text(
                          "$_eposta",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(20)),
              const SizedBox(height: 20),
              Container(
                width: 380,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(17),
                child: InkWell(
                  child: const Text(
                    "Sepetim",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.amber),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SepetimView(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: 380,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(17),
                child: InkWell(
                  child: const Text(
                    "Favoriler",
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavorilerView(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: 380,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(17),
                child: InkWell(
                  child: const Text(
                    "Siparişlerim",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SiparislerimView(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              Container(
                height: 50,
                width: 380,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(17),
                child: InkWell(
                  child: const Text(
                    "Hesabı Kapat",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  onTap: () {
                    cikisYapAlert(context);
                  },
                ),
              ),
              const SizedBox(height: 5),
              adminButton(),
            ],
          ),
        ],
      ),
    );
  }
}

void cikisYapAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text(
          "Hesabı Kapat",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Hesabınız Kapatılsın mı?",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text("Hayır"),
            onPressed: () {
              Navigator.of(context).pop(); // Dialog'u kapat
            },
          ),
          CupertinoDialogAction(
            child: const Text("Evet"),
            onPressed: () {
              Navigator.of(context).pop();
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SplashView(),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
