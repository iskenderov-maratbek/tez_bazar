import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/providers/providers.dart';

class ProductInfo extends ConsumerStatefulWidget {
  final int id;
  final String name;
  final double price;
  final String? photo;

  const ProductInfo({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    this.photo,
  });

  @override
  ConsumerState<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends ConsumerState<ProductInfo> {
  @override
  Widget build(BuildContext context) {
    final selectedProductData = ref.watch(selectedProductProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(10),
          child: text24bold(widget.name),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  // product.photo ??
                  'lib/assets/200.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            text18Bold('Продавец : ${selectedProductData?.seller}'),
            text16normal('Номер телефона: ${selectedProductData?.number}'),
            text16normal('Number: ${selectedProductData?.number}'),
            Card(
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text18Bold('Жондомо'),
                    text16normal('${selectedProductData?.description}'),
                  ],
                ),
              ),
            ),
            text16normal('Баасы: ${widget.price} сом'),
            text16normal('Товардын дареги: ${selectedProductData?.location}'),
            text18Bold(
                'Доставка: ${selectedProductData.delivery ? 'Бар' : 'Жок'}'),
          ],
        ),
      ),
    );
  }
}
