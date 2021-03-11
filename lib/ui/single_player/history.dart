import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synonym_app/res/constants.dart';
import 'package:synonym_app/ui/admin/historyitem.dart';
import 'package:synonym_app/ui/common_widgets/help_icon.dart';

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
        body: Column(
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
                        // Text(
                        //   'Multiplayer',
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: MediaQuery.of(context).size.width * 0.05,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  HelpIcon(color: Colors.transparent),
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
                      color: pageIndex == 0 ? Colors.white : Colors.transparent,
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
                      color: pageIndex == 1 ? Colors.white : Colors.transparent,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'ANTONYMS',
                        style: TextStyle(
                          color: pageIndex == 1
                              ? Theme.of(context).accentColor
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
            pageIndex == 0
                ? Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          itemCount: synonym.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height / 100,
                                left: MediaQuery.of(context).size.width / 100,
                                right: MediaQuery.of(context).size.width / 100,
                              ),
                              child: Container(
                                color: Colors.white.withOpacity(0.7),
                                height: MediaQuery.of(context).size.height / 15,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Word:"),
                                          Text(synonym[index].question),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Answer Given:"),
                                              Text(synonym[index].answergiven),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Correct Answer:"),
                                              Text(
                                                  synonym[index].correctanswer),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                : Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          itemCount: antonym.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height / 100,
                                left: MediaQuery.of(context).size.width / 100,
                                right: MediaQuery.of(context).size.width / 100,
                              ),
                              child: Container(
                                color: Colors.white.withOpacity(0.7),
                                height: MediaQuery.of(context).size.height / 15,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Word:"),
                                          Text(antonym[index].question),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Answer Given:"),
                                              Text(antonym[index].answergiven),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Correct Answer:"),
                                              Text(
                                                  antonym[index].correctanswer),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(Constants.useruid)
                    .collection('antonym').document()
                    .snapshots(),
                builder: (_ctx, snapshot) {
                  if (snapshot.connectionState != ConnectionState.waiting &&
                      snapshot.data != null) {
                    return ListView.builder(
                        itemCount: snapshot.data.document.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ref =
                              snapshot.data.document[index];
                          return Padding(
                            padding:  EdgeInsets.only(
                              top: MediaQuery.of(context).size.height/100,
                              left: MediaQuery.of(context).size.width/100,
                              right:  MediaQuery.of(context).size.width/100,
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 16,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Word:"
                                      ), Text(
                                          "${ref['question']}"
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [Text(
                                            "Answer Given:"
                                        ), Text(
                                            "${ref['answergiven']}"
                                        ),],
                                      ),
                                    Row(
                                      children: [
                                        Text(
                                            "Answer Given:"
                                        ), Text(
                                            "${ref['answergiven']}"
                                        ),
                                      ],
                                    )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    return Container(
                      child: Center(
                        child: Text("NO DATA TO SHOW"),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ));
  }

  void readdata() {
    Firestore.instance
        .collection('users')
        .document(Constants.useruid)
        .collection('synonym')
        .getDocuments()
        .then((querySnapshot) {
      if (querySnapshot.documents.isNotEmpty) {
        querySnapshot.documents.forEach((result) {
          HistoryItem item = HistoryItem.fromMap(result.data);
          synonym.add(item);
        });
      } else {
        // synonym = null;
      }
      setState(() {});
    });
    Firestore.instance
        .collection('users')
        .document(Constants.useruid)
        .collection('antonym')
        .getDocuments()
        .then((querySnapshot) {
      if (querySnapshot.documents.isNotEmpty) {
        querySnapshot.documents.forEach((result) {
          HistoryItem item = HistoryItem.fromMap(result.data);
          antonym.add(item);
        });
      } else {
        // antonym.length=0;
      }
      setState(() {});
    });
  }
}
