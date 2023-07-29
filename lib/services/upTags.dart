import 'package:dio/dio.dart';
import 'dart:convert';


Future<void> updateTags(List<Map<String, dynamic>> selectedTags) async {
  const url = 'http://18.118.200.206:8000/api/tags';

  final dio = Dio();
  
  try {
    final requestData = json.encode(selectedTags);
    print('Datos enviados: $requestData');

    final response = await dio.post(
      url,
      data: requestData,
      options: Options(contentType: 'application/json'),
    );

    if (response.statusCode == 200) {
      print('Tags actualizados correctamente');
      print(response);
    } else {
      print('Error al actualizar los tags');
    }
  } catch (e) {
    print('Error en la solicitud: $e');
  }
}

