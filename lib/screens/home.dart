import 'package:flutter/material.dart';
import 'package:sqflitecrud/database/sqlHelper.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final title = TextEditingController();
  final description = TextEditingController();
  List<Map<String, dynamic>> _datas = [];
  bool _isLoading = true;
  void _refreshdata() async {
    final data = await SQLHelper.getItem();
    setState(() {
      _datas = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshdata();
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingData = _datas.firstWhere((element) => element['id'] == id);
      title.text = existingData['title']; //Textediting controller
      description.text = existingData['description'];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text('TODO'),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 160),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              addItem();
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Card(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.yellowAccent,
                child: ListTile(
                  title: Text(items[index]['title'] as String),
                  subtitle: Text(items[index]['note']),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void addItem() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Notes'),
          actions: [
            TextField(
              controller: title,
              decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.blue[100]),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: note,
              decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.blue[100]),
            ),
            Row(
              children: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    items.add({'title': title.text, 'note': note.text});
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
