import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskForm extends StatefulWidget {
  final Task? initialData;
  final Function(Task) onSubmit;

  const TaskForm({
    Key? key,
    this.initialData,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _taskController;
  late TextEditingController _learnedController;
  late TextEditingController _conclusionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialData?.title ?? '');
    _dateController = TextEditingController(
      text: widget.initialData?.date ?? DateTime.now().toIso8601String().split('T')[0],
    );
    _taskController = TextEditingController(text: widget.initialData?.task ?? '');
    _learnedController = TextEditingController(text: widget.initialData?.learned ?? '');
    _conclusionController = TextEditingController(text: widget.initialData?.conclusion ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _taskController.dispose();
    _learnedController.dispose();
    _conclusionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_dateController.text) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final task = Task(
          id: widget.initialData?.id,
          title: _titleController.text,
          date: _dateController.text,
          task: _taskController.text,
          learned: _learnedController.text,
          conclusion: _conclusionController.text,
        );
        await widget.onSubmit(task);
        Navigator.pop(context);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dateController,
            decoration: InputDecoration(
              labelText: 'Date',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ),
            readOnly: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a date';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _taskController,
            decoration: const InputDecoration(
              labelText: 'Task Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a task description';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _learnedController,
            decoration: const InputDecoration(
              labelText: 'What You Learned',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter what you learned';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _conclusionController,
            decoration: const InputDecoration(
              labelText: 'Conclusion',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a conclusion';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.initialData != null ? 'Update Task' : 'Create Task'),
          ),
        ],
      ),
    );
  }
}