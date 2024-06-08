import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/domain/entity/group.dart';

class GroupFormWidgetModel extends ChangeNotifier {
  var groupName = '';
  void saveGroup(BuildContext context) async {
    if (groupName.isEmpty) {
      return;
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('groups_box');
    final group = Group(name: groupName);
    await box.add(group);
    if (context.mounted) Navigator.of(context).pop();
    notifyListeners();
  }
}
