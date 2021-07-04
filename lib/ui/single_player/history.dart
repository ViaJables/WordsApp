import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synonym_app/res/constants.dart';
import 'package:synonym_app/ui/admin/historyitem.dart';
import 'package:synonym_app/ui/common_widgets/help_icon.dart';
import 'package:synonym_app/ui/shared/starfield.dart';

class Historypage extends StatefulWidget {
  @override
  _HistorypageState createState() => _HistorypageState();
}

class _HistorypageState extends State<Historypage> {
  int pageIndex = 0;
  List<HistoryItem> synonym = [];
  List<HistoryItem> antonym = [];

  @override
  void initState() {
    // TODO: implement initState
    readdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          new Starfield(),
          Column(
            children: [
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'HISTORY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.07,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer()
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          pageIndex = 0;
                        });
                      },
                      child: Container(
                        color:
                            pageIndex == 0 ? Colors.white : Colors.transparent,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'SYNONYMS',
                          style: TextStyle(
                            color: pageIndex == 0
                                ? Theme.of(context).accentColor
                                : Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          pageIndex = 1;
                        });
                      },
                      child: Container(
                        color:
                            pageIndex == 1 ? Colors.white : Colors.transparent,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'ANTONYMS',
                          style: TextStyle(
                            color: pageIndex == 1
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (pageIndex == 0)
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: synonym.length > 0
                        ? ListView.builder(
                            shrinkWrap: false,
                            itemCount: synonym.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height / 100,
                                  left: MediaQuery.of(context).size.width / 100,
                                  right:
                                      MediaQuery.of(context).size.width / 100,
                                ),
                                child: Container(
                                  color: Colors.transparent,
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Word: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              synonym[index].question,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Answer: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              synonym[index].answergiven,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Correct: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              synonym[index].correctanswer,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                        : Container(
                            child: Center(
                              child: Text(
                                "NO DATA TO SHOW",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                  ),
                )
              else
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    width: MediaQuery.of(context).size.width,
                    child: antonym.length > 0
                        ? ListView.builder(
                            itemCount: antonym.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height / 100,
                                  left: MediaQuery.of(context).size.width / 100,
                                  right:
                                      MediaQuery.of(context).size.width / 100,
                                ),
                                child: Container(
                                  color: Colors.transparent,
                                  height: 90,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Word: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              antonym[index].question,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Answer: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              antonym[index].answergiven,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Correct: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              antonym[index].correctanswer,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                        : Container(
                            child: Center(
                              child: Text(
                                "NO DATA TO SHOW",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void readdata() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(Constants.useruid)
        .collection('synonym')
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((result) {
          HistoryItem item = HistoryItem.fromMap(result.data());
          synonym.add(item);
        });
      } else {
        // synonym = null;
      }
      setState(() {});
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(Constants.useruid)
        .collection('antonym')
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((result) {
          HistoryItem item = HistoryItem.fromMap(result.data());
          antonym.add(item);
        });
      } else {
        // antonym.length=0;
      }
      setState(() {});
    });
  }
}
