import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:synonym_app/models/question.dart';
import 'package:synonym_app/res/keys.dart';
import 'package:synonym_app/res/static_info.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class AddWord extends StatefulWidget {
  final Question question;

  AddWord({this.question});

  @override
  _AddWordState createState() => _AddWordState();
}

class _AddWordState extends State<AddWord> {
  final _formKey = GlobalKey<FormState>();

  int _optionIndex;
  String _wordType;

  TextEditingController _wordController;
  List<TextEditingController> _optionsControllers;

  @override
  void initState() {
    super.initState();

    if (widget.question == null) {
      _wordController = TextEditingController();
      _optionsControllers = List.generate(4, (i) => TextEditingController());
    } else {
      _wordController = TextEditingController(text: widget.question.word);
      _optionsControllers = List.generate(
          4, (i) => TextEditingController(text: widget.question.answers[i]));
      _optionIndex = widget.question.correctAnswer;
      _wordType = widget.question.synonymOrAntonym;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Word',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _wordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Word',
                        ),
                        validator: (value) {
                          if (value.isEmpty) return 'Enter word';
                          return null;
                        },
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        _radioTile('Option 1', 0, _optionsControllers[0]),
                        _radioTile('Option 2', 1, _optionsControllers[1]),
                        _radioTile('Option 3', 2, _optionsControllers[2]),
                        _radioTile('Option 4', 3, _optionsControllers[3]),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RadioListTile(
                              title: Text('Synonym'),
                              value: Keys.synonym,
                              groupValue: _wordType,
                              onChanged: (fl) {
                                setState(() {
                                  _wordType = fl;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              title: Text('Antonym'),
                              value: Keys.antonym,
                              groupValue: _wordType,
                              onChanged: (fl) {
                                setState(() {
                                  _wordType = fl;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    MaterialButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _createWord,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            color: Theme.of(context).accentColor,
                            height: 1,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text('OR'),
                        SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            color: Theme.of(context).accentColor,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    MaterialButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Add Words From Excel File',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _pickExcelWords,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _radioTile(String label, int value, TextEditingController controller) {
    return RadioListTile(
      title: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
        validator: (value) {
          if (value.isEmpty) return 'Enter $label';
          return null;
        },
      ),
      value: value,
      groupValue: _optionIndex,
      onChanged: (fl) {
        setState(() {
          _optionIndex = fl;
        });
      },
    );
  }

  _createWord() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (!_formKey.currentState.validate())
      return;
    else if (_wordType == null) {
      Toast.show('Choose one: Synonym/Antonym', context, duration: 3);
      return;
    } else if (_optionIndex == null) {
      Toast.show('Choose correct answer', context, duration: 3);
      return;
    }

    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    dialog.show();

    try {
      var answers = List.generate(4, (i) => _optionsControllers[i].text);

      Question question = Question(
        id: widget.question == null ? Uuid().v1() : widget.question.id,
        word: _wordController.text,
        synonymOrAntonym: _wordType,
        correctAnswer: _optionIndex,
        answers: answers,
      );

      if (widget.question == null)
        await Firestore.instance
            .collection(Keys.questions)
            .document(question.id)
            .setData(question.toMap());
      else
        await Firestore.instance
            .collection(Keys.questions)
            .document(question.id)
            .updateData(question.toMap());

      dialog.hide();
      Navigator.pop(context);
    } catch (e) {
      print(e);
      dialog.hide();
      Toast.show('error in adding question', context, duration: 3);
    }
  }

  _pickExcelWords() async {
    var wordType = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text('Note: Excel file must be arranged in such a way that '
            'first column must be question, second column must be correct'
            ' answer and other three columns must be remaining options\n\n\n'
            'What would be the type of words you are choosing?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context, Keys.synonym),
            child: Text(Keys.synonym.toUpperCase()),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context, Keys.antonym),
            child: Text(Keys.antonym.toUpperCase()),
          ),
        ],
      ),
    );

    if (wordType == null) return;

    var file = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ['.xls', '.xlsx']);
    if (file == null) return;
    var extension = file.path.split('.').last;

    if (!['xls', 'xlsx'].contains(extension)) {
      StaticInfo.showToast(context, 'Select file is not excel file');
      return;
    }

    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    dialog.show();

    var questions = List<Question>();

    var bytes = file.readAsBytesSync();
    var decoder = SpreadsheetDecoder.decodeBytes(bytes);
    for (var table in decoder.tables.values) {
      for (var row in table.rows) {
        var word = row[0];
        var correctAns = row[1];
        var answers = row
          ..removeAt(0)
          ..shuffle();

        questions.add(Question(
          id: Uuid().v1(),
          word: word as String,
          synonymOrAntonym: wordType,
          correctAnswer: answers.indexWhere((element) => element == correctAns),
          answers: List<String>.from(answers),
        ));
      }
    }

    for (var question in questions)
      await Firestore.instance
          .collection(Keys.questions)
          .document(question.id)
          .setData(question.toMap());

    dialog.hide();

    Navigator.pop(context);

  }
}