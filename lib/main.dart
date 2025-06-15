import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/product/product_page.dart';
import 'theme/theme_provider.dart';
import 'theme/themes.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Product Listing App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: const ProductListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// class HomePage extends ConsumerWidget {
//   const HomePage({super.key});

//   void addDummyData() {
//     FirebaseFirestore.instance.collection('products').add({
//       'id': 1,
//       'name': 'Sample Product',
//       'category': 'Electronics',
//       'mrp': 999.0,
//       'sellingRate': 799.0,
//       'imageUrl': 'https://via.placeholder.com/150',
//       'brand': 'SampleBrand',
//       'description': 'A sample description of the product.',
//     });
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final themeMode = ref.watch(themeModeProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Product Listing"),
//         actions: [
//           IconButton(
//             icon: Icon(themeMode == ThemeMode.dark
//                 ? Icons.light_mode
//                 : Icons.dark_mode),
//             onPressed: () {
//               final isDark = themeMode == ThemeMode.dark;
//               ref.read(themeModeProvider.notifier).state =
//                   isDark ? ThemeMode.light : ThemeMode.dark;
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: addDummyData,
//           child: const Text("Add Dummy Data"),
//         ),
//       ),
//     );
//   }
// }
