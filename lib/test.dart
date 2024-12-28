// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// Future<List<Todo>> fetchTodos() async {
//   // Пример данных
//   final List<Map<String, dynamic>> responseData = [
//     {'name': 'Задача 1', 'description': 'Описание 1', 'status': 'active'},
//     {'name': 'Задача 2', 'description': 'Описание 2', 'status': 'inactive'},
//     // Добавьте больше данных по необходимости
//   ];

//   return responseData.map((data) => Todo.fromJson(data)).toList();
// }
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // Провайдер для списка задач
// final todosProvider = FutureProvider<List<Todo>>((ref) async {
//   return fetchTodos();
// });

// // Провайдер для активного сегмента
// final segmentProvider = StateProvider<String>((ref) => 'active');

// // Разделение задач на активные и неактивные
// final categorizedTodosProvider = Provider<Map<String, List<Todo>>>((ref) {
//   final todos = ref.watch(todosProvider).maybeWhen(
//         data: (todos) => todos,
//         orElse: () => [],
//       );

//   final Map<String, List<Todo>> categorizedTodos = {
//     'active': [],
//     'inactive': [],
//   };

//   for (final todo in todos) {
//     if (todo.status == 'active') {
//       categorizedTodos['active']?.add(todo);
//     } else {
//       categorizedTodos['inactive']?.add(todo);
//     }
//   }

//   return categorizedTodos;
// });


// class TodoApp extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     final segment = watch(segmentProvider).state;
//     final todosAsyncValue = watch(categorizedTodosProvider);

//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('TODO App'),
//         ),
//         body: todosAsyncValue.when(
//           data: (categorizedTodos) {
//             final todos = segment == 'active'
//                 ? categorizedTodos['active']!
//                 : categorizedTodos['inactive']!;
            
//             return Column(
//               children: [
//                 CupertinoSlidingSegmentedControl<String>(
//                   groupValue: segment,
//                   children: {
//                     'active': Text('Active'),
//                     'inactive': Text('Inactive'),
//                   },
//                   onValueChanged: (String? value) {
//                     context.read(segmentProvider).state = value!;
//                   },
//                 ),
//                 Expanded(
//                   child: _buildTodoList(todos),
//                 ),
//               ],
//             );
//           },
//           loading: () => Center(child: CircularProgressIndicator()),
//           error: (error, stack) => Center(child: Text('Error: $error')),
//         ),
//       ),
//     );
//   }

//   Widget _buildTodoList(List<Todo> todos) {
//     return ListView.builder(
//       itemCount: todos.length,
//       itemBuilder: (context, index) {
//         final todo = todos[index];
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ListTile(
//             title: Text(todo.name),
//             subtitle: Text(todo.description),
//           ),
//         );
//       },
//     );
//   }
// }
