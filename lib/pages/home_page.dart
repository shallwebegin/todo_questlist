import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:todo_questlist/data/local_storage.dart';
import 'package:todo_questlist/helper/translation_helper.dart';
import 'package:todo_questlist/main.dart';
import 'package:todo_questlist/models/task_model.dart';
import 'package:todo_questlist/widgets/custom_search_delegate.dart';
import 'package:todo_questlist/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTaskts;
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTaskts = <Task>[];
    _getAllTaskFromdb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showBottomAddTask();
          },
          child: const Text(
            'title',
          ).tr(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage();
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showBottomAddTask();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _allTaskts.isNotEmpty
          ? ListView.builder(
              itemCount: _allTaskts.length,
              itemBuilder: (context, index) {
                var oAnkiListeElemani = _allTaskts[index];
                return Dismissible(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.delete),
                      const Text('remove_task').tr(),
                      const SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                  key: Key(oAnkiListeElemani.id),
                  onDismissed: (direction) {
                    _localStorage.deleteTask(task: oAnkiListeElemani);
                    setState(() {
                      _allTaskts.removeAt(index);
                    });
                  },
                  child: TaskListItem(task: oAnkiListeElemani),
                );
              },
            )
          : Center(
              child: const Text('empty_task_list').tr(),
            ),
    );
  }

  void _showBottomAddTask() {
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
              decoration: InputDecoration(
                  hintText: 'add_task'.tr(), border: InputBorder.none),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(
                    context,
                    locale: TranslationHelper.getDeviceLanguage(context),
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var yeniEklenecekGorev =
                          Task.create(name: value, createdAt: time);
                      await _localStorage.addTask(task: yeniEklenecekGorev);
                      _allTaskts.insert(0, yeniEklenecekGorev);

                      setState(() {});
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

  void _getAllTaskFromdb() async {
    _allTaskts = await _localStorage.getAllTask();
    setState(() {});
  }

  void _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTasks: _allTaskts));
    _getAllTaskFromdb();
  }
}
