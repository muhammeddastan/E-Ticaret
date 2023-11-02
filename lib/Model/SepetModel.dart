import 'dart:ui';

import 'package:e_commerce/Model/UrunlerModel.dart';

class SepetModel {
  UrunModel? urun;
  String? beden;
  String? renk;
  int adet = 1;

  SepetModel({
    this.urun,
    this.beden,
    this.renk,
    this.adet = 1,
  });
}
