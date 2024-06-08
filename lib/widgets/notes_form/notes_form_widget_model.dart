import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/domain/entity/group.dart';
import 'package:todo_app/domain/entity/notes.dart';

class NotesFormWidgetModel extends ChangeNotifier {
  int groupKey;
  var noteText = '';
  NotesFormWidgetModel({required this.groupKey});

  void saveNote(BuildContext context) async {
    if (noteText.isEmpty) {
      return;
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(NoteAdapter());
    }
    final notesBox = await Hive.openBox<Note>('notes_box');
    final note = Note(name: noteText);
    await notesBox.add(note);

    final groupBox = await Hive.openBox<Group>('groups_box');
    final group = groupBox.get(groupKey);
    group?.addTask(notesBox, note);

    if (context.mounted) Navigator.of(context).pop();
  }
}

class NotesFormWidgetModelProvider extends InheritedWidget {
  final NotesFormWidgetModel model;
  const NotesFormWidgetModelProvider(
      {super.key, required this.model, required super.child});

  static NotesFormWidgetModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<NotesFormWidgetModelProvider>();
  }

  @override
  bool updateShouldNotify(NotesFormWidgetModelProvider oldWidget) {
    return false;
  }
}
