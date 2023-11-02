import 'package:flutter/material.dart';

class SiparislerimView extends StatefulWidget {
  const SiparislerimView({super.key});

  @override
  State<SiparislerimView> createState() => _SiparislerimViewState();
}

class _SiparislerimViewState extends State<SiparislerimView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.amber,
        elevation: 0,
        title: Text("Siparişlerim"),
      ),
    );
  }
}
