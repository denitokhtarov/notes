import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/domain/entity/group.dart';
import 'package:todo_app/domain/entity/notes.dart';
import 'package:todo_app/themes/theme_checker.dart';
import 'package:todo_app/ui_elements/cupertino_app_bar.dart';
import 'package:todo_app/widgets/notes/notes_widget_model.dart';

class NotesWidget extends StatefulWidget {
  const NotesWidget({super.key});

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  NotesWidgetModel? _model;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_model == null) {
      final groupKey = ModalRoute.of(context)!.settings.arguments as int;
      _model = NotesWidgetModel(groupKey: groupKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = _model;

    return NotesWidgetModelProvider(
      model: _model!,
      child: NotesWidgetBody(model: model!),
    );
  }
}

class NotesWidgetBody extends StatelessWidget {
  final NotesWidgetModel model;
  const NotesWidgetBody({
    required this.model,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotesWidgetModelProvider.of(context)?.model;

    String notesCountTranslation(int? length) {
      switch (length!) {
        case 1:
          return '$length заметка';
        case 2:
        case 3:
        case 4:
          return '$length заметки';
        case > 4:
          return '$length заметок';
        default:
          return 'Нет заметок';
      }
    }

    return Scaffold(
      body: CupertinoPageScaffold(
        child: CupertinoAppBar(
          padding: 15,
          previousPageTitle: 'Папки',
          largeTitle: 'Заметки',
          button: CupertinoButton(
              child: const Icon(
                CupertinoIcons.ellipsis_circle,
                color: CupertinoColors.systemYellow,
              ),
              onPressed: () {}),
          body: Column(
            children: [
              CupertinoSearchTextField(
                onSubmitted: (String value) {},
                placeholder: 'Поиск',
              ),
              const SizedBox(height: 20),
              const NoteListWidget(),
            ],
          ),
        ),
      ),
      bottomSheet: DecoratedBox(
        decoration: BoxDecoration(
          color: isDarkTheme(context)
              ? Colors.black
              : CupertinoColors.secondarySystemBackground,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 0, bottom: 20),
          child: Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        '     ${notesCountTranslation(model?.notes.length)}',
                        style: TextStyle(
                            fontSize: 12,
                            color: isDarkTheme(context)
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                    IconButton(
                      onPressed: () => model?.showForm(context),
                      icon: const Icon(CupertinoIcons.square_pencil),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NoteListWidget extends StatelessWidget {
  const NoteListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final notesCount =
        NotesWidgetModelProvider.of(context)?.model.notes.length ?? 0;
    return Container(
      decoration: BoxDecoration(
        color: groupListWidgetBackgroundColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: notesCount,
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
          return NoteListRowWidget(
            index: index,
          );
        },
      ),
    );
  }
}

class NoteListRowWidget extends StatelessWidget {
  final int index;
  const NoteListRowWidget({super.key, required this.index});

  void showNote(BuildContext context, String noteText) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(NoteAdapter());
    }

    if (context.mounted) {
      Navigator.pushNamed(context, 'groups/notes/detail', arguments: noteText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = NotesWidgetModelProvider.of(context)!.model;
    final note = model.notes[index];

    BorderRadius borderRadius = model.notes.length == 1
        ? const BorderRadius.only(
            topRight: Radius.circular(12), bottomRight: Radius.circular(12))
        : model.notes[index] == model.notes.first
            ? const BorderRadius.only(topRight: Radius.circular(12))
            : model.notes[index] == model.notes.last
                ? const BorderRadius.only(bottomRight: Radius.circular(12))
                : BorderRadius.circular(0);
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => model.deleteNote(index),
            backgroundColor: Colors.red,
            borderRadius: borderRadius,
            icon: CupertinoIcons.delete,
            autoClose: true,
          )
        ],
      ),
      child: CupertinoListTile(
        onTap: () => showNote(context, note.name),
        leading: const Icon(
          CupertinoIcons.folder,
          color: CupertinoColors.systemYellow,
        ),
        title: Text(note.name),
        trailing: const Icon(
          CupertinoIcons.chevron_right,
          size: 16,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }
}
