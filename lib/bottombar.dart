import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'Screens/profilescreen.dart';
import 'Screens/store.dart';
import 'mainscr.dart';
class BottomBar extends StatefulWidget {
  const BottomBar({super.key});
  @override
  State<BottomBar> createState() => _BottomBarState();
}
class _BottomBarState extends State<BottomBar> {
  int myindex=0;
  final List<Widget> screens=[
    MainScr(),
    StoreScreen(),
    ProfileScreen(),
   // PizzaDetail(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.symmetric(horizontal: 1.px),
        child: screens[myindex],),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            myindex=index;
          });
        },
        currentIndex: myindex,
        iconSize: 30,
        selectedFontSize: 19,
        unselectedFontSize: 15,
        backgroundColor: Colors.orangeAccent,
        unselectedItemColor:Colors.white,
        selectedItemColor: Colors.white,
        items: const   [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home,color: Colors.white,),
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            label: 'Store ',
            icon: Icon(Icons.local_grocery_store_outlined,color: Colors.white,),
            backgroundColor: Colors.blue,

          ),

          BottomNavigationBarItem(
            label: 'Porfile',
            icon: Icon(Icons.person,color: Colors.white,),
            //title:  Text('Home'),
            backgroundColor: Colors.black,
          ),
        ],
      ),

    );
  }
}
