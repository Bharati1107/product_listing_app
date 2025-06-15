// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/product_model.dart';
import 'product_provider.dart';

class AddEditProductPage extends ConsumerStatefulWidget {
  final Product? product;
  const AddEditProductPage({super.key, this.product});

  @override
  ConsumerState<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends ConsumerState<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _categoryController = TextEditingController();
  final _mrpController = TextEditingController();
  final _rateController = TextEditingController();
  final _imageController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    if (widget.product != null) {
      final p = widget.product!;
      _nameController.text = p.name;
      _brandController.text = p.brand;
      _categoryController.text = p.category;
      _mrpController.text = p.mrp.toString();
      _rateController.text = p.sellingRate.toString();
      _imageController.text = p.imageUrl;
      _descController.text = p.description;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _categoryController.dispose();
    _mrpController.dispose();
    _rateController.dispose();
    _imageController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final repo = ref.read(productRepositoryProvider);
      final product = Product(
        id: widget.product?.id ?? '',
        name: _nameController.text,
        brand: _brandController.text,
        category: _categoryController.text,
        mrp: double.tryParse(_mrpController.text) ?? 0,
        sellingRate: double.tryParse(_rateController.text) ?? 0,
        imageUrl: _imageController.text,
        description: _descController.text,
      );
      if (widget.product == null) {
        await repo.addProduct(product);
      } else {
        await repo.updateProduct(product);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.product == null ? 'Add Product' : 'Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(labelText: 'Brand'),
                  validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(
                  controller: _mrpController,
                  decoration: const InputDecoration(labelText: 'MRP'),
                  keyboardType: TextInputType.number),
              TextFormField(
                  controller: _rateController,
                  decoration: const InputDecoration(labelText: 'Selling Rate'),
                  keyboardType: TextInputType.number),
              TextFormField(
                  controller: _imageController,
                  decoration: const InputDecoration(labelText: 'Image URL')),
              TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
