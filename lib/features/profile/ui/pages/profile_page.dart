import 'package:appmovil261/features/profile/ui/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final email =
        Supabase.instance.client.auth.currentUser?.email ?? 'Sin sesión';

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLogoutSuccessState) {
          Navigator.pushReplacementNamed(context, '/login');
        } else if (state is ProfileErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 64),
            const SizedBox(height: 16),
            Text(email, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 32),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoadingState) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton.icon(
                  onPressed: () {
                    context.read<ProfileBloc>().add(ProfileLogoutEvent());
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar Sesión'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
