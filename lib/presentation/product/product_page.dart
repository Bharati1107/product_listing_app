import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme_provider.dart';
import '../cart/cart_page.dart';
import '../cart/cart_provider.dart';
import '../users/auth_provider.dart';
import '../users/phone_auth_page.dart';
import 'add_edit_product_page.dart';
import 'product_card.dart';
import 'product_provider.dart';
import '../../model/product_model.dart';

// State Providers
final searchProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final selectedBrandProvider = StateProvider<String?>((ref) => null);
final sortOptionProvider = StateProvider<String?>((ref) => null);
final TextEditingController searchController = TextEditingController();

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);
    final search = ref.watch(searchProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedBrand = ref.watch(selectedBrandProvider);
    final sortOption = ref.watch(sortOptionProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);
    final themeMode = ref.watch(themeModeProvider);
    final authAsync = ref.watch(authProvider);
    final showFab = authAsync.maybeWhen(
      data: (user) => user == null || user.phoneNumber == '+911234567890',
      orElse: () => true,
    );

    final crossAxisCount = 2;
    final maxWidth = kIsWeb ? 450.0 : double.infinity;

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Product Listing App'),
            actions: [
              IconButton(
                icon: Icon(themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode),
                onPressed: () => themeNotifier.toggleTheme(),
              ),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartPage()),
                      );
                    },
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${ref.watch(cartProvider).length}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              // ✅ Only show if logged in
              authAsync.when(
                data: (user) => user != null
                    ? IconButton(
                        icon: const Icon(Icons.logout_outlined),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          body: productsAsync.when(
            data: (products) {
              // Unique Categories and Brands
              final categories =
                  products.map((p) => p.category).toSet().toList();
              final brands = selectedCategory == null
                  ? products.map((p) => p.brand).toSet().toList()
                  : products
                      .where((p) => p.category == selectedCategory)
                      .map((p) => p.brand)
                      .toSet()
                      .toList();

              // Filtered & Sorted Products
              List<Product> filtered = products.where((product) {
                final matchesSearch =
                    product.name.toLowerCase().contains(search.toLowerCase()) ||
                        product.sellingRate.toStringAsFixed(0).contains(search);

                final matchesCategory = selectedCategory == null ||
                    product.category == selectedCategory;

                final matchesBrand =
                    selectedBrand == null || product.brand == selectedBrand;

                return matchesSearch && matchesCategory && matchesBrand;
              }).toList();

              if (sortOption == 'Name (A-Z)') {
                filtered.sort((a, b) => a.name.compareTo(b.name));
              } else if (sortOption == 'Name (Z-A)') {
                filtered.sort((a, b) => b.name.compareTo(a.name));
              } else if (sortOption == 'MRP (High to Low)') {
                filtered.sort((a, b) => b.sellingRate.compareTo(a.sellingRate));
              } else if (sortOption == 'MRP (Low to High)') {
                filtered.sort((a, b) => a.sellingRate.compareTo(b.sellingRate));
              }

              return Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search by product name or mrp',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) =>
                          ref.read(searchProvider.notifier).state = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          /// Filter Icon
                          GestureDetector(
                            onTap: () {
                              final hasFiltersApplied =
                                  selectedCategory != null ||
                                      selectedBrand != null ||
                                      search.isNotEmpty;

                              if (hasFiltersApplied) {
                                // Reset the filters immediately
                                if (searchController.text.isNotEmpty) {
                                  searchController.clear();
                                }
                                ref.read(searchProvider.notifier).state = '';
                                ref
                                    .read(selectedCategoryProvider.notifier)
                                    .state = null;
                                ref.read(selectedBrandProvider.notifier).state =
                                    null;
                                final message = 'Filters cleared';

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)),
                                );
                              } else {
                                // Show the modal to apply filters
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  builder: (context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'Apply Filters',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 16),
                                          _buildPopupMenu(
                                            label: "Category",
                                            selectedValue: selectedCategory,
                                            items: categories,
                                            onSelected: (val) {
                                              ref
                                                  .read(selectedCategoryProvider
                                                      .notifier)
                                                  .state = val;
                                              Navigator.pop(context);
                                            },
                                            themeMode: themeMode,
                                          ),
                                          const SizedBox(height: 12),
                                          _buildPopupMenu(
                                            label: "Brand",
                                            selectedValue: selectedBrand,
                                            items: brands,
                                            onSelected: (val) {
                                              ref
                                                  .read(selectedBrandProvider
                                                      .notifier)
                                                  .state = val;
                                              Navigator.pop(context);
                                            },
                                            themeMode: themeMode,
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(
                                                  double.infinity, 50),
                                            ),
                                            onPressed: () {
                                              ref
                                                  .read(selectedCategoryProvider
                                                      .notifier)
                                                  .state = null;
                                              ref
                                                  .read(selectedBrandProvider
                                                      .notifier)
                                                  .state = null;
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Reset Filters'),
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            child: Container(
                              height: 38,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.filter_list,
                                      size: 20,
                                      color: themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black),
                                  SizedBox(width: 8),
                                  Text('Filter',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: themeMode == ThemeMode.dark
                                              ? Colors.white
                                              : Colors.black)),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// Category Dropdown
                          _buildPopupMenu(
                            label: "Category",
                            selectedValue: selectedCategory,
                            items: categories,
                            onSelected: (val) => ref
                                .read(selectedCategoryProvider.notifier)
                                .state = val,
                            themeMode: themeMode,
                          ),

                          const SizedBox(width: 12),

                          /// Brand Dropdown
                          _buildPopupMenu(
                            label: "Brand",
                            selectedValue: selectedBrand,
                            items: brands,
                            onSelected: (val) => ref
                                .read(selectedBrandProvider.notifier)
                                .state = val,
                            themeMode: themeMode,
                          ),

                          const SizedBox(width: 12),

                          /// Sort by Name
                          _buildPopupMenu(
                            label: "Name",
                            selectedValue:
                                sortOption == 'Name (A-Z)' ? sortOption : null,
                            items: const ['Name (A-Z)', 'Name (Z-A)', 'Clear'],
                            onSelected: (val) {
                              if (val == 'Clear') {
                                ref.read(sortOptionProvider.notifier).state =
                                    null;
                              } else {
                                ref.read(sortOptionProvider.notifier).state =
                                    val;
                              }
                            },
                            themeMode: themeMode,
                          ),
                          const SizedBox(width: 12),

                          /// Sort by MRP
                          _buildPopupMenu(
                            label: "Price",
                            selectedValue: sortOption == 'MRP (Low to High)'
                                ? sortOption
                                : null,
                            items: const [
                              'MRP (Low to High)',
                              'MRP (High to Low)',
                              'Clear'
                            ],
                            onSelected: (val) {
                              if (val == 'Clear') {
                                ref.read(sortOptionProvider.notifier).state =
                                    null;
                              } else {
                                ref.read(sortOptionProvider.notifier).state =
                                    val;
                              }
                            },
                            themeMode: themeMode,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Expanded(
                    child: filtered.isEmpty
                        ? const Center(child: Text('No products found'))
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: kIsWeb ? 0.7 : 0.65,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: filtered.length,
                            padding: const EdgeInsets.all(12),
                            itemBuilder: (_, i) =>
                                ProductCard(product: filtered[i]),
                          ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
          // Inside Scaffold
          floatingActionButton: showFab
              ? FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    // Read the auth state synchronously
                    final user = authAsync.asData?.value;

                    if (user == null) {
                      // Not logged in → Show login dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const PhoneAuthDialog(),
                      );
                    } else if (user.phoneNumber == '+911234567890') {
                      // Authorized user → Navigate to Add Product
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddEditProductPage(),
                        ),
                      );
                    } else {
                      // Logged in but not authorized
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Access denied')),
                      );
                    }
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildPopupMenu({
    required String label,
    required String? selectedValue,
    required List<String> items,
    required void Function(String) onSelected,
    required ThemeMode themeMode,
  }) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(30),
      ),
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        onSelected: onSelected,
        itemBuilder: (context) {
          return items.map((item) {
            return PopupMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 13)),
            );
          }).toList();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedValue ?? label,
              style: TextStyle(
                fontSize: 13,
                color:
                    themeMode == ThemeMode.dark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
    );
  }
}
