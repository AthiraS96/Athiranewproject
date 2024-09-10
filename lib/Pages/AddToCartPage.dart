import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:culinary_snap/Pages/DetailPage.dart';
import 'package:culinary_snap/Pages/EachDishDetailPage.dart';
import 'package:culinary_snap/colors/Colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  List<int> quantities = []; // List to store quantities for each item
  int itemTotal = 0;
  int totalAmount = 0;

  Future<void> findTotalPrice() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> cartCollection =
        await firestore.collection('Cart');
    if (totalAmount == 0) {
      // Get the snapshot of the entire collection
      QuerySnapshot<Map<String, dynamic>> snapshot = await cartCollection.get();

      // Initialize total price to 0

      // Iterate over each document in the collection
      for (var document in snapshot.docs) {
        Map<String, dynamic> data =
            document.data(); // Data of the current document

        // Extract the price and quantity values
        int price = data['price'] ?? 0; // Assuming 'price' is a double
        int quantity = data['quantity'] ?? 0; // Assuming 'quantity' is an int

        // Calculate the total for the current item and add it to the overall total price
        totalAmount += price * quantity;

        print('Total Price: $totalAmount');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: findTotalPrice(),
        builder: (context, snapshot) {
          if (user == null) {
            return Center(child: Text('Please log in to view cart.'));
          }

          Future<void> updateFoodQuantity(foodId, value) async {
            FirebaseFirestore firestore = FirebaseFirestore.instance;
            print('&&&&&&&&&&& GET FOOD QUANTITY ' + foodId.toString());

            DocumentSnapshot documentSnapshot =
                await firestore.collection('Cart').doc(foodId).get();

            // Check if the document exists
            if (documentSnapshot.exists) {
              var data = documentSnapshot.data() as Map<String, dynamic>;
              int quantity = data['quantity'];
              int foodQuantity = (quantity + value) as int;

              // Use the price and rating as needed
              print('Food Quantity: $foodQuantity');
              if (foodQuantity < 1) {
                setState(() {
                  FirebaseFirestore.instance
                      .collection('Cart')
                      .doc(foodId)
                      .delete();
                });
              } else {
                await FirebaseFirestore.instance
                    .collection('Cart')
                    .doc(foodId)
                    .update({
                  // Assuming you only want to update these two fields
                  'quantity': foodQuantity,
                });
              }
            }
          }

          void showAlertDialog(
              BuildContext context, String title, String message) {
            // set up the buttons
            Widget continueButton = ElevatedButton(
              child: const Text("Continue"),
              onPressed: () {},
            );
            // set up the AlertDialog
            AlertDialog alert = AlertDialog(
              title: Text(title),
              content: Text(message),
            );
            // show the dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          }

          void handlePaymentErrorResponse(PaymentFailureResponse response) {
            /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
            showAlertDialog(context, "Payment Failed",
                "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
          }

          Future<void> handlePaymentSuccessResponse(
              PaymentSuccessResponse response) async {
            /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
            print(response.data.toString());
            showAlertDialog(context, "Payment Successful",
                "Payment ID: ${response.paymentId}");
            CollectionReference cartCollection =
                FirebaseFirestore.instance.collection('Cart');
            QuerySnapshot cartSnapshot = await cartCollection.get();
            cartSnapshot.docs.forEach((doc) {
              doc.reference.delete();
            });
            totalAmount = 0;
          }

          void handleExternalWalletSelected(ExternalWalletResponse response) {
            showAlertDialog(
                context, "External Wallet Selected", "${response.walletName}");
          }

          return Scaffold(
            backgroundColor: Backgroundcolor,
            appBar: AppBar(
              title: Text(
                'Cart',
                style: GoogleFonts.acme(
                  textStyle: TextStyle(fontSize: 30, color: logocolour),
                ),
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Cart').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final data = snapshot.requireData;
                // Initialize quantities list if it's empty
                // if (quantities.isEmpty) {
                //   quantities = List<int>.filled(data.size, 1);
                // }
                // findTotalPrice();
                // setState(() {
                //   findTotalPrice();
                // });
                // Calculate total amount
                itemTotal = 0;
                int itemQuantity = 0;
                // for (int i = 0; i < data.size; i++) {
                //   totalAmount += (data.docs[i]['price'] * quantities[i] as int);
                // }

                // if (totalAmount == 0) {
                //   findTotalPrice();
                // }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.size,
                        itemBuilder: (context, index) {
                          // Calculate item total

                          itemQuantity = data.docs[index]['quantity'];
                          itemTotal = data.docs[index]['price'] * itemQuantity;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              data.docs[index]['image']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      data.docs[index]['name'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '₹ ${data.docs[index]['price']}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        int itemTotalPrice = (data.docs[index]
                                                    ['price'] *
                                                data.docs[index]['quantity'])
                                            as int;
                                        setState(() {
                                          FirebaseFirestore.instance
                                              .collection('Cart')
                                              .doc(data.docs[index]['id'])
                                              .delete();

                                          totalAmount =
                                              totalAmount - itemTotalPrice;
                                        });
                                      },
                                      icon: Icon(Icons.close),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  updateFoodQuantity(
                                                      data.docs[index]['id'],
                                                      -1);
                                                  itemTotal = (itemTotal -
                                                      data.docs[index]
                                                          ['price'] as int);
                                                  totalAmount = (totalAmount -
                                                      data.docs[index]
                                                          ['price'] as int);
                                                  itemQuantity--;
                                                });
                                              },
                                              icon: Icon(Icons.remove),
                                            ),
                                            Text(
                                              itemQuantity.toString(),
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  updateFoodQuantity(
                                                      data.docs[index]['id'],
                                                      1);
                                                  itemTotal = (itemTotal +
                                                      data.docs[index]
                                                          ['price']) as int;
                                                  totalAmount = (totalAmount +
                                                      data.docs[index]
                                                          ['price'] as int);
                                                  itemQuantity++;
                                                });
                                              },
                                              icon: Icon(Icons.add),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Total: ₹ $itemTotal',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      color: Colors.grey[200],
                      padding: EdgeInsets.all(16),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount:  ',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 86, 10, 3)),
                          ),
                          Text(
                            '₹$totalAmount',
                            style: TextStyle(fontSize: 18),
                          ),
                          Spacer(),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                            onPressed: () {
                              Razorpay razorpay = Razorpay();
                              var options = {
                                'key': 'rzp_test_1DP5mmOlF5G5ag',
                                'amount': (totalAmount * 100).round(),
                                'name': 'Acme Corp.',
                                'description': 'Fine T-Shirt',
                                'retry': {'enabled': true, 'max_count': 1},
                                'send_sms_hash': true,
                                'prefill': {
                                  'contact': '8888888888',
                                  'email': 'test@razorpay.com'
                                },
                                'external': {
                                  'wallets': ['paytm']
                                }
                              };
                              razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                                  handlePaymentErrorResponse);
                              razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                  handlePaymentSuccessResponse);
                              razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                                  handleExternalWalletSelected);
                              razorpay
                                  .open(options); // Navigate to payments screen
                            },
                            child: const Text(
                              'Go to Payments',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }
}
