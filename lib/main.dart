import 'package:appcrud/product.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'client.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBJap74NOB4SVxKEoDyjiQIisF9VVaC-xw",
          authDomain: "crudfirestore-13eb7.firebaseapp.com",
          projectId: "crudfirestore-13eb7",
          storageBucket: "crudfirestore-13eb7.appspot.com",
          messagingSenderId: "652078720497",
          appId: "1:652078720497:web:4a1ec19c908a4178da1050"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo Menu Drawer - Hamburguer',
      theme: ThemeData(
        primarySwatch: Colors.brown, // Define a cor principal como marrom
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.brown, // Define a cor do AppBar como marrom
        ),
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const UserAccountsDrawerHeader(
                accountEmail: Text("alexandre.bortolozo@fatec.sp.gov.br"),
                accountName: Text("Alexandre Bortolozo"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text("PUB'S"),
                ),
              ),
              ListTile(
                leading: Icon(Icons.login),
                title: Text("Cadastro Produtos"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment_ind_outlined),
                title: Text("Cadastro Clientes"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SaveClient()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text("Ler API"),
                onTap: () {
                  Navigator.pop(context);

                  //Navegar para outra página
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Perfil"),
                onTap: () {
                  Navigator.pop(context);

                  //Navegar para outra página
                },
              ),
            ],
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://th.bing.com/th/id/R.ee77ff08631e759a6ca32cd668cb227e?rik=XAC2DJpDhiEDbg&pid=ImgRaw&r=0'))),
        ));
  }
}
