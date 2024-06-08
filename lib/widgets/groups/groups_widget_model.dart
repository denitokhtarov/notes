import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/domain/entity/group.dart';

class GroupsWidgetModel extends ChangeNotifier {
  var groups = <Group>[];

  GroupsWidgetModel() {
    setup();
  }

  void delete(int index) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('groups_box');
    await box.deleteAt(index);
  }

  void readGroupsFromHive(Box<Group> box) {
    groups = box.values.toList();
    notifyListeners();
  }

  void setup() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('groups_box');
    readGroupsFromHive(box);
    box.listenable().addListener(() => readGroupsFromHive(box));
  }
}
