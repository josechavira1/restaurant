import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:restaurant/models/food_model.dart';
import 'package:restaurant/models/product_model.dart';
import 'package:restaurant/services/firestore.dart';
import 'package:restaurant/pages/admin/edit.dart';
import 'package:restaurant/pages/admin/create.dart';

class FoodPage extends StatelessWidget {
  FoodPage({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          _gap(),
          _addButton(context),
          _gap(),
          _getProductsStream()
        ],
      ),
    );
  }

  Container _addButton(context) {
    return Container(
      child: Center(
        child: SizedBox(
          width: 300,
          child: ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Color(0xFFAD0727);
                  }
                  else {
                    return Color(0xffcb082e);
                  }
                  //return null; // Use the component's default.
                },
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePage()),
              );
            },
            child: const Text('Add food to the menu'),
          ),
        ),
      ),
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
          return _streamFood(productsList, context);
        }
        else {
          return const Text("No data available");
        }
      },
    );
  }

  Widget _gap() => const SizedBox(height: 16);

  AppBar appBar(context) {
    return AppBar(
      title: const Text('Menu'),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold
      ),
      backgroundColor: const Color(0xffcb082e),
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xfff7F8F8),
            borderRadius: BorderRadius.circular(10)
          ),
          child: SvgPicture.asset(
            'assets/icons/chevron-left-solid.svg',
            height: 20,
            width: 20,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            
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
              'assets/icons/ellipsis-solid.svg',
              height: 20,
              width: 20,
            ),
          ),
        )

      ],
    );
  }

  Container _streamFood(products, context) {
    return Container(
      child: Column(
        children: [
          Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Food',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        SizedBox(height: 15,),
        Container(
          // padding: const EdgeInsets.all(20.0),
            // decoration: BoxDecoration(
            //   color: Color(0xFFd5ebf0),
            //   // borderRadius: BorderRadius.circular(10)
            // ),
          // color: Colors.green,
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true, // Añade esta línea
            scrollDirection: Axis.vertical,
            itemCount: products.length,
            separatorBuilder: (context, index) => SizedBox(width: 25,),
            padding: EdgeInsets.only(
              left: 20,
              right: 20
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

              return Container(
                width: 210,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditPage(product: _products)),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset('assets/icons/hamburger.svg')
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              productDesc,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xff7B6F72),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              );
            },
          ),
        )
      ],
      ),
    );
  }

}