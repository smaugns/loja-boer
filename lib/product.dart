import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart'; // Adicione esta linha

// O restante do seu código continua aqui

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // text fields' controllers

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _brandController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _typeController = TextEditingController();

  //final TextEditingController _imageController = TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';

    if (documentSnapshot != null) {
      action = 'update';

      _nameController.text = documentSnapshot['name'];

      _brandController.text = documentSnapshot['brand'];

      _priceController.text = documentSnapshot['price'].toString();

      _typeController.text = documentSnapshot['type'];

      //_imageController.text = documentSnapshot['image'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,

// prevent the soft keyboard from covering text fields

                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Produto'),
                ),
                TextField(
                  controller: _brandController,
                  decoration: const InputDecoration(labelText: 'Marca'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Preço',
                  ),
                ),
                TextField(
                  controller: _typeController,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? name = _nameController.text;

                    final String? brand = _brandController.text;

                    final double? price =
                        double.tryParse(_priceController.text);

                    final String? type = _typeController.text;

                    // final String? image = _imageController.text;

                    if (name != null &&
                        brand != null &&
                        price != null &&
                        type != null) {
                      if (action == 'create') {
// Persist a new product to Firestore

                        await _products.add({
                          "name": name,
                          "brand": brand,
                          "price": price,
                          "type": type,
                        });
                      }

                      if (action == 'update') {
// Update the product

                        await _products.doc(documentSnapshot!.id).update({
                          "name": name,
                          "brand": brand,
                          "price": price,
                          "type": type,
                        });
                      }

// Clear the text fields

                      _nameController.text = '';

                      _brandController.text = '';

                      _priceController.text = '';

                      _typeController.text = '';

                      //_imageController.text = '';

// Hide the bottom sheet

                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

// Deleteing a product by id

  Future<void> _deleteProduct(String productId) async {
    await _products.doc(productId).delete();

// Show a snackbar

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar produto'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),

// Using StreamBuilder to display all products from Firestore in real-time

      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['brand']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(documentSnapshot['price'].toString()),
                        Text(documentSnapshot['name']),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
// Press this button to edit a single product

                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),

// This icon button is used to delete a single product

                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),

// Add new product

      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class pressed {}
