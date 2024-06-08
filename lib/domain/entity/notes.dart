import 'package:hive_flutter/adapters.dart';

part 'notes.g.dart';

@HiveType(typeId: 2)
class Note extends HiveObject {
  @HiveField(0)
  String name;
  Note({required this.name});
}
