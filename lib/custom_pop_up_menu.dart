// import 'package:flutter/material.dart';

// class CustomPopUpMenu extends StatefulWidget {
//   const CustomPopUpMenu({super.key});

//   @override
//   State<CustomPopUpMenu> createState() => _CustomPopUpMenu();
// }

// class _CustomPopUpMenu extends State<CustomPopUpMenu> {
//   final List<String> popList = ['ROHIT', 'REKHA', 'DHRUV'];

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton(
//         icon: const Icon(
//           Icons.more_horiz_rounded,
//           size: 30,
//         ),
//         color: Colors.transparent,
//         constraints: BoxConstraints.expand(
//           width: 200,
//           height: (popList.length + 1) * 40,
//         ),
//         surfaceTintColor: Colors.transparent,
//         shadowColor: Colors.transparent,
//         itemBuilder: (BuildContext context) {
//           return List.generate(
//             popList.length,
//             (index) => PopupMenuItem(
//               padding: const EdgeInsets.all(0),
//               value: 1,
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: 
//               ),
//             ),
//           );
//         });
//   }
// }
