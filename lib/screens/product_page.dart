import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comma/services/firebase_services.dart';
import 'package:comma/widgets/custom_action_bar.dart';
import 'package:comma/widgets/images_swipe.dart';
import 'package:comma/widgets/product_size.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  


  String _selectedProductSize = "0";

  Future _addToCart() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection('Cart')
        .doc(widget.productId)
        .set({"size": _selectedProductSize});
  }

  final SnackBar _snackBar = SnackBar(
    content: Text('Product added to the cart'),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        FutureBuilder(
          future: _firebaseServices.productsRef.doc(widget.productId).get(),
          builder: (context, snapshot) {
            //error
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            }

            //showing thw data
            if (snapshot.connectionState == ConnectionState.done) {
              //mapping everything
              Map<String, dynamic> documentData = snapshot.data.data();

              // map of images alone
              List imageList = documentData['images'];
              List productSizes = documentData['size'];

              //set an initial size
              _selectedProductSize = productSizes[6];

              return ListView(
                padding: EdgeInsets.all(0),
                children: <Widget>[
                  ImageSwipe(
                    imageList: imageList,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 4.0, right: 24.0, left: 24.0, top: 24),
                    child: Text('${documentData['name']}' ?? 'Product Name',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 24.0),
                    child: Text(
                      '\$${documentData['price']}' ?? 'Price',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24.0),
                    child: Text(
                      '${documentData['desc']}' ?? 'Description',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24.0, horizontal: 24.0),
                    child: Text("Select Size",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                  ),
                  ProductSize(
                    productSizes: productSizes,
                    onSelected: (size) {
                      _selectedProductSize = size;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                              color: Color(0xFFDCDCDC),
                              borderRadius: BorderRadius.circular(12)),
                          alignment: Alignment.center,
                          child: Image(
                            image: AssetImage('assets/images/tab_saved.png'),
                            width: 13,
                            height: 21,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await _addToCart();
                              Scaffold.of(context).showSnackBar(_snackBar);
                            },
                            child: Container(
                              height: 65.0,
                              width: double.infinity,
                              margin: EdgeInsets.only(left: 16),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12)),
                              alignment: Alignment.center,
                              child: Text(
                                'Add To Cart',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }

            //loading
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        CustomActionBar(
          hasBackArrow: true,
          hasTitle: false,
          hasBackground: false,
        )
      ],
    ));
  }
}
