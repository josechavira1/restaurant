import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference products = 
    FirebaseFirestore.instance.collection('products');

  //CREATE: ADD A NEW PRODUCT
  Future<void> addProduct(ProductModel product) {
    return products.add({
      'name': product.name,
      'price': product.price,
      'description': product.description
    });
  }

  //READ: GET PRODUCTS FROM THE DB
  Stream<QuerySnapshot> getProductsStream() {
    final productsStream = 
      products.orderBy('name', descending: true).snapshots();

    return productsStream;
  }

  //UPDATE: UPDATE PRODUCT GIVEN A DOC ID
    Future<void> updateProduct(ProductModel product) {
    return products.doc(product.id).update({
      'name': product.name,
      'price': product.price,
      'description': product.description
    });
  }

  Future<void> deleteProduct(String docID) {
    return products.doc(docID).delete();
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }
  
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  

  // Future<void> _signInWithEmailAndPassword() async {
  //   try {
  //     await _auth.signInWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text,
  //     );
  //     // Successfully signed in, navigate to the next screen.
  //     Navigator.pushReplacementNamed(context, '/home'); // Replace with your route.
  //   } catch (e) {
  //     // Handle sign-in errors (e.g., invalid credentials, user not found).
  //     print('Error signing in: $e');
  //   }
  // }
}