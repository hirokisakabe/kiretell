import 'package:flutter/material.dart';
import 'package:kiretell/edit_item_dialog.dart';
import 'package:logger/logger.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'add_item_dialog.dart';
import 'item_list.dart';
import 'shoppingItem.dart';
import 'shopping_item_db.dart';

var uuid = Uuid();
var logger = Logger();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Kiretell', home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ShoppingItem> shoppingItems = [];

  var shoppingItemDB = ShoppingItemDB();

  void checkItem(String id, bool needToBuy) async {
    await shoppingItemDB.updateShoppingItemToBuy(id, needToBuy);

    var items = await shoppingItemDB.fetchShoppingItems();
    setState(() {
      shoppingItems = items;
    });
  }

  Future<void> addItem(String itemName) async {
    await shoppingItemDB.insertShoppingItem(
        ShoppingItem(id: uuid.v4(), name: itemName, needToBuy: true));

    var items = await shoppingItemDB.fetchShoppingItems();
    setState(() {
      shoppingItems = items;
    });
  }

  Future<void> editItem(ShoppingItem shoppingItem) async {
    await shoppingItemDB.updateShoppingItem(shoppingItem);

    var items = await shoppingItemDB.fetchShoppingItems();
    setState(() {
      shoppingItems = items;
    });
  }

  Future<void> deleteItem(String itemId) async {
    await shoppingItemDB.deleteShoppingItem(itemId);

    var items = await shoppingItemDB.fetchShoppingItems();
    setState(() {
      shoppingItems = items;
    });
  }

  Future<void> initShoppingItems() async {
    shoppingItems = await shoppingItemDB.fetchShoppingItems();
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
    shoppingItemDB.initialize();

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

                  return ItemListWidget(
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

                  return ItemListWidget(
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
