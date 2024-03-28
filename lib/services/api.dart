import 'package:http/http.dart' as http;

const baseUrl = "https://api.jsonbin.io/v3/b/6604c2e1c859604a6a0366b4";

class API {
  static Future getProducts(search) async {
    var url = baseUrl + search;

    return await http.get(Uri.parse(url));
  }
}

// Criamos uma classe para representar os objetos que vão conter os filmes

// e colocamos só os campos que vamos usar.

class Products {
  late int id;

  late String name;

  late String brand;

  late String price;

  late String type;

  late String image;

  Products(int id, String name, String brand, String price, String type,
      String image) {
    this.id = id;

    this.name = name;

    this.brand = brand;

    this.price = price;

    this.type = type;

    this.image = image;
  }

  Products.fromJson(Map json)
      : id = json['show']['id'],
        name = json['show']['name'],
        brand = json['show']['brand'],
        price = json['show']['price'],
        type = json['show']['type'],
        image = json['show']['image'];
}
