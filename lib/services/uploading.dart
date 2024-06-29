import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensr/models/transaction.dart';
import 'package:expensr/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final CollectionReference transactionsCollection =
      FirebaseFirestore.instance.collection('transactions');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTransaction({
    required double amount,
    required String category,
    required DateTime date,
    required String notes,
    required File? image,
    required BuildContext context,
  }) async {
    try {
      // Get the current user's ID
      String userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user';

      String? imageUrl;
      if (image != null) {
        imageUrl = await uploadImage(image);
      }

      await transactionsCollection.add({
        'user_id': userId,
        'amount': amount,
        'category': category,
        'date': date,
        'notes': notes,
        'imageUrl': imageUrl,
      });

      showSnackBar('Transaction added successfully', context);
    } catch (e) {
      showSnackBar(e.toString(), context);
      print('Error adding transaction: $e');
    }
  }

  Future<String> uploadImage(File image) async {
    try {
      var storageRef = FirebaseStorage.instance
          .ref()
          .child('transaction_images/${image.path}');
      var uploadTask = storageRef.putFile(image);
      await uploadTask;

      var downloadUrl = await storageRef.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<List<MyTransaction>> getTransactions({String? category}) async {
    List<MyTransaction> transactions = [];

    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      Query query = transactionsCollection
          .where('user_id', isEqualTo: userId)
          .orderBy('date', descending: true); // Add orderBy clause here

      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }

      QuerySnapshot querySnapshot = await query.get();
      querySnapshot.docs.forEach((doc) {
        transactions.add(MyTransaction.fromSnapshot(doc));
      });
    } catch (e) {
      print('Error getting transactions: $e');
    }

    return transactions;
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _db.collection('transactions').doc(transactionId).delete();
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  Future<void> updateTransaction({
    required String transactionId,
    required double amount,
    required String category,
    required DateTime date,
    required String notes,
    required BuildContext context,
  }) async {
    try {
      await transactionsCollection.doc(transactionId).update({
        'amount': amount,
        'category': category,
        'date': date,
        'notes': notes,
      });

      showSnackBar('Transaction updated successfully', context);
    } catch (e) {
      showSnackBar(e.toString(), context);
      print('Error updating transaction: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await usersCollection.doc(userId).get();
      return userDoc.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
}
