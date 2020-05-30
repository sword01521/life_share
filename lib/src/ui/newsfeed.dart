import 'package:blooddonate/src/ui/map_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  Firestore _firestore;

  @override
  void initState() {
    super.initState();
    _firestore = Firestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NewsFeed'
        ),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) => MapView()
              ));
            },
            icon: Icon(
              Icons.map
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: _firestore.collection('blood_req').snapshots(),
        builder: (context, snapshot){

              if (snapshot.hasData){
                var trains = snapshot.data.documents;
                List<Card> allTrains = [];
                for (var doc in trains){
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
                              fontSize: 16
                            ),
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
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10
                        ),
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
                                  fontWeight: FontWeight.w600
                                ),
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
                                      Icon(Icons.location_on, color: Colors.red,),
                                      SizedBox(width: 5,),
                                      Text(
                                        '$address',
                                        style: TextStyle(
                                          color: Colors.red
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.call, color: Colors.red,),
                                      SizedBox(width: 5,),
                                      Text(
                                        '$phone',
                                        style: TextStyle(
                                          color: Colors.red
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.play_arrow, color: Colors.red,),
                                      SizedBox(width: 5,),
                                      Text(
                                        '$units Unit',
                                        style: TextStyle(
                                          color: Colors.red
                                        ),
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
                    )
                  );
                  allTrains.add(listTile);
                }
                return ListView(
                  children: allTrains,
                );
              } else {
                return Center(
                  child: Text(
                    'Blood reuqest empty!'
                  ),
                );
              }

        },
      )
    );
  }
}