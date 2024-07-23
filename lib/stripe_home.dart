import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodapp/constants.dart';
import 'package:foodapp/stripe_payment.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'bottombar.dart';

class StripeHomePage extends StatefulWidget {
  final String image;
  final String title;
  final String price;
  final double totalPrice;
  final int totalunit;
  final int unit;
  const StripeHomePage({Key? key, required this.image, required this.title, required this.price, required this.totalunit, required this.totalPrice, required this.unit}) : super(key: key);

  @override
  State<StripeHomePage> createState() => _StripeHomePageState();
}

class _StripeHomePageState extends State<StripeHomePage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();
  final formKey5 = GlobalKey<FormState>();
  final formKey6 = GlobalKey<FormState>();

  List<String> currencyList = <String>[
    'PKR',
    'USD',
    'INR',
    'EUR',
    'JPY',
    'GBP',
    'AEO'
  ];
  String selectedCurrency = 'PKR';
  bool hasPay = false;
  void initState() {
    super.initState();
    amountController.text = widget.totalPrice.toString();
  }
  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the client side by calling stripe api
      final data = await createPaymentIntent(
          name: nameController.text,
          address: addressController.text,
          pin: pincodeController.text,
          city: cityController.text,
          state: stateController.text,
          country: countryController.text,
          currency: selectedCurrency,
          amount: (widget.totalPrice * 100).toInt().toString(),);

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }
  Future<void> addToCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference cart = FirebaseFirestore.instance.collection('cart');
      await cart.add({
        'userId': user.uid,
        'image': widget.image,
        'title': widget.title,
        'totalPrice': widget.totalPrice,
        'unit': widget.unit,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Total Price in Payment method ${widget.totalPrice}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child:
        Column(
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
            hasPay? Padding(
                padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Thank for your ${amountController.text} $selectedCurrency payment! Your order has been successfully processed",style: TextStyle(
                  fontSize: 16,fontWeight: FontWeight.bold
                ),),
                SizedBox(
                  height: 6,
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.shade400,

                    ),
                    onPressed: ()async {
                      await addToCart();
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomBar(),
                            ));
                        amountController.clear();
                      });
                    },
                    child: Text("Goto Home Screen",style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),),
                  ),
                ),
              ],
            ),):
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.title}', style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 20.px, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: ReusableTextField(
                          readOnly: true,
                            isNumber: true,
                            title: "",
                            hint: "${widget.totalPrice}",
                            controller: amountController,
                            formKey: formKey),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownMenu<String>(
                        inputDecorationTheme: InputDecorationTheme(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 0,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey.shade600))),
                        initialSelection: currencyList.first,
                        onSelected: (String? value) {
                          setState(() {
                            selectedCurrency = value!;
                          });
                        },
                        dropdownMenuEntries:
                        currencyList.map<DropdownMenuEntry<String>>(
                              (String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ReusableTextField(
                      title: 'Name',
                      hint: 'Ex. John Doe',
                      controller: nameController,
                      formKey: formKey1),
                  SizedBox(
                    height: 10,
                  ),
                  ReusableTextField(
                      title: 'Address Line',
                      hint: 'Ex. 123 Main St',
                      controller: addressController,
                      formKey: formKey2),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: ReusableTextField(
                            title: 'City',
                            hint: 'Ex. New Delhi',
                            controller: cityController,
                            formKey: formKey3),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 5,
                        child: ReusableTextField(
                            title: 'State',
                            hint: 'Ex. DL',
                            controller: stateController,
                            formKey: formKey4),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: ReusableTextField(
                            title: 'Country (Short Code)',
                            hint: 'Ex. In for India',
                            controller: countryController,
                            formKey: formKey5),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 5,
                        child: ReusableTextField(
                            isNumber: true,
                            title: 'Pincode',
                            hint: 'Ex. 123456',
                            controller: pincodeController,
                            formKey: formKey6),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.shade400,
                      ),
                      child: Text(
                        "Proceed to pay",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () async {
                        if (
                        formKey.currentState!.validate() &&
                            formKey1.currentState!.validate() &&
                            formKey2.currentState!.validate() &&
                            formKey3.currentState!.validate() &&
                            formKey4.currentState!.validate() &&
                            formKey5.currentState!.validate() &&
                            formKey6.currentState!.validate()
                        ) {
                          await initPaymentSheet();
                          try {
                            await Stripe.instance.presentPaymentSheet();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content:  Text(
                                  "Payment done", style: TextStyle(color: Colors.white),),
                                backgroundColor: Colors.green,));
                            setState(() {
                              hasPay = true;
                            });
                            nameController.clear();
                            addressController.clear();
                            cityController.clear();
                            stateController.clear();
                            countryController.clear();
                            pincodeController.clear();
                          } catch (e) {
                            print("Payment sheet failed");
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content:  Text(
                                  "Payment Failed", style: TextStyle(color: Colors.white),),
                                  backgroundColor: Colors.redAccent,));
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
