import 'package:flutter/material.dart';

class KrediKartModel {
  String? adSoyad;
  int? kartnNo;
  int? kartTarih;
  int? cvv;

  KrediKartModel({
    required this.adSoyad,
    this.kartnNo,
    this.kartTarih,
    this.cvv,
  });
}
