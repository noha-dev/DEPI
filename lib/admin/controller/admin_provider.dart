import 'package:flutter/material.dart';

class TabProvider with ChangeNotifier {
  
  int? _selectedIndex;
  final Map<int,int> _orderRating = {};
  int? get selectedIndex => _selectedIndex;
  
  void selectTab(int index) {
    if (_selectedIndex == index) return;
    _selectedIndex = index;
    notifyListeners();
  }
void setRating(int orderId, int rating) {
    _orderRating[orderId] = rating;
    notifyListeners();
  }
  int? getRating(int orderId) {
    return _orderRating[orderId];
  }
  bool hasOrderReview(int orderId) {
    return _orderRating.containsKey(orderId);
  }
  
}
