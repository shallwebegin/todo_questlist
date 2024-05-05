import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:todo_questlist/models/task_model.dart';
import 'package:todo_questlist/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTaskts;
  @override
  void initState() {
    super.initState();
    _allTaskts = <Task>[];
    _allTaskts.add(Task.create(name: 'Deneme Task', createdAt: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showBottomAddTask(context);
          },
          child: const Text(
            'Bugün Neler Yapıcaksın ?',
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showBottomAddTask(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _allTaskts.isNotEmpty
          ? ListView.builder(
              itemCount: _allTaskts.length,
              itemBuilder: (context, index) {
                var _oAnkiListeElemani = _allTaskts[index];
                return Dismissible(
                  background: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete),
                      Text('Bu Gorev Silindi'),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                  key: Key(_oAnkiListeElemani.id),
                  onDismissed: (direction) {
                    setState(() {
                      _allTaskts.removeAt(index);
                    });
                  },
                  child: TaskListItem(task: _oAnkiListeElemani),
                );
              },
            )
          : const Center(
              child: Text('Hadi Görev Ekle'),
            ),
    );
  }

  void _showBottomAddTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autocorrect: true,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                  hintText: 'Görev Nedir?', border: InputBorder.none),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(
                    context,
                    showSecondsColumn: false,
                    onConfirm: (time) {
                      var yeniEklenecekGorev =
                          Task.create(name: value, createdAt: time);
                      setState(() {
                        _allTaskts.add(yeniEklenecekGorev);
                      });
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
