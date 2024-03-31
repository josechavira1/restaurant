import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant/models/food_model.dart';
import 'package:restaurant/models/product_model.dart';
import 'package:restaurant/pages/admin/food.dart';
import 'package:restaurant/pages/admin/login.dart';
import 'package:restaurant/pages/general/details.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant/services/firestore.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<FoodModel> foods = [];

  final FirestoreService firestoreService = FirestoreService();


  void _getFoods() {
    foods = FoodModel.getFoods();
  }

  @override
  Widget build(BuildContext context) {
    _getFoods();

    return Scaffold(
      appBar: appBar(context),
      backgroundColor: Color(0xFFf1f1f1),
      body: ListView(
        children: [
          _getProductsStream()
          // _foodSection()
        ],
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);

  AppBar appBar(context) {
    String asset = "";
    if (FirebaseAuth.instance.currentUser == null)
    {
      asset = "assets/icons/right-to-bracket-solid.svg";
    }
    else {
      asset = "assets/icons/gears-solid.svg";
    }
    return AppBar(
      title: const Text('Home'),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold
      ),
      backgroundColor: const Color(0xffcb082e),
      centerTitle: true,
      leading: Container(
        // margin: const EdgeInsets.all(10),
        // alignment: Alignment.center,
        // decoration: BoxDecoration(
        //   color: const Color(0xfff7F8F8),
        //   borderRadius: BorderRadius.circular(10)
        // ),
        // child: SvgPicture.asset(
        //   'assets/icons/chevron-left-solid.svg',
        //   height: 20,
        //   width: 20,
        // ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            if (FirebaseAuth.instance.currentUser == null)
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
            else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FoodPage()),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 37,
            decoration: BoxDecoration(
              color: const Color(0xfff7F8F8),
              borderRadius: BorderRadius.circular(10)
            ),
            child: SvgPicture.asset(
              asset,
              height: 20,
              width: 20,
            ),
          ),
        )

      ],
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> _getProductsStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getProductsStream(),
      builder: (context, snapshot) {
        //if we have data, get all docs
        if (snapshot.hasData) {
          List productsList = snapshot.data!.docs;

          //display as a list
          return _productSection(productsList, context);
        }
        else {
          return const Text("No data available");
        }
      },
    );
  }

  Container _productSection(products, context) {
    return Container(
      child: Column(
        children: [
          _gap(),
          Center(
            child: Text(
              "Our Menu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xffcb082e),
                fontSize: 22,
              ),
            ),
          ),
          _gap(),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Color(0xFFd5ebf0),
              // borderRadius: BorderRadius.circular(10)
            ),
            child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true, // Añade esta línea
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20
            ),
            itemBuilder: (context, index) {
              //get each individual doc
              DocumentSnapshot document = products[index];
              String docID = document.id;

              //get note from each doc
              Map<String, dynamic> data =
                document.data() as Map<String, dynamic>;
              String productName = data['name'];
              String productDesc = data['description'];
              double productPrice = data['price'];

              ProductModel _products = ProductModel(name: productName, price: productPrice, description: productDesc, id: docID);


              return Container (
                decoration: BoxDecoration(
                  color: Color(0xFFf1f1f1),
                  borderRadius: BorderRadius.circular(16)
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailsPage(product: _products)),
                    );
                  },
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/icons/hamburger.svg')
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          productName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffcb082e),
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '\$' + productPrice.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xff7B6F72),
                            fontSize: 13,
                          ),
                        ),
                      ]
                    )   
                  ],
                ),
                ),
              );
            },
          ),
          )
        ],
      )
    );
  }


  Container _foodSection() {
    return Container(
      // padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _gap(),
          Center(
            child: Text(
              "Our Menu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xffcb082e),
                fontSize: 22,
              ),
            ),
          ),
          _gap(),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Color(0xFFd5ebf0),
              // borderRadius: BorderRadius.circular(10)
            ),
            child: GridView.builder(
            shrinkWrap: true, // Añade esta línea
            itemCount: foods.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20
            ),
            itemBuilder: (context, index) {
              return Container (
                decoration: BoxDecoration(
                  color: Color(0xFFf1f1f1),
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/icons/hamburger.svg')
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          foods[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffcb082e),
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          foods[index].description,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xff7B6F72),
                            fontSize: 13,
                          ),
                        ),
                      ]
                    )   
                  ],
                ),
              );
            },
          ),
          )
        ],
      )
    );
  }

}