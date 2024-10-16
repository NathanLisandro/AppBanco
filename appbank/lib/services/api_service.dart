import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class ApiService<T> {
  final String baseUrl;

  ApiService(this.baseUrl);

  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T item);

  Future<List<T>> getAll(String resource) async {
    final response = await http.get(Uri.parse('$baseUrl/$resource'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((json) => fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar dados');
    }
  }

  Future<T?> getById(String resource, String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$resource/$id'));
    if (response.statusCode == 200) {
      return fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<T> create(String resource, T item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$resource'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(toJson(item)),
    );
    if (response.statusCode == 201) {
      return fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao criar registro');
    }
  }

  Future<T> update(String resource, String id, T item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$resource/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(toJson(item)),
    );
    if (response.statusCode == 200) {
      return fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao atualizar registro');
    }
  }

  Future<void> delete(String resource, String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$resource/$id'));
    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar registro');
    }
  }
}
