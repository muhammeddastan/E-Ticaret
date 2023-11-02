// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Model/FavorilerModel.dart';
import 'package:e_commerce/Model/UrunlerModel.dart';

import 'package:e_commerce/Views/Favoriler.dart';
import 'package:e_commerce/Widget/UrunDetayPopUp.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UrunDetay extends StatefulWidget {
  UrunDetay({required this.urunModel});
  final UrunModel urunModel;

  @override
  _UrunDetayState createState() => _UrunDetayState();
}

class _UrunDetayState extends State<UrunDetay> {
  bool _favoriEklendi = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.amber,
        title: const Text(
          "Ürünler",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        centerTitle: false,
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12.withOpacity(0.05)),
              child: IconButton(
                icon: Icon(
                  _favoriEklendi ? Icons.favorite : Icons.favorite_border,
                  color: _favoriEklendi ? Colors.amber : Colors.amber,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _favoriEklendi = !_favoriEklendi; // Durumu tersine çevir
                  });

                  if (_favoriEklendi) {
                    // Favori ekleniyor
                    FavoriModel favoriModel = FavoriModel(urun: null);
                    favoriModel.urun = widget.urunModel;
                    FavorilerView.favoriUrunler.add(favoriModel);
                    print(FavorilerView.favoriUrunler);

                    final snackBar = SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.amber, size: 50),
                          SizedBox(width: 20),
                          Text(
                            "Ürün Favorilere Eklendi",
                            style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ],
                      ),
                      duration: const Duration(milliseconds: 1500),
                      backgroundColor: Colors.white,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    // Favoriden çıkarılıyor
                    FavorilerView.favoriUrunler.removeWhere(
                        (favori) => favori.urun! == widget.urunModel);

                    final snackBar = SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.favorite_border,
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
                      duration: const Duration(milliseconds: 1500),
                      backgroundColor: Colors.white,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ),
            UrunDetayPopUp(urunModel: widget.urunModel),
          ],
        ),
      ),
      body: ListView(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 420,
                    width: MediaQuery.of(context).size.width,
                    //RESİM GELECEK
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.network(
                        '${widget.urunModel.urunFotografi}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            widget.urunModel.urunAdi!,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w900,
                                fontSize: 25),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${widget.urunModel.urunKategori}",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      Text(
                        "${widget.urunModel.urunFiyati!.toString()} ₺",
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber),
                      )
                    ],
                  ),
                  //PUAN WİDGET

                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 25,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.urunModel.urunAciklama!,
                      style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
