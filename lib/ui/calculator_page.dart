import 'package:discount_calculator/ui/result_page.dart';
import 'package:discount_calculator/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/calculator_view_model.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _priceController;
  late TextEditingController _discountController;
  late TextEditingController _maxDiscountPriceController;

  static List<String?> productPrices = [null];
  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController();
    _discountController = TextEditingController();
    _maxDiscountPriceController = TextEditingController();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _discountController.dispose();
    _maxDiscountPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: primaryColor,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Discount Percentage',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      // name textfield
                      TextFormField(
                          controller: _discountController,
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter your discount percentage',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ),
                          ),
                          maxLength: 3,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          validator: (v) {
                            if (v == null) return 'Please enter something';
                            if (v.length > 3)
                              return "Please input correct type";
                            if (v.isEmpty) return 'Please enter something';
                            if (int.parse(v) > 100)
                              return 'Please input discount in range 0 - 100';
                            return null;
                          }),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        'Max Discount in Rp (fill 0 if the discount doesnt have max price)',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      // name textfield
                      TextFormField(
                          controller: _maxDiscountPriceController,
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter your discount percentage',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          validator: (v) {
                            if (v == null) return 'Please enter something';
                            if (v.isEmpty) return 'Please enter something';
                            return null;
                          }),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Add Product Prices',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
              ..._getFriends(),
              const SizedBox(
                height: 10,
              ),
              Consumer<CalculatorProvider>(
                builder: (context, provider, _) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        double discount =
                            double.parse(_discountController.text);
                        double maxDiscountPrice =
                            double.parse(_maxDiscountPriceController.text);
                        provider.calculate(
                            productPrices, discount, maxDiscountPrice);
                        setState(() {
                          productPrices.clear();
                          productPrices.add(null);
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ResultPage()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please fill required data")));
                      }
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      width: double.infinity,
                      child: const Center(
                        child: Text(
                          'Calculates',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getFriends() {
    List<Widget> friendsTextFieldsList = [];
    for (int i = 0; i < productPrices.length; i++) {
      friendsTextFieldsList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(
                child: ProductPriceTextfield(
              index: i,
            )),
            const SizedBox(
              width: 16,
            ),
            // we need add button at last friends row only
            _addRemoveButton(i == productPrices.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFieldsList;
  }

  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          productPrices.insert(0, null);
        } else {
          productPrices.removeAt(index);
        }
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: (add) ? primaryColor : Colors.red,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          add ? "Add Product" : "Remove Product",
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ProductPriceTextfield extends StatefulWidget {
  final int index;
  const ProductPriceTextfield({super.key, required this.index});

  @override
  State<ProductPriceTextfield> createState() => _ProductPriceTextfieldState();
}

class _ProductPriceTextfieldState extends State<ProductPriceTextfield> {
  late TextEditingController _priceController;
  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _priceController.text =
          _CalculatorPageState.productPrices[widget.index] ?? '';
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Product ${widget.index + 1}",
            style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
          TextFormField(
            controller:
                _priceController, // save text field data in friends list at index
            // whenever text field value changes
            onChanged: (v) =>
                _CalculatorPageState.productPrices[widget.index] = v,
            textInputAction: TextInputAction.done,
            decoration:
                const InputDecoration(hintText: 'Enter your product price'),
            keyboardType: const TextInputType.numberWithOptions(
                signed: false, decimal: false),
            validator: (v) {
              if (v == null) return 'Please enter something';
              if (v.isEmpty) return 'Please enter something';
              return null;
            },
          ),
        ],
      ),
    );
  }
}
