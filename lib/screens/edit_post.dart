import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expensr/models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionEditScreen extends StatefulWidget {
  final MyTransaction transaction;

  const TransactionEditScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  State<TransactionEditScreen> createState() => _TransactionEditScreenState();
}

class _TransactionEditScreenState extends State<TransactionEditScreen> {
  late TextEditingController _categoryController;
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  late TextEditingController _dateController;
  late DateTime _selectedDate;
  late String _selectedCategory;
  bool _isLoading = false;

  final List<String> categories = [
    'Foods',
    'Travelling',
    'Rent',
    'Education',
    'Entertainment',
    'Others',
  ];

  @override
  void initState() {
    super.initState();
    _categoryController =
        TextEditingController(text: widget.transaction.category);
    _amountController =
        TextEditingController(text: widget.transaction.amount.toString());
    _notesController = TextEditingController(text: widget.transaction.notes);
    _selectedDate = widget.transaction.date;
    _dateController = TextEditingController(
        text: DateFormat('dd MMMM yyyy').format(widget.transaction.date));
    _selectedCategory =
        widget.transaction.category; // Initialize with transaction's category
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void updateTransactionInFirestore(MyTransaction updatedTransaction) {
    FirebaseFirestore.instance
        .collection('transactions')
        .doc(updatedTransaction.id)
        .update(updatedTransaction.toMap())
        .then((value) {
      print('Transaction updated successfully');

      Navigator.of(context).pop();
    }).catchError((error) {
      print('Failed to update transaction: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd MMMM yyyy').format(_selectedDate),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedCategory, // Use _selectedCategory instead of widget.transaction.category
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Text(
                  '\$${_amountController.text}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.transaction.imageUrl ?? ''),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCategory,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  itemHeight: 60,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  items:
                      categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.category,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            value,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 18),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 18),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2015, 8),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != _selectedDate) {
                  setState(() {
                    _selectedDate = pickedDate;
                    _dateController.text =
                        DateFormat('dd MMMM yyyy').format(pickedDate);
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });

                    Future.delayed(const Duration(seconds: 2), () {
                      final updatedTransaction = MyTransaction(
                        id: widget.transaction.id,
                        amount: double.parse(_amountController.text),
                        category: _categoryController.text,
                        date: widget.transaction.date,
                        notes: _notesController.text,
                        imageUrl: widget.transaction.imageUrl,
                      );

                      updateTransactionInFirestore(updatedTransaction);

                      setState(() {
                        _isLoading = false;
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Update Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
