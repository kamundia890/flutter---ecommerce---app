import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comma/screens/product_page.dart';
import 'package:comma/services/firebase_services.dart';
import 'package:comma/widgets/custom_input.dart';
import 'package:comma/widgets/product_cart.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          if(_searchString.isEmpty)
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 100),
                child: Text('Search Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black))
                ),
            )
          else
            FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.productsRef
                .orderBy('name')
                .startAt([_searchString])
                .endAt(['$_searchString\uf8ff']).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }

              //collection Data ready to display
              if (snapshot.connectionState == ConnectionState.done) {
                //Display the data inside a list view
                return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 120, bottom: 12),
                    children: snapshot.data.docs.map((document) {
                      return ProductCard(
                        title: document.data()['name'],
                        imageUrl: document.data()['images'][0],
                        price: "\$${document.data()['price']}",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                        productId: document.id,
                                      )));
                        },
                      );
                    }).toList());
              }

              //loading state
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: Custominput(
              hintText: "Search here...",
              onSubmitted: (value) {
                
                  setState(() {
                    _searchString = value;
                  });
                
              },
            ),
          ),
        ],
      ),
    );
  }
}
