import 'package:e_commerce/Model/FavorilerModel.dart';
import 'package:e_commerce/Views/UrunDetay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavorilerView extends StatefulWidget {
  static List<FavoriModel> favoriUrunler = [];

  @override
  State<FavorilerView> createState() => _FavorilerViewState();
}

class _FavorilerViewState extends State<FavorilerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favoriler",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.black.withOpacity(0.001),
        foregroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Visibility(
            visible: FavorilerView.favoriUrunler.isEmpty,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 250.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite_border_outlined,
                      size: 100,
                      color: Colors.amber,
                    ),
                    Text(
                      'Favori Listeniz Boş',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Beğendiğiniz Ürünleri Kalp Butonuna Basarak Favorilere Ekleyebilirsiniz',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: FavorilerView.favoriUrunler.isNotEmpty,
            child: ListView.builder(
              itemCount: FavorilerView.favoriUrunler.length,
              itemBuilder: (context, index) {
                final urun = FavorilerView.favoriUrunler[index];
                return Container(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                      height: 150,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.transparent,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UrunDetay(
                                  urunModel: urun.urun!,
                                ),
                              ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            children: [
                              Padding(padding: EdgeInsets.all(10)),
                              Container(
                                width: 80,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        urun.urun!.urunFotografi!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Kategori: ${urun.urun!.urunKategori!}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      "Ürün: ${urun.urun!.urunAdi!}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      "Fiyat: ${urun.urun!.urunFiyati!.toStringAsFixed(2)} ₺",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 70),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // FAVORİLERDEN ÇIKARMA
                                      setState(() {
                                        FavorilerView.favoriUrunler
                                            .removeAt(index);
                                      });

                                      final snackBar = SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(Icons.favorite_border_outlined,
                                                color: Colors.amber, size: 50),
                                            SizedBox(width: 20),
                                            Text(
                                              "Ürün Favorilerden Çıkarıldı",
                                              style: TextStyle(
                                                  color: Colors.amber,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                            ),
                                          ],
                                        ),
                                        duration:
                                            const Duration(milliseconds: 1500),
                                        backgroundColor: Colors.white,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.heart_slash,
                                      color: Colors.amber,
                                      size: 35,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
