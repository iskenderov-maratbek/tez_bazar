import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/providers/providers.dart';

final List<String> entries = <String>['A', 'B', 'C'];
final List<int> colorCodes = <int>[600, 500, 100];

// class GridGen extends ConsumerStatefulWidget {
//   const GridGen({super.key});

//   @override
//   ConsumerState<GridGen> createState() => _GridGenState();
// }

// class _GridGenState extends ConsumerState<GridGen> {
//   @override
//   Widget build(BuildContext context) {
//     print('object');
//     return GridView.builder(
//       padding: const EdgeInsets.all(8),
//       itemCount: entries.length,
//       itemBuilder: (BuildContext context, int index) {
//         return GestureDetector(
//           onTap: () {
//             print('Tapped on entry ${entries[index]}');
//           },
//           child: Container(
//             height: 50,
//             color: Colors.amber[colorCodes[index]],
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Center(child: Text('Entry ${entries[index]}')),
//               ],
//             ),
//           ),
//         );
//       },
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         mainAxisSpacing: 15,
//         crossAxisSpacing: 15,
//         crossAxisCount: 2,
//       ),
//     );
//   }
// }

class CategoryPage extends ConsumerStatefulWidget {
  const CategoryPage({super.key});

  @override
  CategoryPageState createState() => CategoryPageState();
}

class CategoryPageState extends ConsumerState<CategoryPage> {
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
