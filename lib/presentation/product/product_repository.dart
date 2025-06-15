import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/product_model.dart';

class ProductRepository {
  final _db = FirebaseFirestore.instance;
  final _collection = 'products';

  Stream<List<Product>> getProducts() {
    return _db
        .collection(_collection)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id; // Inject document ID into map
              return Product.fromMap(data);
            }).toList());
  }

  Stream<Product> watchProductById(String id) {
    return _db.collection(_collection).doc(id).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) throw Exception('Product not found');
      data['id'] = doc.id; // Inject document ID into map
      return Product.fromMap(data);
    });
  }

  Future<void> addProduct(Product product) async {
    await _db.collection(_collection).add(product.toMap());
  }

  Future<void> updateProduct(Product product) async {
    await _db.collection(_collection).doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }
}
