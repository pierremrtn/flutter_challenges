import 'package:flutter/material.dart';

class Item with ChangeNotifier {
  final String firstName;
  final String lastName;
  final String asset;
  final int money;

  Offset? dropFirstNameOffset;
  Offset? dropLastNameOffset;
  Offset? dropAvatarOffset;
  Offset? cardOffset;
  Size? cardSize;

  void setDropOffsets({
    required Offset dropOffset,
    required Offset dropFirstNameOffset,
    required Offset dropLastNameOffset,
    required Offset dropAvatarOffset,
    required Size cardSize,
  }) {
    cardOffset = dropOffset;
    this.dropFirstNameOffset = dropFirstNameOffset;
    this.dropLastNameOffset = dropLastNameOffset;
    this.dropAvatarOffset = dropAvatarOffset;
    this.cardSize = cardSize;
    notifyListeners();
  }

  Item({
    required this.asset,
    required this.money,
    required this.firstName,
    required this.lastName,
  });
}

final _items = [
  Item(
    firstName: "Ian",
    lastName: "Hickson",
    asset: 'ian_hickson.png',
    money: 60,
  ),
  Item(
    firstName: "Eric",
    lastName: "Seidel",
    asset: 'eric_seidel.jpg',
    money: 50,
  ),
  Item(
    firstName: "Adam",
    lastName: "Barth",
    asset: 'adam_barth.jpg',
    money: 60,
  ),
  Item(
      firstName: "Filip",
      lastName: "Hráček",
      asset: 'filip_hracek.jpg',
      money: 40),
];

class ListVM extends ChangeNotifier {
  final List<Item> itemBank = [
    ..._items,
  ];
  final List<Item> selectedItems = [];

  void selectItem(Item item) {
    itemBank.remove(item);
    selectedItems.insert(0, item);
    notifyListeners();
  }

  void reset() {
    itemBank.clear();
    selectedItems.clear();
    itemBank.addAll(_items);
    notifyListeners();
  }
}
