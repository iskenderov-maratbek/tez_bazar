// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:tez_bazar/services/providers.dart';

// class CustomBottomBar extends ConsumerStatefulWidget {
//   const CustomBottomBar({super.key});

//   @override
//   _CustomBottomBarState createState() => _CustomBottomBarState();
// }

// class _CustomBottomBarState extends ConsumerState<CustomBottomBar> {
//   @override
//   Widget build(BuildContext context) {
//     final currentIndex = ref.watch(currentIndexProvider);

//     return Scaffold(
//       body: _buildBody(currentIndex),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.symmetric(vertical: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             IconButton(
//               icon: Icon(Icons.home),
//               onPressed: () {
//                 ref.read(currentIndexProvider.notifier).state = 0;
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.search),
//               onPressed: () {
//                 ref.read(currentIndexProvider.notifier).state = 1;
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.add),
//               onPressed: () {
//                 ref.read(currentIndexProvider.notifier).state = 2;
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.notifications),
//               onPressed: () {
//                 ref.read(currentIndexProvider.notifier).state = 3;
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBody(int currentIndex) {
//     switch (currentIndex) {
//       case 0:
//         return Center(child: Text('Home Page'));
//       case 1:
//         return Center(child: Text('Search Page'));
//       case 2:
//         return Center(child: Text('Add Page'));
//       case 3:
//         return Center(child: Text('Notifications Page'));
//       default:
//         return Center(child: Text('Home Page'));
//     }
//   }
// }
