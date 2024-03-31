import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:restaurant/models/food_model.dart';
import 'package:restaurant/models/product_model.dart';
import 'package:restaurant/services/firestore.dart';

class CreatePage extends StatelessWidget {
  CreatePage({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: Color(0xFFf1f1f1),
      body: ListView(
        children: [
          _formSection(context)
        ],
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);

  AppBar appBar(context) {
    return AppBar(
      title: const Text('Modify the product'),
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

  Container _formSection(context) {
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
                        Navigator.pop(context);
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
}