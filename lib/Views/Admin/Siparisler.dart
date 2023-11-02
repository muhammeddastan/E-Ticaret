import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SiparislerAdminView extends StatefulWidget {
  const SiparislerAdminView({super.key});

  @override
  State<SiparislerAdminView> createState() => _SiparislerAdminViewState();
}

class _SiparislerAdminViewState extends State<SiparislerAdminView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("SİPARİŞLER"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Siparisler").snapshots(),
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

          final siparisler = snapshot.data!.docs;

          return ListView.builder(
            itemCount: siparisler.length,
            itemBuilder: (context, index) {
              final siparis = siparisler[index];
              final adi = siparis['urunAdi'];
              final resim = siparis['urunFotografi'];
              final fiyat = siparis['urunFiyati'];
              final renkler = siparis['secilenRenk'];
              final bedenler = siparis['urunBeden'];
              final adet = siparis['urunAdet'];
              final toplam = siparis['toplamFiyat'];
              final adSoyad = siparis['AdSoyad'];
              final adres = siparis['Adres'];
              final telefon = siparis['Telefon'];

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
                            "Renk:\n${renkler}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Beden:\n${bedenler}",
                            style: TextStyle(fontWeight: FontWeight.bold),
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
