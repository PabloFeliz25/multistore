import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VendorWidget extends StatelessWidget {
  VendorWidget({super.key});

  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Widget vendorData(int? flex, Widget widget) {
    return Expanded(
        flex: flex!,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: widget,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorStream =
        FirebaseFirestore.instance.collection('vendors').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _vendorStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return Container(
              child: Row(
                children: [
                  vendorData(
                    1,
                    Container(
                      width: 50,
                      height: 50,
                      child: Image.network(snapshot.data!.docs[index]['image']),
                    ),
                  ),
                  vendorData(
                    3,
                    Text(snapshot.data!.docs[index]['businessName']
                        .toString()
                        .toUpperCase()),
                  ),
                  vendorData(
                    2,
                    Text(snapshot.data!.docs[index]['city']),
                  ),/*
                  vendorData(
                    2,
                    Text(snapshot.data!.docs[index]['state']),
                  ),*/
                  vendorData(
                    1,
                    snapshot.data!.docs[index]['approved'] == false
                        ? ElevatedButton(
                            onPressed: () async {
                              await _firebaseFirestore
                                  .collection('vendors')
                                  .doc(snapshot.data!.docs[index]['vendorId'])
                                  .update({
                                'approved': true,
                              });
                            },
                            child: Text('approved'),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0))),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              await _firebaseFirestore
                                  .collection('vendors')
                                  .doc(snapshot.data!.docs[index]['vendorId'])
                                  .update({
                                'approved': false,
                              });
                            },
                            child: Text('Reject'),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0))),
                          ),
                  ),
                  vendorData(
                    1,
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('View More'),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
