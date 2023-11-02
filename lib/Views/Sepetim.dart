import 'package:e_commerce/Model/SepetModel.dart';
import 'package:e_commerce/Views/SepetOdeme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Favoriler.dart';

class SepetimView extends StatefulWidget {
  static List<SepetModel> sepetUrunler = [];

  @override
  State<SepetimView> createState() => _SepetimViewState();
}

class _SepetimViewState extends State<SepetimView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.black.withOpacity(0.001),
        foregroundColor: Colors.amber,
        elevation: 0,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SepetOdemeView(),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Colors.black.withOpacity(0.001)),
              foregroundColor: const MaterialStatePropertyAll(Colors.amber),
              elevation: const MaterialStatePropertyAll(0),
            ),
            child: const Row(
              children: [
                Text(
                  "Sipariş",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.send,
                  size: 30,
                  color: Colors.amber,
                ),
              ],
            ),
          ),
        ],
        title: const Text(
          "Sepetim",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Visibility(
            visible: SepetimView.sepetUrunler.isEmpty,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 250),
                child: Column(
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 80,
                      color: Colors.amber,
                    ),
                    Text(
                      "Sepetiniz Boş",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Satın Almak İstediğiniz Ürünleri, Sepete Ekle Butonuna Basarak Sepete Ekleyebilirsiniz.",
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
            visible: SepetimView.sepetUrunler.isNotEmpty,
            child: ListView.builder(
              itemCount: SepetimView.sepetUrunler.length,
              itemBuilder: (context, index) {
                final urun = SepetimView.sepetUrunler[index];
                return Container(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                      height: 280,
                      width: 380,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: 100,
                            height: 180,
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
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 40,
                              ),
                              Text("Ürün: ${urun.urun!.urunAdi!}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300)),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Renk: ${urun.renk}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text("Adet:  ${urun.adet.toString()}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300)),
                              const SizedBox(height: 10),
                              Text("Beden:  ${urun.beden}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300)),
                              const SizedBox(height: 10),
                              Text(
                                  "Fiyat: ${urun.urun!.urunFiyati!.toStringAsFixed(2)} ₺",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300)),
                              const SizedBox(height: 20),
                              Text(
                                "Toplam Fiyat: ${urun.urun!.urunFiyati! * urun.adet!}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (urun.adet! < 10) {
                                          urun.adet++;
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (urun.adet! > 1) {
                                          urun.adet--;
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  const SizedBox(width: 0),
                                  IconButton(
                                    onPressed: () {
                                      // Ürünü sepetten çıkarma işlemini burada gerçekleştir
                                      setState(() {
                                        SepetimView.sepetUrunler
                                            .removeAt(index);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
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
