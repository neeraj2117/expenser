import 'package:cloud_firestore/cloud_firestore.dart';

class MyTransaction {
  String id;
  double amount;
  String category;
  DateTime date;
  String notes;
  String? imageUrl;

  MyTransaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.notes,
    this.imageUrl,
  });

  // Define a method to convert MyTransaction to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date,
      'notes': notes,
      'imageUrl': imageUrl,
    };
  }

  // Define a factory method to create MyTransaction from Firestore snapshot
  factory MyTransaction.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return MyTransaction(
      id: snapshot.id,
      amount: data['amount'],
      category: data['category'],
      date: data['date'].toDate(), // Convert Firestore Timestamp to DateTime
      notes: data['notes'],
      imageUrl: data['imageUrl'],
    );
  }
}
