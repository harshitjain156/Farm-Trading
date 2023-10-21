import 'package:agro_millets/models/millet_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/order_item.dart';

final homeProvider =
    ChangeNotifierProvider<HomeProvider>((ref) => HomeProvider());

class HomeProvider extends ChangeNotifier {
  List<MilletItem> _items = [];
  List<MilletOrder> _itemOrder = [];
  List<MilletOrder> _deliveryOrder = [];

  List<MilletItem> getItems() => [..._items];
  List<MilletOrder> getAllOrders() => [..._itemOrder];
  List<MilletOrder> getAllDeliveries() => [..._deliveryOrder];
  List<Map<String,String>> getItemsCategories() => [{'vegetables': 'VEGETABLES'},
    {'fruits': 'FRUITS'},
    {'cereals': 'CEREALS'},
    {'livestock': 'LIVE STOCKS'},
    {'oil': 'OIL SEEDS'},
    {'pulses': 'PULSES'},
    {'cash': 'CASH CROP'},];
  List<Map<String,String>> getQuantityTypes() => [{'kg': 'K.G'},
    {'litre': 'Litre'},
    {'count': 'Count'},
   ];
  void updateItems(List<MilletItem> items) {
    if (listEquals(items, _items)) return;
    _items = items;
    notifyListeners();
  }
  void updateItemOrder(List<MilletOrder> items) {
    if (listEquals(items, _itemOrder)) return;
    _itemOrder = items;
    notifyListeners();
  }
  void updateItemDeliveries(List<MilletOrder> items) {
    if (listEquals(items, _deliveryOrder)) return;
    _deliveryOrder = items;
    notifyListeners();
  }
}
