import 'dart:io';
import 'package:dio/dio.dart';

class PostService {
  static final Dio _dio = Dio();

  // token de autenticación
  static void setAuthToken(String? authToken) {
    if (authToken != null) {
      _dio.options.headers['Authorization'] = 'Bearer $authToken';
    }
  }

  //  Obtener los posts del servidor
  static Future<void> uploadPost({
    required String caption,
    required List<int> tags,
    required List<File> images,
  }) async {
    try {
      // Preparar los datos para enviarlos al servidor
      FormData formData = FormData();
      formData.fields.add(MapEntry('caption', caption));
      formData.fields.add(MapEntry('tags', tags.map((tagId) => tagId.toString()).join(',')));

      for (int i = 0; i < images.length; i++) {
        File file = images[i];
        String fileName = file.path.split('/').last;
        formData.files.add(MapEntry(
          'images[]',
          await MultipartFile.fromFile(file.path, filename: fileName),
        ));
      }

      // Imprimir el token para ver que se envía correctamente
      String? authToken = _dio.options.headers['Authorization'];
      print('Token de autenticación: $authToken');

      // Hacer la solicitud POST al servidor utilizando Dio
      Response response = await _dio.post(
        'http://18.118.200.206:8000/api/img',
        data: formData,
      );

      // Respuesta
      if (response.statusCode == 200) {
        print('Response from server:');
        print(response.data);
      } else {
        print('Error en la solicitud al servidor.');
      }
    } catch (e) {
      // Manejar errores si ocurre algún problema en la solicitud HTTP.
      print('Error al enviar los datos al servidor: $e');
      throw Exception('Error en la solicitud al servidor.');
    }
  }
}
