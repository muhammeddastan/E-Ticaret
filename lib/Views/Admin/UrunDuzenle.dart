import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UrunDuzenlemeView extends StatefulWidget {
  final DocumentSnapshot urun;
  UrunDuzenlemeView({required this.urun});

  @override
  _UrunDuzenlemeViewState createState() => _UrunDuzenlemeViewState();
}

class _UrunDuzenlemeViewState extends State<UrunDuzenlemeView> {
  String urunAdi = "";
  String urunAciklama = "";
  double urunFiyat = 0.0;
  String urunKategori = "";
  String secilenRenkler = "";
  String secilenBedenler = "";

  @override
  void initState() {
    super.initState();
    // Mevcut ürün verileriyle düzenleme ekranını doldur
    urunAdi = widget.urun['urunAdi'];
    urunAciklama = widget.urun['urunAciklama'];
    urunFiyat = widget.urun['urunFiyati'];
    urunKategori = widget.urun['urunKategori'];
    secilenBedenler = widget.urun['secilenBedenler'];
    secilenRenkler = widget.urun['secilenRenkler'];
  }

  void _kaydet() {
    // Değişiklikleri Firestore'a kaydet
    FirebaseFirestore.instance
        .collection('Urunler')
        .doc(widget.urun.id)
        .update({
      'urunAdi': urunAdi,
      'urunAciklama': urunAciklama,
      'urunFiyati': urunFiyat,
      'urunKategori': urunKategori,
      'secilenBedenler': secilenBedenler,
      'secilenRenkler': secilenRenkler
    }).then((_) {
      // Başarılı bir şekilde kaydedildiğinde işlem tamamlandı mesajı gösterin
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ürün başarıyla güncellendi.'),
        ),
      );
    }).catchError((error) {
      // Hata durumunda hata mesajı gösterin
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ürün güncellenirken hata oluştu: $error'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Ürün Düzenleme'),
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
                  initialValue: urunAdi,
                  decoration: InputDecoration(
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
                  initialValue: urunAciklama,
                  decoration: InputDecoration(
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
                  initialValue: urunFiyat.toString(),
                  decoration: InputDecoration(
                    labelText: 'Ürün Fiyatı',
                    labelStyle: TextStyle(color: Colors.black),
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      urunFiyat = double.tryParse(value) ?? 0.0;
                    });
                  },
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
                  color: Colors.black12.withOpacity(0.05),
                ),
                child: TextFormField(
                  initialValue: urunKategori,
                  decoration: InputDecoration(
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
                  initialValue: secilenBedenler,
                  decoration: InputDecoration(
                    labelText: 'Beden',
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
                  initialValue: secilenRenkler,
                  decoration: InputDecoration(
                    labelText: 'Renk',
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
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Container(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _kaydet,
                    child: Text("Kaydet"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.amber)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
