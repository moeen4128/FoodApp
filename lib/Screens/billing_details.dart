import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';  // For date formatting

class BillingDetails extends StatelessWidget {
  const BillingDetails({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Billing', style: TextStyle(fontSize: 22.px, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
        ),
        body: Center(
          child: Text('Please log in to see your .'),
        ),
      );
    }
    Future<List<Map<String, dynamic>>> fetchBillingDetails() async {
      List<Map<String, dynamic>> billingDetails = [];
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('cart').where('userId', isEqualTo: user.uid).get();

      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        billingDetails.add(data);
      });

      return billingDetails;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Billing Details'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBillingDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No billing details available.'));
          } else {
            List<Map<String, dynamic>> billingDetails = snapshot.data!;
            return ListView.builder(
              itemCount: billingDetails.length,
              itemBuilder: (context, index) {
                var detail = billingDetails[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text('Product Name: ',style: TextStyle(
                          fontSize: 16,fontWeight: FontWeight.w500
                        ),),
                        Text('${detail['title']}'),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Total Price: ',style: TextStyle(
                              fontSize: 16,fontWeight: FontWeight.w500
                            ),),
                            Text('\$${detail['totalPrice'].toStringAsFixed(2)}')
                          ],
                        ),
                        
                        Row(
                          children: [
                            Text('Units: ',style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500
                            ),),
                            Text('${detail['unit']}')
                          ],
                        ),
                        Row(
                          children: [
                            Text('Date: ',style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                            ),),
                            Text('${DateFormat('yyyy-MM-dd – kk:mm').format(detail['timestamp'].toDate())}')
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
