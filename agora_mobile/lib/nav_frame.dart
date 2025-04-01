import 'package:flutter/material.dart';

class NavFrame extends StatefulWidget {
  const NavFrame({super.key});

  @override
  State<NavFrame> createState() => _NavState();
}

class _NavState extends State<NavFrame> {
  int _selectedIndex = 2; //Start on home page

  void _onMenuPressed() {
    //Add stuff that happens when the menu button is pressed
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: _onMenuPressed, icon: Icon(Icons.menu, color: Colors.black)),
        title: Image.asset('assets/Agora_Logo.png', width: 50, height: 50),
        
      ),
      body: Center(child: Text("Hello from $_selectedIndex")),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Politicians"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Legislation"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        showUnselectedLabels: false,
        selectedItemColor: const Color.fromARGB(255, 0, 60, 163),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
  
}