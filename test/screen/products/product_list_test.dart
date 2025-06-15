// test/screen/products/product_list_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_listing_app/model/product_model.dart';
import 'package:product_listing_app/presentation/product/product_page.dart';

// Sample product data for Medicine/Pharmacy domain
final sampleProducts = [
  Product(
    id: '1',
    name: 'Paracetamol 500mg',
    brand: 'PharmaCorp',
    category: 'Medicine',
    mrp: 25.0,
    sellingRate: 20.0,
    imageUrl: '',
    description: '',
  ),
  Product(
    id: '2',
    name: 'Cough Syrup',
    brand: 'HealthPlus',
    category: 'Medicine',
    mrp: 60.0,
    sellingRate: 55.0,
    imageUrl: '',
    description: '',
  ),
  Product(
    id: '3',
    name: 'Vitamin D Capsules',
    brand: 'WellnessCo',
    category: 'Supplement',
    mrp: 150.0,
    sellingRate: 120.0,
    imageUrl: '',
    description: '',
  ),
  Product(
    id: '4',
    name: 'Glucose Powder',
    brand: 'PharmaCorp',
    category: 'Supplement',
    mrp: 40.0,
    sellingRate: 30.0,
    imageUrl: '',
    description: '',
  ),
];

List<Product> testFilterAndSort({
  required List<Product> products,
  String search = '',
  String? category,
  String? brand,
  String? sortOption,
}) {
  final filtered = products.where((product) {
    final matchesSearch =
        product.name.toLowerCase().contains(search.toLowerCase()) ||
            product.mrp.toString().contains(search);

    final matchesCategory = category == null || product.category == category;
    final matchesBrand = brand == null || product.brand == brand;

    return matchesSearch && matchesCategory && matchesBrand;
  }).toList();

  if (sortOption == 'Name (A-Z)') {
    filtered.sort((a, b) => a.name.compareTo(b.name));
  } else if (sortOption == 'MRP (Low to High)') {
    filtered.sort((a, b) => a.mrp.compareTo(b.mrp));
  }

  return filtered;
}

void main() {
  group('Product Filtering, Sorting, and Searching', () {
    test('Initial state shows all products with no sorting', () {
      final result = testFilterAndSort(products: sampleProducts);
      expect(result.length, 4);
    });

    test('Filter by category: Medicine', () {
      final result = testFilterAndSort(
        products: sampleProducts,
        category: 'Medicine',
      );
      expect(result.length, 2);
      expect(result.every((p) => p.category == 'Medicine'), true);
    });

    test('Filter by brand: PharmaCorp', () {
      final result = testFilterAndSort(
        products: sampleProducts,
        brand: 'PharmaCorp',
      );
      expect(result.length, 2);
      expect(result.every((p) => p.brand == 'PharmaCorp'), true);
    });

    test('Search by product name', () {
      final result = testFilterAndSort(
        products: sampleProducts,
        search: 'Syrup',
      );
      expect(result.length, 1);
      expect(result[0].name, 'Cough Syrup');
    });

    test('Search by partial MRP (e.g. "5")', () {
      final result = testFilterAndSort(
        products: sampleProducts,
        search: '5',
      );
      expect(result.length, 2); // Paracetamol 25.0 & Cough Syrup 60.0
    });

    test('Sort by MRP (Low to High)', () {
      final result = testFilterAndSort(
        products: sampleProducts,
        sortOption: 'MRP (Low to High)',
      );
      expect(result.first.mrp, 25.0);
      expect(result.last.mrp, 150.0);
    });

    test('Sort by Name (A-Z)', () {
      final result = testFilterAndSort(
        products: sampleProducts,
        sortOption: 'Name (A-Z)',
      );
      expect(result.first.name, 'Cough Syrup');
      expect(result.last.name, 'Vitamin D Capsules');
    });

    test('Combined filter: category + search', () {
      final result = testFilterAndSort(
        products: sampleProducts,
        category: 'Supplement',
        search: 'Glucose',
      );
      expect(result.length, 1);
      expect(result[0].name, 'Glucose Powder');
    });

    test('No results for unmatched brand+category', () {
      final result = testFilterAndSort(
        products: sampleProducts,
        category: 'Medicine',
        brand: 'WellnessCo',
      );
      expect(result, isEmpty);
    });

    test('Case-insensitive search', () {
      final result = testFilterAndSort(
        products: sampleProducts,
        search: 'vitamin',
      );
      expect(result.length, 1);
      expect(result[0].name, 'Vitamin D Capsules');
    });
  });

  group('Provider State Tests', () {
    test('searchProvider updates correctly', () {
      final container = ProviderContainer();
      final notifier = container.read(searchProvider.notifier);
      expect(container.read(searchProvider), '');
      notifier.state = 'cough';
      expect(container.read(searchProvider), 'cough');
    });

    test('selectedCategoryProvider updates correctly', () {
      final container = ProviderContainer();
      final notifier = container.read(selectedCategoryProvider.notifier);
      expect(container.read(selectedCategoryProvider), null);
      notifier.state = 'Medicine';
      expect(container.read(selectedCategoryProvider), 'Medicine');
      notifier.state = null;
      expect(container.read(selectedCategoryProvider), null);
    });

    test('selectedBrandProvider updates correctly', () {
      final container = ProviderContainer();
      final notifier = container.read(selectedBrandProvider.notifier);
      expect(container.read(selectedBrandProvider), null);
      notifier.state = 'PharmaCorp';
      expect(container.read(selectedBrandProvider), 'PharmaCorp');
      notifier.state = null;
      expect(container.read(selectedBrandProvider), null);
    });

    test('sortOptionProvider updates correctly', () {
      final container = ProviderContainer();
      final notifier = container.read(sortOptionProvider.notifier);
      expect(container.read(sortOptionProvider), null);
      notifier.state = 'Name (A-Z)';
      expect(container.read(sortOptionProvider), 'Name (A-Z)');
    });
  });
}
