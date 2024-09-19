import 'package:flutter/material.dart';
import 'package:savoria_test/modules/soal_dua/view/soal_dua_page.dart';
import 'package:savoria_test/modules/soal_satu/view/soal_satu_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  BottomNavState createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  @override
  void initState() {
    super.initState();
  }

  int selectedPage = 0;

  List<Widget> _pageOptions() {
    return [
      const SoalSatu(),
      const SoalDua(),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: _pageOptions()[selectedPage],
        ),
        bottomNavigationBar: BottomNavigationBar(
          enableFeedback: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard, size: 30), label: 'Soal 1'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart, size: 30), label: 'Soal 2'),
          ],
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.redAccent.withOpacity(0.3),
          currentIndex: selectedPage,
          backgroundColor: Colors.white,
          onTap: (index) {
            setState(() {
              selectedPage = index;
            });
          },
        ),
      ),
    );
  }
}
