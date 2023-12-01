import 'package:flutter/material.dart';
import 'dart:async';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key, required this.onClickAddButton});

  final Future<void> Function(String) onClickAddButton;

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('アイテムを追加'),
            TextField(
              controller: textEditingController,
              autofocus: true,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('閉じる')),
                const SizedBox(width: 15),
                FilledButton(
                    onPressed: () async {
                      await widget.onClickAddButton(textEditingController.text);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('追加'))
              ],
            ),
          ],
        ));
  }
}
