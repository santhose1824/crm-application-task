import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/customer_model.dart';

class CustomerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add new customer
  Future<void> addCustomer(CustomerModel customer) async {
    final docRef = _firestore.collection('users').doc();
    final newCustomer = customer.copyWith(uid: docRef.id);
    await docRef.set(newCustomer.toMap());
  }

  // Get all customers
  Future<List<CustomerModel>> getCustomers() async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'customer')
        .get();

    return querySnapshot.docs
        .map((doc) => CustomerModel.fromMap(doc.data()))
        .toList();
  }

  // Update existing customer
  Future<void> updateCustomer(CustomerModel customer) async {
    await _firestore.collection('users').doc(customer.uid).update(customer.toMap());
  }

  // Delete customer
  Future<void> deleteCustomer(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }
}
