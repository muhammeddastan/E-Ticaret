import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:e_commerce/Views/Admin/AdminPanel.dart';
import 'package:e_commerce/Views/Admin/Siparisler.dart';
import 'package:e_commerce/Views/Admin/Urun.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationAdminView extends StatefulWidget {
  const NavigationAdminView({super.key});

  @override
  State<NavigationAdminView> createState() => _NavigationAdminViewState();
}

class _NavigationAdminViewState extends State<NavigationAdminView> {
  int sayfaIndex = 0;
  List<Widget> sayfalar = [
    AdminView(),
    SiparislerAdminView(),
    YeniUrunAdminView(),
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
        notchMargin: 15,
        icons: const [
          CupertinoIcons.person,
          CupertinoIcons.creditcard,
          CupertinoIcons.bag_fill_badge_plus
        ],
        gapLocation: GapLocation.none,
        inactiveColor: Colors.black.withOpacity(0.5),
        activeColor: Colors.amber,
        activeIndex: sayfaIndex,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        iconSize: 25,
        elevation: 0,
        onTap: (index) {
          sayfalar.removeAt(index);
          if (index == 0) {
            sayfalar.insert(0, AdminView());
          } else if (index == 1) {
            sayfalar.insert(1, SiparislerAdminView());
          } else if (index == 2) {
            sayfalar.insert(2, YeniUrunAdminView());
          }

          setState(() {
            sayfaIndex = index;
          });
        },
      ),
    );
  }
}
