import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/vendor_user_models.dart';
import '../details/vendor_detail_screen.dart';

class VendorsListWidget extends StatefulWidget {
  final String searchQuery;

  VendorsListWidget({required this.searchQuery});

  @override
  _VendorsListWidgetState createState() => _VendorsListWidgetState();
}

class _VendorsListWidgetState extends State<VendorsListWidget> {
  final Stream<QuerySnapshot> _vendorStream =
  FirebaseFirestore.instance.collection('vendors').snapshots();

  Widget vendorData(Widget widget, int? flex) {
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
      stream: _vendorStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: LinearProgressIndicator());
        }

        var filteredDocs = snapshot.data!.docs.where((doc) {
          var vendor = VendorUserModel.fromJson(
              doc.data() as Map<String, dynamic>);
          return (vendor.businessName ?? "")
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase());
        }).toList();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: filteredDocs.length,
          itemBuilder: ((context, index) {
            VendorUserModel vendor = VendorUserModel.fromJson(
                filteredDocs[index].data() as Map<String, dynamic>);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                vendorData(
                    Container(
                      height: 50,
                      width: 50,
                      child: Image.network(
                        vendor.storeImage.toString(),
                        width: 50,
                        height: 50,
                      ),
                    ),
                    1),
                vendorData(
                    Text(
                      vendor.businessName.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    2),
                vendorData(
                    Text(
                      vendor.phoneNumber.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    1),
                vendorData(
                    Text(
                      vendor.cityValue.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    1),
                vendorData(
                    Text(
                      vendor.stateValue.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    1),
                vendorData(
                    vendor.approved == true
                        ? ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('vendors')
                              .doc(vendor.vendorId)
                              .update({
                            'approved': false,
                          });
                        },
                        child: Text(
                          'Reject',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ))
                        : ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('vendors')
                            .doc(vendor.vendorId)
                            .update({
                          'approved': true,
                        });
                      },
                      child: Text(
                        'Approved',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                    1),
                vendorData(
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VendorDetailScreen(vendor: vendor),
                            ),
                          );
                        },
                        child: Text(
                          'View More',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        )),
                    1),
              ],
            );
          }),
        );
      },
    );
  }
}
