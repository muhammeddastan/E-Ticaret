import 'package:e_commerce/Views/Sepetim.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MaterialApp(
      home: SepetOdemeView(),
    ));

class SepetOdemeView extends StatefulWidget {
  @override
  State<SepetOdemeView> createState() => _SepetOdemeViewState();
}

class _SepetOdemeViewState extends State<SepetOdemeView> {
  TextEditingController adSoyadController = TextEditingController();
  TextEditingController adresController = TextEditingController();
  TextEditingController telefonController = TextEditingController();
  TextEditingController ePostaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ödeme"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12.withOpacity(0.05),
                ),
                child: TextFormField(
                  controller: adSoyadController,
                  decoration: const InputDecoration(
                    labelText: 'Adı Soyadı',
                    labelStyle: TextStyle(color: Colors.black),
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12.withOpacity(0.05)),
                child: TextFormField(
                  controller: adresController,
                  decoration: const InputDecoration(
                      labelText: 'Adres',
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12.withOpacity(0.05)),
                child: TextFormField(
                  controller: telefonController,
                  decoration: const InputDecoration(
                      labelText: 'Telefon Numarası',
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12.withOpacity(0.05)),
                child: TextFormField(
                  controller: ePostaController,
                  decoration: const InputDecoration(
                      labelText: 'E-Posta',
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    odemeYapVeSiparisiKaydet();
                  },
                  child: Text("Sipariş Ver"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.amber)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void odemeYapVeSiparisiKaydet() {
    final adSoyad = adSoyadController.text;
    final adres = adresController.text;
    final telefon = telefonController.text;
    final ePosta = ePostaController.text;

    List<Map<String, dynamic>> sepetUrunleri = [];
    for (var urun in SepetimView.sepetUrunler) {
      if (urun.urun != null) {
        // Ürün null değilse ekleyin
        sepetUrunleri.add({
          'urunFotografi': urun.urun!.urunFotografi,
          'urunAdi': urun.urun!.urunAdi,
          'secilenRenk': urun.urun!.secilenRenkler,
          'urunAdet': urun.adet,
          'urunBeden': urun.urun!.secilenBedenler,
          'urunFiyati': urun.urun!.urunFiyati,
          'toplamFiyat': urun.adet * urun.urun!.urunFiyati!.toDouble()
          // Diğer ürün özellikleri
        });
      }
    }

    FirebaseFirestore.instance.collection('Siparisler').add({
      'AdSoyad': adSoyad,
      'Adres': adres,
      'Telefon': telefon,
      'Eposta': ePosta,
      'SepetUrunleri': sepetUrunleri,
      // Diğer sipariş bilgilerini de ekleyebilirsiniz.
    }).then((value) {
      adSoyadController.clear();
      adresController.clear();
      telefonController.clear();
      // Sipariş başarıyla kaydedildiğinde kullanıcıya bildirim gösterin veya başka bir işlem yapın.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sipariş başarıyla kaydedildi."),
        ),
      );
    }).catchError((error) {
      // Hata durumunda kullanıcıya hata mesajı gösterin.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sipariş kaydedilirken bir hata oluştu: $error"),
        ),
      );
    });
  }
}
