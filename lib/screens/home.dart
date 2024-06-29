import 'dart:math';
import 'package:expensr/models/transaction.dart';
import 'package:expensr/screens/edit_post.dart';
import 'package:expensr/services/uploading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> categories = [
    'Foods',
    'Travelling',
    'Rent',
    'Education',
    'Entertainment',
    'Others',
  ];

  int selectedIndex = -1;

  final FirestoreService _firestoreService = FirestoreService();
  List<MyTransaction> _transactions = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _editTransaction(MyTransaction transaction) async {
    final updatedTransaction = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionEditScreen(transaction: transaction),
      ),
    );

    _loadTransactions(
        category: selectedIndex >= 0 ? categories[selectedIndex] : null);
  }

  Future<void> _loadTransactions({String? category}) async {
    setState(() {
      _loading = true;
    });
    List<MyTransaction> transactions =
        await _firestoreService.getTransactions(category: category);
    setState(() {
      _transactions = transactions;
      _loading = false;
    });
  }

  void _refreshTransactions() {
    _loadTransactions(
        category: selectedIndex >= 0 ? categories[selectedIndex] : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        title: const Text(
          'Expenser',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshTransactions,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 16, bottom: 5),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: List.generate(
                  categories.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(categories[index]),
                        selected: selectedIndex == index,
                        onSelected: (selected) {
                          setState(() {
                            selectedIndex = selected ? index : -1;
                          });
                          _loadTransactions(
                              category: selected ? categories[index] : null);
                        },
                        selectedColor: Colors.blue,
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          fontWeight: selectedIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selectedIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                        selectedShadowColor: Colors.transparent,
                        checkmarkColor: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'Most recent',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.0,
                  mainAxisSpacing: 19.0,
                ),
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  MyTransaction transaction = _transactions[index];
                  Color randomColor = getRandomColor();
                  return GestureDetector(
                    onTap: () {
                      _editTransaction(transaction);
                    },
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.only(
                          top: 12, left: 12, right: 2, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: randomColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    transaction.category,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.grey,
                                  size: 28,
                                ),
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _editTransaction(transaction);
                                  } else if (value == 'delete') {
                                    _deleteTransaction(transaction);
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'edit',
                                    child: ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: ListTile(
                                      leading: Icon(Icons.delete),
                                      title: Text('Delete'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          _buildInfoRow(
                              'Amount', transaction.amount.toString()),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Note: ',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  transaction.notes,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 14.0),
                                child: Text(
                                  _formatTimeAgo(transaction.date),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    Duration timeAgo = DateTime.now().difference(date);
    if (timeAgo.inDays > 0) {
      return '${timeAgo.inDays} ${timeAgo.inDays == 1 ? 'day' : 'days'} ago';
    } else if (timeAgo.inHours > 0) {
      return '${timeAgo.inHours} ${timeAgo.inHours == 1 ? 'hr' : 'hrs'} ago';
    } else if (timeAgo.inMinutes > 0) {
      return '${timeAgo.inMinutes} ${timeAgo.inMinutes == 1 ? 'min' : 'mins'} ago';
    } else {
      return 'just now';
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _deleteTransaction(MyTransaction transaction) async {
    try {
      await _firestoreService.deleteTransaction(transaction.id);
      // Refresh the list of transactions after deletion
      _loadTransactions();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete transaction: $e')),
      );
    }
  }

  Color getRandomColor() {
    Random random = Random();
    int red = 200 + random.nextInt(56); // Red component between 200 and 255
    int green = 200 + random.nextInt(56); // Green component between 200 and 255
    int blue = 200 + random.nextInt(56); // Blue component between 200 and 255
    return Color.fromRGBO(
      red,
      green,
      blue,
      1, // Opacity
    );
  }
}
