import 'package:appmovil261/features/auth/domain/usecases/signup_usecase.dart';
import 'package:appmovil261/features/signup/ui/bloc/signup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      //Puedo ejecutar acciones que NO tienen que ver con el arbol de renderizado
      listener: (context, state) {
        if (state is SignupSuccessState) {
          Navigator.pushNamed(context, '/home');
        } else if (state is SignupFailState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Content(),
    );
  }

  Widget Content() {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),

            BlocBuilder<SignupBloc, SignupState>(
              builder: (context, state) {
                bool loading = state is SignupLoadingState;
                return Column(
                  children: [
                    loading ? CircularProgressIndicator() : SizedBox.shrink(),
                    ElevatedButton(
                      onPressed: () {
                        //Registro
                        context.read<SignupBloc>().add(
                          SignupSubmitEvent(
                            email: emailController.text,
                            password: passController.text,
                          ),
                        );
                        //
                      },
                      child: Text("Registrar"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text("¿Ya tienes cuenta? Inicia sesión"),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
