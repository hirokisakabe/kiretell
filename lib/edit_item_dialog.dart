import 'package:flutter/material.dart';
import 'dart:async';
import 'package:kiretell/shoppingItem.dart';

class EditItemDialog extends StatefulWidget {
  const EditItemDialog(
      {super.key, required this.shoppingItem, required this.onClickEditButton});

  final ShoppingItem shoppingItem;
  final Future<void> Function(ShoppingItem) onClickEditButton;

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();

    textEditingController =
        TextEditingController(text: widget.shoppingItem.name);
  }

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
            const Text('アイテムを編集'),
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
                      var newItem = ShoppingItem(
                        id: widget.shoppingItem.id,
                        name: textEditingController.text,
                        needToBuy: widget.shoppingItem.needToBuy,
                      );
                      await widget.onClickEditButton(newItem);
                      Navigator.pop(context);
                    },
                    child: const Text('完了'))
              ],
            ),
          ],
        ));
  }
}
