import 'package:flutter/material.dart';
import 'package:kiretell/widget/edit_item_dialog.dart';
import 'package:logger/logger.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'add_item_dialog.dart';
import 'shopping_item_list.dart';
import '../model/shopping_item.dart';
import '../service/shopping_item_service.dart';

const uuid = Uuid();
var logger = Logger();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ShoppingItem> shoppingItems = [];

  var shoppingItemService = ShoppingItemService();

  void checkItem(String id, bool needToBuy) async {
    await shoppingItemService.updateShoppingItemToBuy(id, needToBuy);

    var items = await shoppingItemService.fetchShoppingItems();
    setState(() {
      shoppingItems = items;
    });
  }

  Future<void> addItem(String itemName) async {
    await shoppingItemService.insertShoppingItem(
        ShoppingItem(id: uuid.v4(), name: itemName, needToBuy: true));

    var items = await shoppingItemService.fetchShoppingItems();
    setState(() {
      shoppingItems = items;
    });
  }

  Future<void> editItem(ShoppingItem shoppingItem) async {
    await shoppingItemService.updateShoppingItem(shoppingItem);

    var items = await shoppingItemService.fetchShoppingItems();
    setState(() {
      shoppingItems = items;
    });
  }

  Future<void> deleteItem(String itemId) async {
    await shoppingItemService.deleteShoppingItem(itemId);

    var items = await shoppingItemService.fetchShoppingItems();
    setState(() {
      shoppingItems = items;
    });
  }

  Future<void> initShoppingItems() async {
    shoppingItems = await shoppingItemService.fetchShoppingItems();
  }

  void openEditItemDialog(ShoppingItem shoppingItemToEdit) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: EditItemDialog(
          onClickEditButton: editItem,
          shoppingItem: shoppingItemToEdit,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    shoppingItemService.initialize();

    initShoppingItems(); //不要かも
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Kiretell'),
            bottom: const TabBar(
              tabs: [
                Tab(text: "買う物リスト"),
                Tab(text: "すべて"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FutureBuilder(
                future: initShoppingItems(),
                builder: (var context, var snapshot) {
                  if (snapshot.hasError) {
                    logger.e(snapshot.error);
                    return const Text("エラーが発生しました");
                  }

                  return ShoppingItemList(
                    shoppingItems:
                        shoppingItems.where((item) => item.needToBuy).toList(),
                    onPressedEditButton: openEditItemDialog,
                    onPressedDeleteButton: deleteItem,
                    onPressedCheckButton: checkItem,
                  );
                },
              ),
              FutureBuilder(
                future: initShoppingItems(),
                builder: (var context, var snapshot) {
                  if (snapshot.hasError) {
                    logger.e(snapshot.error);
                    return const Text("エラーが発生しました");
                  }

                  return ShoppingItemList(
                    shoppingItems: shoppingItems,
                    onPressedEditButton: openEditItemDialog,
                    onPressedDeleteButton: deleteItem,
                    onPressedCheckButton: checkItem,
                  );
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) =>
                  Dialog(child: AddItemDialog(onClickAddButton: addItem)),
            ),
            foregroundColor: colorScheme.primary,
            backgroundColor: colorScheme.surface,
            child: const Icon(Icons.add),
          ),
        ));
  }
}
