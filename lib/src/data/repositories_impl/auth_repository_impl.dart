import 'dart:convert';

import 'package:chat/src/domain/repositories/auth_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthRepositoryImpl implements AuthRepository{
  final baseUrl = dotenv.env['API_BASE_URL'];
  final registerEndpoint = dotenv.env['REGISTER'];
  final verifyUserEndpoint = dotenv.env['VERIFY_USER'];
  final getCustomTokenEndpoint = dotenv.env['GET_CUSTOM_TOKEN'];
  final deleteAccountEndpoint = dotenv.env['DELETE_ACCOUNT'];
  @override
  Future<Map<String, dynamic>> register(String email, String username, String password) async{
    final res = await http.post(
      Uri.parse('$baseUrl$registerEndpoint'),
      body: {
        'email': email,
        'username': username,
        'password': password
      });
      print('$baseUrl$registerEndpoint');
      print('$email, $username, $password');
      print(res.body);
      return json.decode(res.body);
  }

  @override
  Future<Map<String, dynamic>> verifyUser(String email, String code) async{
    final res = await http.post(
      Uri.parse('$baseUrl$verifyUserEndpoint'),
      body: {
        'email': email,
        'code': code
      }
    );
    print('$email, $code');
    print('$baseUrl$verifyUserEndpoint');
    print(res.body);
    return json.decode(res.body);
  }

  @override
  Future<Map<String, dynamic>> loginWithCustomToken(String username, String password) async{
    final res = await http.post(
      Uri.parse('$baseUrl$getCustomTokenEndpoint'),
      body: {
        'username':username,
        'password':password
      }
    );
    print('$username, $password');
    print('$baseUrl$getCustomTokenEndpoint');
    print(res.body);
    return json.decode(res.body);
  }

  // @override
  // Future<Map<String, dynamic>> loginWithEmailPass(String email, String password) async {
  //   final res = Fire
  //   );
  // }


}