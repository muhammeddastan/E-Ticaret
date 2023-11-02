import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:e_commerce/Views/AnaSayfa.dart';
import 'package:e_commerce/Views/Favoriler.dart';
import 'package:e_commerce/Views/Profil.dart';
import 'package:e_commerce/Views/SepetOdeme.dart';
import 'package:e_commerce/Views/Sepetim.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int sayfaIndex = 0;

  List<Widget> sayfalar = [
    AnaSayfaView(),
    SepetimView(),
    FavorilerView(),
    ProfilView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: sayfaIndex,
        children: sayfalar,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        notchMargin: 5,
        icons: const [
          CupertinoIcons.home,
          CupertinoIcons.cart,
          CupertinoIcons.heart,
          CupertinoIcons.profile_circled
        ],
        inactiveColor: Colors.black.withOpacity(0.5),
        activeColor: Colors.amber,
        gapLocation: GapLocation.none,
        activeIndex: sayfaIndex,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        iconSize: 25,
        rightCornerRadius: 10,
        elevation: 0,
        onTap: (index) {
          sayfalar.removeAt(index);
          if (index == 0) {
            sayfalar.insert(0, AnaSayfaView());
          } else if (index == 1) {
            sayfalar.insert(1, SepetimView());
          } else if (index == 2) {
            sayfalar.insert(2, FavorilerView());
          } else if (index == 3) {
            sayfalar.insert(3, ProfilView());
          }

          setState(() {
            sayfaIndex = index;
          });
        },
      ),
    );
  }
}
