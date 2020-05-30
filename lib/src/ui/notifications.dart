import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool inProgress = false;
  Firestore _fireStore = Firestore.instance;
  String _bloodGroup, uid;

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  Widget mainList;

  Future<bool> getNotifications() async {
    try {
      setState(() {
        inProgress = true;
      });
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      uid = user.uid;
      _fireStore.collection('users')
        ..where("uid", isEqualTo: uid).getDocuments().then((value) {
          var data = value.documents[0].data;
          _bloodGroup = data['blood_group'];
        }).whenComplete(() {
          setState(() {
            mainList = StreamBuilder(
              stream: Firestore.instance
                  .collection('blood_req')
                  .where('blood_group', isEqualTo: _bloodGroup)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  var trains = snapshot.data.documents;
                  List<Card> allTrains = [];
                  for (var doc in trains) {
                    final userName = doc.data['name'];
                    final phone = doc.data['phone'];
                    final address = doc.data['address'];
                    final bloodGroup = doc.data['blood_group'];
                    final requestMessage = doc.data['request_message'];
                    final units = doc.data['units'];

                    final listTile = Card(
                        elevation: 4,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '$userName',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.red,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Searching for',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  child: Text(
                                    '$bloodGroup',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '$address',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.call,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '$phone',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.play_arrow,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '$units Unit',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ));
                    allTrains.add(listTile);
                  }
                  if (allTrains.length == 0){
                    return Center(
                      child: Text('No notifications'),
                    );
                  } else {
                    return  ListView(
                      children: allTrains,
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          });
        });
      return true;
    } catch (e) {
      BotToast.showText(
          text: e.toString(),
          contentColor: Colors.red,
          textStyle: TextStyle(color: Colors.white));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('NewsFeed'),
        ),
        body: mainList
    );
  }
}
