import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/domain/entity/group.dart';
import 'package:todo_app/domain/entity/notes.dart';

class NotesWidgetModel extends ChangeNotifier {
  int groupKey;
  late final Box<Group> groupBox;
  Group? group;
  var notes = <Note>[];
  NotesWidgetModel({required this.groupKey}) {
    setup();
  }

  void loadGroup() async {
    final box = groupBox;
    group = box.get(groupKey);
    notifyListeners();
  }

  void readTasks() {
    notes = group?.notes ?? <Note>[];
    notifyListeners();
  }

  void setupListenTasks() {
    final box = groupBox;
    readTasks();
    box.listenable(keys: <dynamic>[groupKey]).addListener(readTasks);
  }

  void deleteNote(int groupIndex) async {
    await group?.notes?.deleteFromHive(groupIndex);
    await group?.save();
  }

  void showForm(BuildContext context) {
    Navigator.pushNamed(context, 'groups/notes/form', arguments: groupKey);
  }

  void setup() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    groupBox = await Hive.openBox<Group>('groups_box');
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(NoteAdapter());
    }
    await Hive.openBox<Note>('notes_box');
    loadGroup();
    setupListenTasks();
  }
}

class NotesWidgetModelProvider extends InheritedNotifier {
  final NotesWidgetModel model;
  const NotesWidgetModelProvider(
      {super.key, required this.model, required super.child})
      : super(notifier: model);

  static NotesWidgetModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<NotesWidgetModelProvider>();
  }

  @override
  bool updateShouldNotify(NotesWidgetModelProvider oldWidget) {
    return true;
  }
}
