import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/themes/theme_checker.dart';
import 'package:todo_app/widgets/group_form/group_form_widget_model.dart';

class GroupFormWidget extends StatelessWidget {
  const GroupFormWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showCupertinoPopUp(context),
      icon: const Icon(CupertinoIcons.folder_badge_plus),
      color: CupertinoColors.systemYellow,
    );
  }
}

Future<dynamic> showCupertinoPopUp(BuildContext context) {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoPopupSurface(
        child: Container(
          color: isDarkTheme(context)
              ? CupertinoColors.darkBackgroundGray
              : CupertinoColors.secondarySystemBackground,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                        child: const Text(
                          'Отменить',
                          style: TextStyle(color: CupertinoColors.systemYellow),
                        ),
                        onPressed: () => Navigator.of(context).pop()),
                    const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Text(
                        'Новая папка',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    CupertinoButton(
                      child: const Text(
                        'Готово',
                        style: TextStyle(color: CupertinoColors.systemYellow),
                      ),
                      onPressed: () => Provider.of<GroupFormWidgetModel>(
                              context,
                              listen: false)
                          .saveGroup(context),
                    )
                  ],
                ),
              ),
              const GroupFormWidgetTextField(),
            ],
          ),
        ),
      );
    },
  );
}

class GroupFormWidgetTextField extends StatelessWidget {
  const GroupFormWidgetTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GroupFormWidgetModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CupertinoTextField(
        onEditingComplete: () => model.saveGroup(context),
        onChanged: (value) => model.groupName = value,
        autofocus: true,
        placeholder: 'Имя группы',
        decoration: BoxDecoration(
          color:
              isDarkTheme(context) ? CupertinoColors.systemGrey5 : Colors.white,
          border: const Border(),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
