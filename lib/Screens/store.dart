import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class StoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Store', style: TextStyle(fontSize: 22.px, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
        ),
        body: Center(
          child: Text('Please log in to see your cart items.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Store', style: TextStyle(fontSize: 22.px, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('cart')
            .where('userId', isEqualTo: user.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No items in the Store'));
          }

          final cartItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              final imageUrl = item['image'];
              final title = item['title'];
              final unit = item['unit'];
              final totalPrice = item['totalPrice'];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10.px, horizontal: 15.px),
                child: Padding(
                  padding: EdgeInsets.all(10.px),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.px),
                        child: Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: 200.px,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10.px),
                      Text(
                        title,
                        style: TextStyle(fontSize: 20.px, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Units: $unit',
                        style: TextStyle(fontSize: 16.px),
                      ),
                      Text(
                        'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16.px),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
