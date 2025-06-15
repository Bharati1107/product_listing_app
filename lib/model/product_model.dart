class Product {
  final String id;
  final String name;
  final String category;
  final double mrp;
  final double sellingRate;
  final String imageUrl;
  final String brand;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.mrp,
    required this.sellingRate,
    required this.imageUrl,
    required this.brand,
    required this.description,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'mrp': mrp,
        'sellingRate': sellingRate,
        'imageUrl': imageUrl,
        'brand': brand,
        'description': description,
      };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map['id'],
        name: map['name'],
        category: map['category'],
        mrp: (map['mrp'] as num).toDouble(),
        sellingRate: (map['sellingRate'] as num).toDouble(),
        imageUrl: map['imageUrl'],
        brand: map['brand'],
        description: map['description'],
      );
}
