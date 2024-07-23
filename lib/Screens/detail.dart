import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/Screens/payment_method.dart';
import 'package:foodapp/Screens/soupcompny.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../bottombar.dart';
import '../mainscr.dart';
import '../stripe_home.dart';
class Detail extends StatefulWidget {
  final String image;
  final String price;
  final String title;
  String description;
  final int totalunit;
  Detail({super.key, required this.image, required this.price, required this.title, required this.totalunit, required this.description});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  int unit = 1;
  late double totalPrice;

  @override
  void initState() {
    super.initState();
    totalPrice = double.parse(widget.price); // Initializing totalPrice
  }

  void incrementUnit() {
    setState(() {
      if(widget.totalunit> unit){
        unit++;
        totalPrice = double.parse(widget.price) * unit;
      }
      else {
        Get.snackbar(
          'Error',
          'Cannot add more than available units',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.error, color: Colors.white),
        );
      }
    });
  }

  void decrementUnit() {
    if (unit > 1) {
      setState(() {
        unit--;
        totalPrice = double.parse(widget.price) * unit;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Bliss', style: TextStyle(fontSize: 22.px, fontWeight: FontWeight.bold)),
        toolbarHeight: 50.px,
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () =>  Navigator.pop(context),
            child: Icon(Icons.arrow_back),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
              ),
              child: Text('Order Bliss'),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
              ),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BottomBar(),));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.train,
              ),
              title: const Text('Store'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BottomBar(),));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.px),
        child: Column(
          children: [
            SizedBox(height: 20.px),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Image.network(
                widget.image,
                width: double.infinity,
                height: 350.px,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20.px),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 200.px,
                  height: 53.px,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.title}', style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 20.px, fontWeight: FontWeight.bold, color: Colors.black)),
                      Text('Price: ${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.w400, color: Colors.black87)),
                    ],
                  ),
                ),
                Container(
                  width: 100.px,
                  height: 30.px,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.px),
                    color: Colors.orangeAccent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: decrementUnit,
                        child: Icon(Icons.remove, color: Colors.white),
                      ),
                      Text('$unit', style: TextStyle(fontSize: 14.px, color: Colors.white)),
                      InkWell(
                        onTap: incrementUnit,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.px),
            Container(
              width: 332.px,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${widget.description}',
                      style: TextStyle(fontSize: 14.px, fontWeight: FontWeight.w400, color: Colors.black),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.px),
            Container(
              width: 327.px,
              height: 56.px,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.orangeAccent,
                  width: 1.px,
                ),
                borderRadius: BorderRadius.circular(5.px),
              ),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () async {
                      // await addToCart();
                      print("Added to Cart $totalPrice");

                      // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(totalPrice: totalPrice, product: widget.title, unit: unit),));
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StripeHomePage(image: widget.image,title: widget.title,price: widget.price,totalunit: widget.totalunit,totalPrice: totalPrice,unit: unit,),));
                    },
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 20.px, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                    ),
                    style: TextButton.styleFrom(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
