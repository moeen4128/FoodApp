import 'package:flutter/material.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:five_pointed_star/five_pointed_star.dart';

import '../bottombar.dart';
import 'detail.dart';

class Karahi extends StatefulWidget {
  String? imageUrl;
  Map<String, dynamic>? item1, item2, item3, item4, item5, item6;

  Karahi(
      {super.key,
        this.imageUrl,
        this.item1,
        this.item2,
        this.item3,
        this.item4,
        this.item5,
        this.item6});

  @override
  State<Karahi> createState() => _KarahiState();
}

class _KarahiState extends State<Karahi> {
  int mycount = 0;

  @override
  Widget build(BuildContext context) {
    print('${widget.item1} item1 data');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Bliss',
          style: TextStyle(fontSize: 22.px, fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 50.px,
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () => Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => BottomBar(),)),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomBar(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.train,
              ),
              title: const Text('Store'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomBar(),
                    ));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.px),
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 18.px,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              width: 339.px,
              height: 145.px,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Image.network(
                    "${widget.imageUrl}",
                    fit: BoxFit.fill,
                  )),
            ),
            SizedBox(
              height: 10.px,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Karahi',
                  style: TextStyle(
                      fontSize: 22.px,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                FivePointedStar(
                  onChange: (count) {
                    setState(() {
                      mycount = count;
                    });
                  },
                ),
                Text(
                  mycount.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 10.px,
            ),
            Row(
              children: [
                Text(
                  'Choose Your Karahi',
                  style: TextStyle(
                      fontSize: 18.px,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 10.px),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildKarahiCard(
                    context, '${widget.item1?['image']}', '${widget.item1?['title']}', '${widget.item1?['price']}', '${widget.item1?['description']}',10),
                buildKarahiCard(
                    context, '${widget.item2?['image']}', '${widget.item2?['title']}', '${widget.item2?['price']}', '${widget.item2?['description']}',10),
              ],
            ),
            SizedBox(height: 10.px),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildKarahiCard(
                    context, '${widget.item3?['image']}', '${widget.item3?['title']}', '${widget.item3?['price']}', '${widget.item3?['description']}',10),
                buildKarahiCard(
                    context, '${widget.item4?['image']}', '${widget.item4?['title']}', '${widget.item4?['price']}', '${widget.item4?['description']}',10),
              ],
            ),
            SizedBox(height: 10.px),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildKarahiCard(
                    context, '${widget.item5?['image']}', '${widget.item5?['title']}', '${widget.item5?['price']}', '${widget.item5?['description']}',10),
                buildKarahiCard(
                    context, '${widget.item6?['image']}', '${widget.item6?['title']}', '${widget.item6?['price']}', '${widget.item6?['description']}',10),
              ],
            ),
            SizedBox(height: 20.px),
          ]),
        ),
      ),
    );
  }

  Widget buildKarahiCard(
      BuildContext context, String imagePath, String title, String price,String description,int totalunit) {
    return Container(
      width: 150.px,
      height: 180.px,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.px),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 99.px,
            height: 99.px,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Detail(
                      image: imagePath,
                      price: price,
                      title: title,
                      description: description,
                      totalunit: totalunit,
                    ),
                  ),
                );
              },
              child: Image.network(imagePath,fit: BoxFit.fill,),
            ),
          ),
          SizedBox(height: 1.px),
          Text(title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14.px,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
          SizedBox(height: 1.px),
          Text(price,
              style: TextStyle(
                  fontSize: 16.px,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.add_box, color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }
}
