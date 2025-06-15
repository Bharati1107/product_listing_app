import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/product_model.dart';
import 'product_repository.dart';

final productRepositoryProvider = Provider((ref) => ProductRepository());

final productListProvider = StreamProvider<List<Product>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProducts();
});

final productByIdProvider = StreamProvider.family<Product, String>((ref, id) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.watchProductById(id);
});
