import 'package:flutter/material.dart';
class CustomBar extends StatelessWidget {
 final String barid;
const CustomBar({required this.barid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
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
