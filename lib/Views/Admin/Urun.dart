import 'dart:io';
import 'package:e_commerce/Model/UrunlerModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YeniUrunAdminView extends StatefulWidget {
  @override
  _YeniUrunAdminViewState createState() => _YeniUrunAdminViewState();
}

class _YeniUrunAdminViewState extends State<YeniUrunAdminView> {
  String urunAdi = "";
  String urunAciklama = "";
  double urunFiyat = 0.0;
  String urunKategori = "";
  String secilenRenkler = "";
  String secilenBedenler = "";
  XFile? urunFotografi; // Seçilen resim dosyası

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        urunFotografi = pickedFile;
      });
    }
  }

  Future<void> urunEkle() async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Resim URL'si Firestore'a yükleniyor (Firebase Storage kullanarak)
      String? imageUrl = await uploadImage(urunFotografi);

      // Firestore'da "Urunler" koleksiyonuna yeni bir belge ekleyin
      await firestore.collection('Urunler').add({
        'urunAdi': urunAdi,
        'urunAciklama': urunAciklama,
        'urunFiyati': urunFiyat,
        'urunKategori': urunKategori,
        'secilenRenkler': secilenRenkler,
        'secilenBedenler': secilenBedenler,
        'urunFotografi': imageUrl,
      });

      print('Ürün başarıyla eklendi.');
      setState(() {
        urunAdi = "";
        urunAciklama = "";
        urunFiyat = 0.0;
        urunKategori = "";
        secilenRenkler = "";
        secilenBedenler = "";
        urunFotografi = null;
      });
    } catch (e) {
      print('Ürün eklenirken hata oluştu: $e');
    }
  }

  Future<String?> uploadImage(XFile? imageFile) async {
    try {
      if (imageFile == null) {
        return null;
      }

      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference storageRef = storage
          .ref()
          .child('urun_resimleri')
          .child(DateTime.now().toString() + '.jpg');
      await storageRef.putFile(File(imageFile.path));
      final String imageUrl = await storageRef.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Resim yüklenirken hata oluştu: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YENİ ÜRÜN EKLE"),
        backgroundColor: Colors.amber,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              // Resim Seçimi
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 210,
                      color: Colors.grey[300],
                    ),
                    if (urunFotografi != null)
                      Image.file(
                        File(urunFotografi!.path),
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        child: Text("Resim Seç"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.amber)),
                      ),
                    ),
                  ],
                ),
              ),
              // Ürün Adı Girişi
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12.withOpacity(0.05),
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Ürün Adı',
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        urunAdi = value;
                      });
                    },
                  ),
                ),
              ),
              // Ürün Açıklama Girişi
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12.withOpacity(0.05),
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Ürün Açıklaması',
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        urunAciklama = value;
                      });
                    },
                  ),
                ),
              ),
              // Ürün Fiyatı Girişi
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12.withOpacity(0.05),
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Ürün Fiyatı',
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        urunFiyat = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                ),
              ),
              // Ürün Kategorisi Girişi
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12.withOpacity(0.05),
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Ürün Kategori',
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        urunKategori = value;
                      });
                    },
                  ),
                ),
              ),
              // Ürün Rengi Seçimi
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12.withOpacity(0.05),
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Ürün Renk',
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        secilenRenkler = value;
                      });
                    },
                  ),
                ),
              ),
              //Urun Beden
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12.withOpacity(0.05),
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Ürün Beden',
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        secilenBedenler = value;
                      });
                    },
                  ),
                ),
              ),
              // Ürün Ekle Düğmesi
              ElevatedButton(
                onPressed: urunEkle,
                child: Text("Ürün Ekle"),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.amber),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
