import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../details/buyer_detail_screen.dart';

class BuyersListWidget extends StatefulWidget {
  final String searchQuery;

  BuyersListWidget({required this.searchQuery});

  @override
  _BuyersListWidgetState createState() => _BuyersListWidgetState();
}

class _BuyersListWidgetState extends State<BuyersListWidget> {
  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('buyers').snapshots();

  Widget buyerData(Widget widget, int? flex) {
    return Expanded(
      flex: flex!,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: LinearProgressIndicator());
        }

        var filteredDocs = snapshot.data!.docs.where((doc) {
          return (doc['fullName'].toString().toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
              doc['email'].toString().toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
              doc['address'].toString().toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
              doc['phoneNumber'].toString().toLowerCase().contains(widget.searchQuery.toLowerCase()));
        }).toList();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: filteredDocs.length,
          itemBuilder: ((context, index) {
            final buyer = filteredDocs[index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buyerData(
                  Container(
                    height: 50,
                    width: 50,
                    child: Image.network(
                      buyer['profileImage'],
                      width: 50,
                      height: 50,
                    ),
                  ),
                  1,
                ),
                buyerData(
                  Text(
                    buyer['fullName'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  1,
                ),
                buyerData(
                  Text(
                    buyer['email'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  2,
                ),
                buyerData(
                  Text(
                    buyer['address'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  3,
                ),
                buyerData(
                  Text(
                    buyer['phoneNumber'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  1,
                ),
                buyerData(
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuyerDetailScreen(buyerData: buyer),
                        ),
                      );
                    },
                    child: Text(
                      'Xem Thêm',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  1,
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
