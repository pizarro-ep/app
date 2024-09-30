import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myapp/widgets/clipper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController(text: 'Sincere@april.biz');
  final TextEditingController _passwordController = TextEditingController(text: 'Bret');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Principal widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildPositionedBackground(context, 0, 1, const Color.fromRGBO(30, 49, 51, 1)),
          _buildPositionedBackground(context, .5, .5, const Color.fromRGBO(0, 1, 19, 1)),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderSection(),
                  _contentSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Funcion para validad las credenciales del usuario con un API
  Future<void> _onLogin(BuildContext context, String email, String password) async {
    String url = 'https://jsonplaceholder.typicode.com/users?email=$email&username=$password';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // verificamos la respuesta de la API
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.length > 0) {
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          if (context.mounted) {
            _showMessageDialog("Error", 'Credenciales incorrectos, intente nuevamente');
          }
        }
      } else {
        if (context.mounted) {
          _showMessageDialog("Error", 'Error en el servidor. Intenta de nuevo más tarde');
        }
      }
    } catch (error) {
      if (context.mounted) {
        _showMessageDialog("Error", 'Ocurrió un error. Revisa tu conexion a internet');
      }
    }
  }

  // Metodo para mostrar mensajes
  void _showMessageDialog(String titleMessage, String textMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(titleMessage),
              content: Text(textMessage),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  /**
   * CREACIÓN DE WIDGETS
   */

  /// Widget de imagen
  Widget _buildImages(image) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 100),
      child: Image.asset(image, fit: BoxFit.cover),
    );
  }

  /// Widget para crear inputs para el dorumlario
  Widget _buildInput(String label, TextEditingController controller, TextInputType keyboardType, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese su $label';
          }
          return null;
        },
      ),
    );
  }

  /// Widget para crear el boton
  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: double.infinity, // Ocupa todo el ancho posible
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              _onLogin(context, _emailController.text, _passwordController.text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(51, 61, 85, 1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: const Text('INICIAR SESIÓN'),
        ),
      ),
    );
  }

  /// Widget para la seccion de otros metodos de registro
  Widget _otherRegisterMethodsSection() {
    Widget lineWidget({begin = FractionalOffset.centerLeft, end = FractionalOffset.centerRight}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          height: 1.0,
          width: 30.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [Colors.grey, Colors.white],
              stops: const [0.2, 0.7],
              begin: begin,
              end: end,
            ),
          ),
        ),
      );
    }

    Widget outlinedButtomCustom(String label, IconData icon, Color iconColor, {onPressed = ()}) {
      return OutlinedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color.fromRGBO(51, 61, 85, 1),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 16),
            const SizedBox(width: 4), // Separación entre el ícono y el texto
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.white)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              lineWidget(),
              const Text(
                'O continúe con',
                style: TextStyle(fontSize: 12),
              ),
              lineWidget(begin: FractionalOffset.centerRight, end: FractionalOffset.centerLeft),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              outlinedButtomCustom("Google", Icons.admin_panel_settings, Colors.orangeAccent),
              const SizedBox(width: 8),
              outlinedButtomCustom("Facebook", Icons.facebook, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  /// Widget para el formulario
  Widget _buildRegisterForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildInput("Correo Electrónico", _emailController, TextInputType.emailAddress, false),
          _buildInput("Contraseña", _passwordController, TextInputType.visiblePassword, true),
          _buildButton(),
        ],
      ),
    );
  }

  /// Widget para los fondos
  Widget _buildPositionedBackground(context, top, height, Color color) {
    return Positioned(
      top: MediaQuery.of(context).size.height * top,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * height, // * 0.5,
        decoration: BoxDecoration(color: color),
      ),
    );
  }

  /// Widget par el titulo del formulario
  Widget _buildTitleForm(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 75, bottom: 32),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  /// Widget para crear elLink a la vista register / login
  Widget _buildLink(BuildContext context, String text, String link, String route) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 4),
        InkWell(
          child: Text(link, style: const TextStyle(fontSize: 12, color: Colors.blue)),
          onTap: () => {Navigator.pushReplacementNamed(context, route)},
        ),
      ],
    );
  }

  /// Widget para crar el header page
  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          _buildImages("images/mtc_2.png"),
          const Text(
            "¡Bienvenido de nuevo!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Bienvenido de nuevo, te extrañamos',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Widget para la seccion de contenido
  Widget _contentSection() {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final initialPosition = Offset(0, height * .2);
    final positions = [Offset(width * .5, 0), Offset(width, height * .2), Offset(width, height), Offset(0, height)];

    return ClipPath(
      clipper: BuildClipper(initialPosition: initialPosition, positions: positions),
      child: Container(
        padding: const EdgeInsets.all(32),
        color: const Color.fromRGBO(0, 1, 19, 1), // Color del contenedor
        child: Column(
          children: [
            _buildTitleForm('Iniciar Sesión'),
            _buildRegisterForm(),
            _otherRegisterMethodsSection(),
            _buildLink(context, "¿No tienes una cuenta?", "Registrarse", '/register'),
          ],
        ),
      ),
    );
  }
}

class TriangleTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * .2);
    path.lineTo(size.width * .5, 0);
    path.lineTo(size.width, size.height * .2);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}