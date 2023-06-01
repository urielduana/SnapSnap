import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapSnap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserForm(),
    );
  }
}

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _submitForm() async {
    final response = await http.post(
      Uri.parse('https://8e56-2001-1260-22b-4a1-ec24-3e93-fc4-20c2.ngrok-free.app/register'), // Reemplaza con la URL correcta de tu backend
      body: {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      // El formulario se envió correctamente
      print('Formulario enviado exitosamente');
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
    } else {
      // Hubo un error al enviar el formulario
      print('Error al enviar el formulario');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register User Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
