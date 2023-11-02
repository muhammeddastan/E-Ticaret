import 'package:e_commerce/Views/Admin/UrunDuzenle.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("YAYINDAKİ ÜRÜNLER"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Urunler').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Veriler alınırken hata oluştu: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return Text('Hiç veri yok.');
          }

          final urunler = snapshot.data!.docs;

          return ListView.builder(
            itemCount: urunler.length,
            itemBuilder: (context, index) {
              final urun = urunler[index];
              final adi = urun['urunAdi'];
              final aciklama = urun['urunAciklama'];
              final resim = urun['urunFotografi'];
              final fiyat = urun['urunFiyati'];
              final kategori = urun['urunKategori'];
              final renkler = urun['secilenRenkler'];
              final bedenler = urun['secilenBedenler'];

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.black12.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          height: 150,
                          width: 100,
                          color: Colors.black,
                          child: Image.network(resim),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            "Adı:\n${adi}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Fiyatı:\n$fiyat ₺",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Kategori:\n${kategori}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Renk:\n${renkler}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Beden:\n${bedenler}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              children: [
                                //ÜRÜN SİLME İŞLEMİ
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Ürünü Sil"),
                                          content: const Text(
                                              "Bu ürünü yayından kaldırmak istediğinize emin misiniz?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Dialog'yu kapat
                                              },
                                              child: const Text("İptal"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Ürünü Firestore'dan sil
                                                FirebaseFirestore.instance
                                                    .collection('Urunler')
                                                    .doc(urun.id)
                                                    .delete()
                                                    .then((_) {
                                                  // Silme işlemi başarılı ise
                                                  Navigator.of(context)
                                                      .pop(); // Dialog'yu kapat
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Ürün başarıyla silindi.',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      backgroundColor:
                                                          Colors.amber,
                                                    ),
                                                  );
                                                }).catchError((error) {
                                                  // Silme işlemi hata verirse
                                                  Navigator.of(context)
                                                      .pop(); // Dialog'yu kapat
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Ürün silinirken hata oluştu: $error'),
                                                    ),
                                                  );
                                                });
                                              },
                                              child: Text("Sil"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text("Sil"),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.red)),
                                ),
                                SizedBox(width: 10),
                                //ÜRÜN DÜZENLEME İŞLEMİ
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UrunDuzenlemeView(urun: urun),
                                      ),
                                    );
                                  },
                                  child: Text("Düzenle"),
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.green)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
