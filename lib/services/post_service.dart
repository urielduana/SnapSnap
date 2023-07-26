import 'dart:io';
import 'package:dio/dio.dart';

class PostService {
  static Dio _dio = Dio();

  static Future<void> uploadPost({
    required String caption,
    required List<int> tags,
    required List<File> images,
  }) async {
    try {
      // Preparar los datos para enviar al servidor
      FormData formData = FormData();
      formData.fields.add(MapEntry('caption', caption));
      formData.fields.add(MapEntry('tags', tags.map((tagId) => tagId.toString()).join(',')));

      for (int i = 0; i < images.length; i++) {
        File file = images[i];
        String fileName = file.path.split('/').last;
        formData.files.add(MapEntry(
          'images[]', // Use 'images[]' to represent an array of images
          await MultipartFile.fromFile(file.path, filename: fileName),
        ));
      }

      // Hacer la solicitud POST al servidor utilizando Dio
      Response response = await _dio.post(
        'http://3.136.234.107:8000/api/img',
        data: formData,
      );

      // Procesar la respuesta del servidor si es necesario.
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
