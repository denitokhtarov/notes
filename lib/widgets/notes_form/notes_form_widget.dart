import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/themes/theme_checker.dart';
import 'package:todo_app/widgets/notes_form/notes_form_widget_model.dart';

class NotesFormWidget extends StatefulWidget {
  const NotesFormWidget({super.key});

  @override
  State<NotesFormWidget> createState() => _NotesFormWidgetState();
}

class _NotesFormWidgetState extends State<NotesFormWidget> {
  NotesFormWidgetModel? _model;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_model == null) {
      final groupKey = ModalRoute.of(context)!.settings.arguments as int;
      _model = NotesFormWidgetModel(groupKey: groupKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotesFormWidgetModelProvider(
      model: _model!,
      child: const TextFormWidget(),
    );
  }
}

class TextFormWidget extends StatelessWidget {
  const TextFormWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotesFormWidgetModelProvider.of(context)?.model;
    return CupertinoPageScaffold(
      backgroundColor: isDarkTheme(context) ? Colors.black : Colors.white,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            alwaysShowMiddle: true,
            previousPageTitle: 'ds',
            largeTitle: const Text(''),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text(
                'Готово',
                style: TextStyle(color: CupertinoColors.systemYellow),
              ),
              onPressed: () => model?.saveNote(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CupertinoTextField(
                autofocus: true,
                maxLines: null,
                minLines: null,
                expands: true,
                decoration: const BoxDecoration(),
                onChanged: (value) => model?.noteText = value,
                onEditingComplete: () => model?.saveNote(context),
              ),
            ),
          )
        ],
      ),
    );
  }
}
