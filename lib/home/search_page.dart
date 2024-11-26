import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/services/providers.dart';

final List<String> entries = <String>['A', 'B', 'C'];
final List<int> colorCodes = <int>[600, 500, 100];

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends ConsumerState<SearchPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    ref.read(categoryProvider.notifier).fetchCategory();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(categoryProvider.notifier).fetchCategory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(categoryProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GridView.builder(
        controller: _scrollController,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ElevatedButton(
            onPressed: () {
              ref.read(productProvider.notifier).searchProducts(product.id);
              ref.read(gridViewStateProvider.notifier).state = false;
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.all(5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.amber[colorCodes[index % colorCodes.length]],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      product.photo ?? 'lib/assets/200.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Количество',
                          textAlign: TextAlign.end,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '${product.pieces} шт.',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Количество столбцов
          crossAxisSpacing: 0, // Отступ между столбцами
          mainAxisSpacing: 0, // Отступ между строками
          childAspectRatio: 0.7, // Соотношение сторон элементов
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
