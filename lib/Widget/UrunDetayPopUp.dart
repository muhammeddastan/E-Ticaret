// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:e_commerce/Model/SepetModel.dart';
import 'package:e_commerce/Model/UrunlerModel.dart';
import 'package:e_commerce/Views/Sepetim.dart';
import 'package:e_commerce/Widget/ContainerButton.dart';
import 'package:flutter/material.dart';

class UrunDetayPopUp extends StatefulWidget {
  final UrunModel urunModel;
  UrunDetayPopUp({required this.urunModel});

  @override
  _UrunDetayPopUpState createState() => _UrunDetayPopUpState();
}

class _UrunDetayPopUpState extends State<UrunDetayPopUp> {
  bool secildiMi = false;
  int urunAdet = 1;
  double toplamFiyat = 0;

  @override
  void initState() {
    toplamFiyat = urunAdet * widget.urunModel.urunFiyati!;
    super.initState();
  }

  final iStyle = const TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => StatefulBuilder(
                  builder: (BuildContext context, StateSetter newState) =>
                      Container(
                    height: MediaQuery.of(context).size.height / 3.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("Beden:", style: iStyle),
                              const SizedBox(width: 20),
                              Text(
                                "${widget.urunModel.secilenBedenler}",
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text("Renk:", style: iStyle),
                              const SizedBox(width: 20),
                              Text(
                                "${widget.urunModel.secilenRenkler}",
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Toplam:",
                                style: iStyle,
                              ),
                              Text(
                                "${toplamFiyat.toString()} ₺",
                                style: const TextStyle(
                                    color: Colors.amber,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              // Ürünün sepete eklenip eklenmediğini kontrol et
                              bool urunZatenSepette = false;

                              // Sepetinizde ürün var mı diye kontrol edin
                              for (SepetModel sepetModel
                                  in SepetimView.sepetUrunler) {
                                if (sepetModel.urun == widget.urunModel) {
                                  urunZatenSepette = true;
                                  break;
                                }
                              }

                              if (urunZatenSepette) {
                                // Eğer ürün sepette ise Snackbar göster
                                const snackBar = SnackBar(
                                  content: Text(
                                    "Ürün zaten sepette!",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  duration: Duration(seconds: 3),
                                  backgroundColor:
                                      Colors.red, // Snackbar arka plan rengi
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                // Eğer ürün sepette yoksa, ürünü ekleyin ve başka bir Snackbar gösterin
                                setState(() {
                                  SepetModel sepetModel = new SepetModel();
                                  sepetModel.urun = widget.urunModel;
                                  sepetModel.adet = urunAdet;
                                  sepetModel.beden =
                                      widget.urunModel.secilenBedenler;
                                  sepetModel.renk =
                                      widget.urunModel.secilenRenkler;
                                  SepetimView.sepetUrunler.add(sepetModel);
                                  print(SepetimView.sepetUrunler);
                                });

                                const snackBar = SnackBar(
                                  content: Text(
                                    "Ürün sepete eklendi!",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  duration: Duration(seconds: 3),
                                  backgroundColor:
                                      Colors.green, // Snackbar arka plan rengi
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }

                              Navigator.pop(context);
                            },
                            child: ContainerButtonModel(
                              containerWidth: MediaQuery.of(context).size.width,
                              iText: "Sepete Ekle",
                              bgColor: Colors.amber,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
      },
      child: ContainerButtonModel(
        containerWidth: MediaQuery.of(context).size.width / 1.5,
        iText: "Sepete Ekle",
        bgColor: Colors.amber,
      ),
    );
  }
}
