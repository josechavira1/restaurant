import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:restaurant/models/food_model.dart';
import 'package:restaurant/models/product_model.dart';
import 'package:restaurant/services/firestore.dart';

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
          _formSection(),
          _gap(),
          _getProductsStream()
        ],
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
          return _streamFood(productsList);
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
      title: const Text('Modify Menu'),
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

  Container _formSection() {
    //variables to upload data
    String _name = "";
    double _price = 0;
    String _description = "";

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Text(
              "Product",
              style: TextStyle(
                color: const Color(0xFF212529),
                fontSize: 14,
              ),
            ),
            TextFormField(
              onSaved: (String? value) {
                _name = value ?? ''; // Handle null value if needed
              },
              decoration: InputDecoration(
                labelText: "Name of the product",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD5EBF0), width: 5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF212529)),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            _gap(),
            Text(
              "Price",
              style: TextStyle(
                color: const Color(0xFF212529),
                fontSize: 14,
              ),
            ),
            TextFormField(
              
              keyboardType: TextInputType.number,
              onSaved: (String? value) {
                // Convert the value to a Float (if not null)
                if (value != null) {
                  _price = double.tryParse(value) ?? 0.0;
                } else {
                  // Handle null value (if needed)
                  _price = 0.0;
                }
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                labelText: "Price of the product",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD5EBF0), width: 5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF212529)),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the price';
                }
                return null;
              },
            ),
            _gap(),
            Text(
              "Description",
              style: TextStyle(
                color: const Color(0xFF212529),
                fontSize: 14,
              ),
            ),
            TextFormField(
              onSaved: (String? value) {
                _description = value ?? ''; // Handle null value if needed
              },
              keyboardType: TextInputType.multiline,
              minLines: 3,//Normal textInputField will be displayed
              maxLines: 5,// when user presses enter it will adapt to it
              decoration: InputDecoration(
                labelText: "Description of the product",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD5EBF0), width: 5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF212529)),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            _gap(),
            Container(
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
                      if (_formKey.currentState?.validate() ?? false) {
                        /// do something
                        _formKey.currentState!.save();
                        print('Form is valid');
                        ProductModel product = ProductModel(name: _name, price: _price, description: _description);
                        firestoreService.addProduct(product);
                      }
                    },
                    child: const Text('Add food'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Container _listSection() {
  //   return Container(
  //     padding: const EdgeInsets.all(20.0),
  //     decoration: BoxDecoration(
  //       color: Color(0xFFd5ebf0),
  //       // borderRadius: BorderRadius.circular(10)
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start, 
  //       children: [
  //         Text(
  //           "Food",
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //             color: const Color(0xffcb082e),
  //             fontSize: 22,
  //           ),
  //         ),
  //         _gap(),
  //         Container(
  //           padding: const EdgeInsets.all(20.0),
  //           decoration: BoxDecoration(
  //             color: Colors.red,
  //             // borderRadius: BorderRadius.circular(10)
  //           ),
  //           child: ListView.separated(
  //             scrollDirection: Axis.vertical,
  //             itemCount: foods.length,
  //             separatorBuilder: (context, index) => SizedBox(width: 25,),
  //             padding: EdgeInsets.only(
  //               left: 20,
  //               right: 20
  //             ),
  //             itemBuilder: (context, index) {
  //                 return Container(
  //                   width: 210,
  //                   height: 200,
  //                   decoration: BoxDecoration(
  //                     color: foods[index].boxColor.withOpacity(0.3),
  //                     borderRadius: BorderRadius.circular(16)
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       Container(
  //                         width: 40,
  //                         height: 40,
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           shape: BoxShape.circle
  //                         ),
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: SvgPicture.asset(foods[index].iconPath)
  //                         ),
  //                       ),
  //                       Column(
  //                         children: [
  //                           Text(
  //                             foods[index].name,
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.black,
  //                               fontSize: 18,
  //                             ),
  //                           ),
  //                           Text(
  //                             foods[index].description,
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.w400,
  //                               color: Color(0xff7B6F72),
  //                               fontSize: 13,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               },
  //           )
  //         ),
  //       ],
  //     ),
  //   );
  // }


  // Column _foodsection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: 20),
  //         child: Text(
  //           'Food',
  //           style: TextStyle(
  //             color: Colors.black,
  //             fontSize: 18,
  //             fontWeight: FontWeight.w600
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: 15,),
  //       Container(
  //         height: 240,
  //         // color: Colors.green,
  //         child: ListView.separated(
  //           scrollDirection: Axis.vertical,
  //           itemCount: foods.length,
  //           separatorBuilder: (context, index) => SizedBox(width: 25,),
  //           padding: EdgeInsets.only(
  //             left: 20,
  //             right: 20
  //           ),
  //           itemBuilder: (context, index) {
  //             return Container(
  //               width: 210,
  //               padding: const EdgeInsets.all(8.0),
  //               margin: const EdgeInsets.all(8.0),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(10)
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Container(
  //                     width: 40,
  //                     height: 40,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       shape: BoxShape.circle
  //                     ),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: SvgPicture.asset(foods[index].iconPath)
  //                     ),
  //                   ),
  //                   Container(
  //                     padding: const EdgeInsets.only(left: 20),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           foods[index].name,
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.black,
  //                             fontSize: 18,
  //                           ),
  //                         ),
  //                         Text(
  //                           foods[index].description,
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.w400,
  //                             color: Color(0xff7B6F72),
  //                             fontSize: 13,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       )
  //     ],
  //   );
  // }

  Column _streamFood(products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          height: 240,
          // color: Colors.green,
          child: ListView.separated(
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
              return Container(
                width: 210,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
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
                        child: SvgPicture.asset('assets/icons/school-solid.svg')
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
              );
            },
          ),
        )
      ],
    );
  }

}