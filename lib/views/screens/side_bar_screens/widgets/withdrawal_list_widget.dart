import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class WithdrawalListWidget extends StatefulWidget {
  @override
  _WithdrawalListWidgetState createState() => _WithdrawalListWidgetState();
}

class _WithdrawalListWidgetState extends State<WithdrawalListWidget> {
  final Stream<QuerySnapshot> _withdrewStream =
  FirebaseFirestore.instance.collection('withdrawal').snapshots();

  Widget withdrawl(Widget widget, int? flex) {
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
      stream: _withdrewStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: LinearProgressIndicator());
        }

        return Container(
          height: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: ((context, index) {
              final _withdrewData = snapshot.data!.docs[index];
              return Row(
                children: [
                  withdrawl(
                      Text(
                        _withdrewData['businessName'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      2),
                  withdrawl(
                      Text(
                        _withdrewData['accountName'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      2),
                  withdrawl(
                      Text(
                        _withdrewData['bankName'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      2),
                  withdrawl(
                      Text(
                        _withdrewData['accountNumber'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      2),
                  withdrawl(
                      Text(
                        '\$' + " " + _withdrewData['amount'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      1),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}