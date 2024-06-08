import 'package:hive/hive.dart';
import 'package:todo_app/domain/entity/notes.dart';

part 'group.g.dart';

@HiveType(typeId: 1)
class Group extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  HiveList<Note>? notes;

  Group({required this.name});

  void addTask(Box<Note> box, Note note) {
    notes ??= HiveList(box);
    notes?.add(note);
    save();
  }
}
