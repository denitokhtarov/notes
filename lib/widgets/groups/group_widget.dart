import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/domain/entity/group.dart';
import 'package:todo_app/themes/theme_checker.dart';
import 'package:todo_app/ui_elements/cupertino_app_bar.dart';
import 'package:todo_app/widgets/group_form/group_form_widget.dart';
import 'package:todo_app/widgets/groups/groups_widget_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GroupWidget extends StatelessWidget {
  const GroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        child: CupertinoAppBar(
          padding: 15,
          previousPageTitle: '',
          largeTitle: 'Папки',
          button: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text(
              'Править',
              style: TextStyle(
                color: CupertinoColors.systemYellow,
              ),
            ),
            onPressed: () {},
          ),
          body: Column(
            children: [
              CupertinoSearchTextField(
                onSubmitted: (String value) {},
                placeholder: 'Поиск',
              ),
              const SizedBox(height: 20),
              const GroupListWidget(),
            ],
          ),
        ),
      ),
      bottomSheet: const BottomSheetWidget(),
    );
  }
}

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({
    super.key,
  });

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  String foldersCountTranslation(int length) {
    switch (length) {
      case 1:
        return '$length папка';
      case 2:
      case 3:
      case 4:
        return '$length папки';
      case > 4:
        return '$length папок';
      default:
        return 'Нет папок';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: isDarkTheme(context)
              ? Colors.black
              : CupertinoColors.secondarySystemBackground,
          borderRadius: BorderRadius.circular(0)),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: Row(
          children: [
            const GroupFormWidget(),
            const Spacer(),
            Text(
              foldersCountTranslation(
                  Provider.of<GroupsWidgetModel>(context).groups.length),
              style: TextStyle(
                  color: isDarkTheme(context) ? Colors.white : Colors.black),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class GroupListWidget extends StatelessWidget {
  const GroupListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final groupsCount = Provider.of<GroupsWidgetModel>(context).groups.length;
    return Container(
      decoration: BoxDecoration(
        color: groupListWidgetBackgroundColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: groupsCount,
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Container(
              height: 0.1,
              color: CupertinoColors.systemGrey,
            ),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return GroupListRowWidget(
            index: index,
          );
        },
      ),
    );
  }
}

class GroupListRowWidget extends StatelessWidget {
  final int index;
  const GroupListRowWidget({super.key, required this.index});

  void showNotes(BuildContext context, int groupIndex) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('groups_box');
    final groupKey = box.keyAt(groupIndex) as int;
    if (context.mounted) {
      Navigator.pushNamed(context, 'groups/notes', arguments: groupKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final group = Provider.of<GroupsWidgetModel>(context).groups;
    BorderRadius borderRadius = group.length == 1
        ? const BorderRadius.only(
            topRight: Radius.circular(12), bottomRight: Radius.circular(12))
        : group[index] == group.first
            ? const BorderRadius.only(topRight: Radius.circular(12))
            : group[index] == group.last
                ? const BorderRadius.only(bottomRight: Radius.circular(12))
                : BorderRadius.circular(0);
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) =>
                Provider.of<GroupsWidgetModel>(context, listen: false)
                    .delete(index),
            backgroundColor: Colors.red,
            borderRadius: borderRadius,
            icon: CupertinoIcons.delete,
            autoClose: true,
          )
        ],
      ),
      child: CupertinoListTile(
        onTap: () => showNotes(context, index),
        leading: const Icon(
          CupertinoIcons.folder,
          color: CupertinoColors.systemYellow,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(group[index].name),
            const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Text(
                '',
                style: TextStyle(color: CupertinoColors.systemGrey2),
              ),
            )
          ],
        ),
        trailing: const Icon(
          CupertinoIcons.chevron_right,
          size: 16,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }
}
