import 'package:blooddonate/src/models/blood_request.dart';
import 'package:blooddonate/src/ui/manage_blood_req.dart';
import 'package:blooddonate/src/view_models/search_blood_viewmodel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SearchBlood extends StatefulWidget {
  @override
  _SearchBloodState createState() => _SearchBloodState();
}

class _SearchBloodState extends State<SearchBlood> {
  TextEditingController _addressController, _requestMessageController;
  var dropDownSelected = 'A+';
  var quantityDropdownSelected = "1";
  bool inProgress = false;
  SearchBloodViewModel _searchBloodViewModel = SearchBloodViewModel();

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _requestMessageController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _requestMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: inProgress,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Find Blood'
          ),
          actions: <Widget>[
            IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context)=> ManageBloodReq()
                ));
              },
              icon: Icon(
                Icons.view_list,
                color: Colors.white,
                size: 24,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Choose Blood Group')
              ),
              SizedBox(
                height:5,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16,),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  value: 'A+',
                  items: <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropDownSelected = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('How Many Units')
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16,),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  value: '1',
                  items: <String>['1', '2', '3', '4', '5', '6', '7', '8']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      quantityDropdownSelected = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16,),
                child: TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                    ),
                    hintText: 'Area of donation',
                    labelText: 'Full Address of Donation',
                    prefixIcon: Icon(
                        Icons.location_on
                    ),
                  ),
                  style: TextStyle(
                    letterSpacing: .8,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                margin: EdgeInsets.symmetric(horizontal: 16,),
                child: TextField(
                  controller: _requestMessageController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                    ),
                    hintText: 'Type you request message',
                    labelText: 'Request Message',

                    alignLabelWithHint: true
                  ),
                  maxLines: 10,
                  style: TextStyle(
                    letterSpacing: .8,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: RaisedButton(
                  onPressed: () async{
                    if (_addressController.text.trim().isNotEmpty){
                      BloodRequest bloodReq = BloodRequest(
                        bloodGroup: dropDownSelected,
                        address: _addressController.text.trim(),
                        requestMessage: _requestMessageController.text.trim(),
                        units: quantityDropdownSelected.toString(),
                      );
                      var result = await _searchBloodViewModel.postSearchBlood(bloodReq);
                      if (result){
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text(
                              'Blood request post successful!',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ), backgroundColor: Colors.green,
                            )
                        );
                        _addressController.clear();
                        _requestMessageController.clear();
                      } else {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text(
                              'Blood request post failed!',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ), backgroundColor: Colors.red,
                            )
                        );
                      }
                    } else {
                      BotToast.showText(
                        text: 'Please fill your address',
                        textStyle: TextStyle(
                          color: Colors.white
                        ),
                        contentColor: Colors.red
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                        'SUBMIT REQUEST'
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
