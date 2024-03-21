import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart'; // Adicione esta linha

// O restante do seu código continua aqui

class SaveClient extends StatefulWidget {
  const SaveClient({Key? key}) : super(key: key);

  @override
  State<SaveClient> createState() => _SaveClientState();
}

class _SaveClientState extends State<SaveClient> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _cpfController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  //final TextEditingController _imageController = TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('client');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';

    if (documentSnapshot != null) {
      action = 'update';

      _nameController.text = documentSnapshot['name'];

      _emailController.text = documentSnapshot['email'];

      _cpfController.text = documentSnapshot['cpf'].toString();

      _passwordController.text = documentSnapshot['password'];

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
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'email'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _cpfController,
                  decoration: const InputDecoration(
                    labelText: 'CPF',
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'SENHA'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? name = _nameController.text;

                    final String? email = _emailController.text;

                    final double? cpf = double.tryParse(_cpfController.text);

                    final String? password = _passwordController.text;

                    // final String? image = _imageController.text;

                    if (name != null &&
                        email != null &&
                        cpf != null &&
                        password != null) {
                      if (action == 'create') {
// Persist a new product to Firestore

                        await _products.add({
                          "name": name,
                          "email": email,
                          "cpf": cpf,
                          "password": password,
                        });
                      }

                      if (action == 'update') {
// Update the product

                        await _products.doc(documentSnapshot!.id).update({
                          "name": name,
                          "email": email,
                          "cpf": cpf,
                          "password": password,
                        });
                      }

// Clear the text fields

                      _nameController.text = '';

                      _emailController.text = '';

                      _cpfController.text = '';

                      _passwordController.text = '';

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
        title: const Text('Cadastrar cliente'),
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
                    title: Text(documentSnapshot['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(documentSnapshot['cpf'].toString()),
                        Text(documentSnapshot['email']),
                        Text(documentSnapshot['password']),
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
