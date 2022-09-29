import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../view_model/calculator_view_model.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final currencyFormatter =
      NumberFormat.currency(locale: 'ID', symbol: "Rp ", decimalDigits: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Consumer<CalculatorProvider>(
                builder: (context, provider, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Discount Result / Product",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Total Before Discount: ${currencyFormatter.format(provider.total)}",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Total After Discount: ${currencyFormatter.format(provider.totalAfterDiscount)}",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: Consumer<CalculatorProvider>(
              builder: (context, provider, _) => ListView.builder(
                  itemCount: provider.listProductDiscount.length,
                  itemBuilder: (context, index) {
                    int? realPrice = (provider.listRealPrice[index]).round();
                    int? data = (provider.listProductDiscount[index]).round();
                    String? percentage =
                        (provider.listPercentageDiscount[index])
                            .round()
                            .toString();
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                spreadRadius: 4,
                                blurRadius: 40,
                                offset: const Offset(0, 16)),
                          ],
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Product ${index + 1}"),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  "Before discount ${currencyFormatter.format(realPrice)}",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 14)),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                "After discount ${currencyFormatter.format(data)}",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ],
      )),
    );
  }
}
