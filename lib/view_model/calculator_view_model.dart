import 'package:flutter/material.dart';

class CalculatorProvider extends ChangeNotifier {
  double _total = 0.0;
  double get total => _total;

  double _totalAfterDiscount = 0.0;
  double get totalAfterDiscount => _totalAfterDiscount;

  final List<double> _listProductDiscount = [];
  List<double> get listProductDiscount => _listProductDiscount;

  final List<double> _listPercentageDiscount = [];
  List<double> get listPercentageDiscount => _listPercentageDiscount;

  final List<double> _listRealPrice = [];
  List<double> get listRealPrice => _listRealPrice;

  void calculate(
      List<String?> listProductPrice, double discount, double maxDiscount) {
    _listPercentageDiscount.clear();
    _listProductDiscount.clear();
    _listRealPrice.clear();
    _total = 0.0;
    _totalAfterDiscount = 0.0;
    for (String? val in listProductPrice) {
      if (val != null) {
        _total += double.parse(val);
      }
    }
    double discountPrice = total * discount / 100;
    if (discountPrice >= maxDiscount && maxDiscount != 0) {
      discountPrice = maxDiscount;
    }
    var afterDiscountPrice = total - discountPrice;
    _totalAfterDiscount = afterDiscountPrice;
    for (String? productPrice in listProductPrice) {
      if (productPrice != null) {
        double price = double.parse(productPrice);
        double discountPercentProduct = (price / total) * 100;
        double discountPerProduct =
            discountPercentProduct * afterDiscountPrice / 100;
        _listRealPrice.add(double.parse(productPrice));
        _listPercentageDiscount.add(discountPercentProduct);
        _listProductDiscount.add(discountPerProduct);
      }
    }
    notifyListeners();
  }
}
