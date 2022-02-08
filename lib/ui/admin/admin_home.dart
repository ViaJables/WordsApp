import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synonym_app/helpers/auth_helper.dart';
import 'package:synonym_app/models/question.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/ui/admin/add_word.dart';
import 'package:synonym_app/ui/start_point/splash.dart';

class AdminHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Welcome Admin',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.power_settings_new),
              color: Colors.white,
              onPressed: () async {
                AuthHelper().signOut().then((val) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => Splash()),
                    (_) => false,
                  );
                });
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColorDark,
            tabs: [
              Tab(
                child: Text(
                  'Synonym'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Antonym'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () async {
//            for(var item in FakeData.questions)
//              await Firestore.instance.collection(Keys.questions).document(item.id).setData(item.toMap());

            //Navigator.of(context)
              //  .push(MaterialPageRoute(builder: (_) => AddWord()));
          },
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
//          decoration: BoxDecoration(
//            image: DecorationImage(
//              image: AssetImage('assets/background.png'),
//              fit: BoxFit.cover,
//            ),
//          ),
          child: TabBarView(children: [
            WordsList(Keys.synonym),
            WordsList(Keys.antonym),
          ]),
        ),
      ),
    );
  }
}

class WordsList extends StatelessWidget {
  final String synonymOrAntonym;

  WordsList(this.synonymOrAntonym);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(Keys.questions)
          .where('synonymOrAntonym', isEqualTo: synonymOrAntonym)
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        return ListView.separated(
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (_, i) => Divider(),
          itemBuilder: (_, index) {
            Question question =
                Question.fromMap(snapshot.data!.docs[index].data()  as Map<String, dynamic>);

            return ListTile(
              title: Text(question.word),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection(Keys.questions)
                      .doc(question.id)
                      .delete();
                },
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => AddWord(
                          question: question,
                        )));
              },
            );
          },
        );
      },
    );
  }
}
