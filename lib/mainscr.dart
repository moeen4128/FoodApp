import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodapp/pizzacompny.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'Screens/broastcompany.dart';
import 'Screens/burgercompany.dart';
import 'Screens/chickenscompany.dart';
import 'Screens/karahicompany.dart';
import 'Screens/samosacompany.dart';
import 'Screens/soupcompny.dart';
import 'bottombar.dart';

class MainScr extends StatefulWidget {
  const MainScr({Key? key}) : super(key: key);

  @override
  State<MainScr> createState() => _MainScrState();
}

class _MainScrState extends State<MainScr> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchCuisinesData() async {
    QuerySnapshot cuisinesSnapshot = await _firestore.collection('cuisines').get();
    List<Map<String, dynamic>> cuisines = [];

    for (var doc in cuisinesSnapshot.docs) {
      if (doc.exists) {
        String id = doc.id;
        String title = doc['title'] as String;
        String image = doc['image'] as String;
        String subTitle = doc['subTitle'] as String;

        // Fetch items for each cuisine
        QuerySnapshot itemsSnapshot = await doc.reference.collection('items').get();
        List<Map<String, dynamic>> items = [];

        for (var itemDoc in itemsSnapshot.docs) {
          if (itemDoc.exists) {
            items.add(itemDoc.data() as Map<String, dynamic>);
          }
        }

        cuisines.add({
          'id': id,
          'title': title,
          'image': image,
          'subTitle': subTitle,
          'items': items,
        });
      }
    }

    return cuisines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Bliss',
          style: TextStyle(fontSize: 22.px, fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 50.px,
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
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
        child: Column(
          children: [
            Text(
              'Choose Your Food Today',
              style: TextStyle(
                  fontSize: 22.px,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            SizedBox(
              height: 15.px,
            ),
            FutureBuilder(
              future: fetchCuisinesData(),
              builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Map<String, dynamic>> cuisines = snapshot.data ?? [];
                  return Container(
                    height: 50.px,  // Set the height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cuisines.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> cuisine = cuisines[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigation based on cuisine ID
                            switch (cuisine['id']) {
                              case 'soups':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => YummySoup(),
                                  ),
                                );
                                break;
                              case 'burger':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Burger(),
                                  ),
                                );
                                break;
                              case 'chickens':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Chicken(),
                                  ),
                                );
                                break;
                              case 'pizza':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => YummyPizza(),
                                  ),
                                );
                                break;
                              case 'karahi':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Karahi(),
                                  ),
                                );
                                break;
                              case 'samosa':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Samosa(),
                                  ),
                                );
                                break;
                              case 'broast':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Broast(imageUrl: cuisine['image']),
                                  ),
                                );
                                break;
                              default:
                              // Handle unknown cuisine
                                break;
                            }
                          },
                          child: Container(
                            width: 95.px,  // Set the width as needed
                            margin: EdgeInsets.symmetric(horizontal: 8.0),  // Adjust margin for spacing between items
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.px),
                              color: Colors.orangeAccent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 22.px),
                                InkWell(
                                  onTap: () {
                                    // Navigation based on cuisine ID
                                    switch (cuisine['title']) {
                                      case 'Soups':
                                        var Item1 = snapshot.data![4]['items'][0];
                                        var Item2 = snapshot.data![4]['items'][1];
                                        var Item3 = snapshot.data![4]['items'][2];
                                        var Item4 = snapshot.data![4]['items'][3];
                                        var Item5 = snapshot.data![4]['items'][4];
                                        var Item6 = snapshot.data![4]['items'][5];
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    YummySoup(imageUrl: cuisine['image'],item1: Item1,item2: Item2,item3: Item3,item4: Item4,item5: Item5,item6: Item6,)));
                                        break;
                                      case 'Burger':
                                        var Item1 = snapshot.data![3]['items'][0];
                                        var Item2 = snapshot.data![3]['items'][1];
                                        var Item3 = snapshot.data![3]['items'][2];
                                        var Item4 = snapshot.data![3]['items'][3];
                                        var Item5 = snapshot.data![3]['items'][4];
                                        var Item6 = snapshot.data![3]['items'][5];
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Burger(imageUrl: cuisine['image'],item1: Item1,item2: Item2,item3: Item3,item4: Item4,item5: Item5,item6: Item6,)));
                                        break;
                                      case 'Chickens':
                                        var Item1 = snapshot.data![5]['items'][0];
                                        var Item2 = snapshot.data![5]['items'][1];
                                        var Item3 = snapshot.data![5]['items'][2];
                                        var Item4 = snapshot.data![5]['items'][3];
                                        var Item5 = snapshot.data![5]['items'][4];
                                        var Item6 = snapshot.data![5]['items'][5];
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Chicken(imageUrl: cuisine['image'],item1: Item1,item2: Item2,item3: Item3,item4: Item4,item5: Item5,item6: Item6,)));
                                        break;
                                      case 'Pizza':
                                        var Item1 = snapshot.data![1]['items'][0];
                                        var Item2 = snapshot.data![1]['items'][1];
                                        var Item3 = snapshot.data![1]['items'][2];
                                        var Item4 = snapshot.data![1]['items'][3];
                                        var Item5 = snapshot.data![1]['items'][4];
                                        var Item6 = snapshot.data![1]['items'][5];
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    YummyPizza(imageUrl: cuisine['image'],item1: Item1,item2: Item2,item3: Item3,item4: Item4,item5: Item5,item6: Item6,)));
                                        break;
                                      case 'Karahi':
                                        var Item1 = snapshot.data![2]['items'][0];
                                        var Item2 = snapshot.data![2]['items'][1];
                                        var Item3 = snapshot.data![2]['items'][2];
                                        var Item4 = snapshot.data![2]['items'][3];
                                        var Item5 = snapshot.data![2]['items'][4];
                                        var Item6 = snapshot.data![2]['items'][5];
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Karahi(imageUrl: cuisine['image'],item1: Item1,item2: Item2,item3: Item3,item4: Item4,item5: Item5,item6: Item6,)));
                                        break;
                                      case 'Samosa':
                                        var Item1 = snapshot.data![6]['items'][0];
                                        var Item2 = snapshot.data![6]['items'][1];
                                        var Item3 = snapshot.data![6]['items'][2];
                                        var Item4 = snapshot.data![6]['items'][3];
                                        var Item5 = snapshot.data![6]['items'][4];
                                        var Item6 = snapshot.data![6]['items'][5];
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Samosa(imageUrl: cuisine['image'],item1: Item1,item2: Item2,item3: Item3,item4: Item4,item5: Item5,item6: Item6,)));
                                        break;
                                      case 'Broast':
                                        var Item1 = snapshot.data![0]['items'][0];
                                        var Item2 = snapshot.data![0]['items'][1];
                                        var Item3 = snapshot.data![0]['items'][2];
                                        var Item4 = snapshot.data![0]['items'][3];
                                        var Item5 = snapshot.data![0]['items'][4];
                                        var Item6 = snapshot.data![0]['items'][5];
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Broast(imageUrl: cuisine['image'],item1: Item1,item2: Item2,item3: Item3,item4: Item4,item5: Item5,item6: Item6,)));
                                        break;
                                      default:
                                      // Handle unknown cuisine
                                        break;
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      cuisine['title']
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            SizedBox(
              height: 15.px,
            ),
            Stack(
              children: [
                Container(
                  width: 340.px,
                  height: 141.px,
                  child: Image.asset(
                    'assets/main1.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Sales of Today',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0),
                    )),
              ],
            ),
            SizedBox(
              height: 10.px,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cuisines for you',
                  style: TextStyle(
                      fontSize: 22.px,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  'View all',
                  style: TextStyle(
                      fontSize: 14.px,
                      fontWeight: FontWeight.w400,
                      color: Colors.orangeAccent),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                future: fetchCuisinesData(),
                builder:
                    (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Map<String, dynamic>> cuisines = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: cuisines.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> cuisine = cuisines[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigation based on cuisine ID
                            switch (cuisine['id']) {
                              case 'soups':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => YummySoup()));
                                break;
                              case 'burger':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Burger()));
                                break;
                              case 'chickens':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Chicken()));
                                break;
                              case 'pizza':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => YummyPizza()));
                                break;
                              case 'karahi':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Karahi()));
                                break;
                              case 'samosa':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Samosa()));
                                break;
                              case 'broast':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Broast(imageUrl: cuisine['image'],)));
                                break;
                              default:
                              // Handle unknown cuisine
                                break;
                            }
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 340.px,
                                height: 80.px,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.px),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.only(topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20)),
                                      child: Image.network(
                                        cuisine['image'],
                                        width: 112.px,
                                        height: 80.px.px,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blueGrey,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomRight: Radius.circular(20))),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 168.px,
                                            height: 80.px,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 10.px),
                                                Text(
                                                  cuisine['title'],
                                                  style: TextStyle(
                                                    fontSize: 22.px,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  cuisine['subTitle'],
                                                  style: TextStyle(
                                                    fontSize: 14.px,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: 60.px,
                                            height: 80.px,
                                            child:
                                            Column(
                                              children: [
                                                SizedBox(height: 22.px),
                                                IconButton(
                                                  onPressed: () {
                                                    // Navigation based on cuisine ID
                                                    switch (cuisine['title']) {
                                                      case 'Soups':
                                                        var Item1 = snapshot.data![4]['items'][0];
                                                        var Item2 = snapshot.data![4]['items'][1];
                                                        var Item3 = snapshot.data![4]['items'][2];
                                                        var Item4 = snapshot.data![4]['items'][3];
                                                        var Item5 = snapshot.data![4]['items'][4];
                                                        var Item6 = snapshot.data![4]['items'][5];
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    YummySoup(imageUrl: cuisine['image'],item1: Item1,item2: Item2,item3: Item3,item4: Item4,item5: Item5,item6: Item6,)));
                                                        break;
                                                      case 'Burger':
                                                        var Item1 = snapshot.data![3]['items'][0];
                                                        var Item2 = snapshot.data![3]['items'][1];
                                                        var Item3 = snapshot.data![3]['items'][2];
                                                        var Item4 = snapshot.data![3]['items'][3];
                                                        var Item5 = snapshot.data![3]['items'][4];
                                                        var Item6 = snapshot.data![3]['items'][5];
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    Burger(imageUrl: cuisine['image'],item1: Item1,item2: Item2,item3: Item3,item4: Item4,item5: Item5,item6: Item6,)));
                                                        break;
                                                      case 'Chickens':
                                                        var Item1 = snapshot.data![5]['items'][0];
                                                        var Item2 = snapshot.data![5]['items'][1];
                                                        var Item3 = snapshot.data![5]['items'][2];
                                                        var Item4 = snapshot.data![5]['items'][3];
                                                        var Item5 = snapshot.data![5]['items'][4];
                                                        var Item6 = snapshot.data![5]['items'][5];
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    Chicken(imageUrl: cuisine['image'],item1: Item1,item2: Item2,item3: Item3,item4: Item4,item5: Item5,item6: Item6,)));
                                                        break;
                                                      case 'Pizza':
                                                        var Item1 = snapshot.data![1]['items'][0];
                                                        var Item2 = snapshot.data![1]['items'][1];
                                                        var Item3 = snapshot.data![1]['items'][2];
                                                        var Item4 = snapshot.data![1]['items'][3];
                                                        var Item5 = snapshot.data![1]['items'][4];
                                                        var Item6 = snapshot.data![1]['items'][5];
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    YummyPizza(imageUrl: cuisine['image'],item1: Item1,item2: Item2,item3: Item3,item4: Item4,item5: Item5,item6: Item6,)));
                                                        break;
                                                      case 'Karahi':
                                                        var Item1 = snapshot.data![2]['items'][0];
                                                        var Item2 = snapshot.data![2]['items'][1];
                                                        var Item3 = snapshot.data![2]['items'][2];
                                                        var Item4 = snapshot.data![2]['items'][3];
                                                        var Item5 = snapshot.data![2]['items'][4];
                                                        var Item6 = snapshot.data![2]['items'][5];
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    Karahi(imageUrl: cuisine['image'],item1: Item1,item2: Item2,item3: Item3,item4: Item4,item5: Item5,item6: Item6,)));
                                                        break;
                                                      case 'Samosa':
                                                        var Item1 = snapshot.data![6]['items'][0];
                                                        var Item2 = snapshot.data![6]['items'][1];
                                                        var Item3 = snapshot.data![6]['items'][2];
                                                        var Item4 = snapshot.data![6]['items'][3];
                                                        var Item5 = snapshot.data![6]['items'][4];
                                                        var Item6 = snapshot.data![6]['items'][5];
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    Samosa(imageUrl: cuisine['image'],item1: Item1,item2: Item2,item3: Item3,item4: Item4,item5: Item5,item6: Item6,)));
                                                        break;
                                                      case 'Broast':
                                                        var Item1 = snapshot.data![0]['items'][0];
                                                        var Item2 = snapshot.data![0]['items'][1];
                                                        var Item3 = snapshot.data![0]['items'][2];
                                                        var Item4 = snapshot.data![0]['items'][3];
                                                        var Item5 = snapshot.data![0]['items'][4];
                                                        var Item6 = snapshot.data![0]['items'][5];
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    Broast(imageUrl: cuisine['image'],item1: Item1,item2: Item2,item3: Item3,item4: Item4,item5: Item5,item6: Item6,)));
                                                        break;
                                                      default:
                                                      // Handle unknown cuisine
                                                        break;
                                                    }
                                                  },
                                                  icon:
                                                  Icon(Icons.arrow_forward_ios_rounded),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
