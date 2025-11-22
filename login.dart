import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto2/CalendarPage.dart';
import 'package:projeto2/RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";

  final FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;

  void loginUser() async {
    if (email.isEmpty || password.isEmpty) {
      showError("Preencha todos os campos");
      return;
    }

    try {
      setState(() => isLoading = true);

      await auth.signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CalendarPage()),
      );
    } on FirebaseAuthException catch (e) {
      showError(e.message ?? "Erro ao fazer login");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (text) => email = text,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  labelText: 'Email',
                  hintText: 'Digite seu email',
                ),
              ),

              SizedBox(height: 20),

              TextField(
                onChanged: (text) => password = text,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  labelText: 'Senha',
                  hintText: 'Digite sua senha',
                ),
              ),

              SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text("Criar conta"),
              ),

              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(child: Text("Login"), onPressed: loginUser),
            ],
          ),
        ),
      ),
    );
  }
}
