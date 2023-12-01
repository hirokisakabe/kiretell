import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'shoppingItem.dart';

class ItemListWidget extends StatefulWidget {
  const ItemListWidget(
      {super.key,
      required this.shoppingItems,
      required this.onPressedEditButton,
      required this.onPressedDeleteButton,
      required this.onPressedCheckButton});

  final List<ShoppingItem> shoppingItems;
  final void Function(ShoppingItem) onPressedEditButton;
  final void Function(String) onPressedDeleteButton;
  final void Function(String, bool) onPressedCheckButton;

  @override
  State<ItemListWidget> createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(12.0),
        child: Column(
          children: (widget.shoppingItems)
              .map((item) => Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            widget.onPressedEditButton(item);
                          },
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: '編集',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            widget.onPressedDeleteButton(item.id);
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: '削除',
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => widget.onPressedCheckButton(
                                item.id, !item.needToBuy),
                            icon: item.needToBuy
                                ? const Icon(Icons.check_box_outline_blank)
                                : const Icon(Icons.check_box)),
                        Text(
                          item.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ));
  }
}
