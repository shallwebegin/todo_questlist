import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_questlist/models/task_model.dart';

class TaskListItem extends StatefulWidget {
  TaskListItem({super.key, required this.task});

  Task task;

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  final TextEditingController _taskNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _taskNameController.text = widget.task.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            setState(() {
              widget.task.isCompleted = !widget.task.isCompleted;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: widget.task.isCompleted ? Colors.green : Colors.white,
                border: Border.all(color: Colors.grey, width: 0.8),
                shape: BoxShape.circle),
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                controller: _taskNameController,
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(border: InputBorder.none),
                onSubmitted: (value) {
                  setState(() {
                    if (value.length > 3) {
                      widget.task.name = value;
                    }
                  });
                },
              ),
        trailing: Text(
          DateFormat('hh:mm a').format(widget.task.createdAt),
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
