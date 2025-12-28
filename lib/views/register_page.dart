import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String selectedImage = "assets/profile/profile.jpg";

  final avatars = [
    "assets/profile/profile.jpg",
    "assets/profile/avatar1.png",
    "assets/profile/avatar2.png",
    "assets/profile/avatar3.png",
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              children: avatars.map((img) {
                return GestureDetector(
                  onTap: () => setState(() => selectedImage = img),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(img),
                    child: selectedImage == img
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            _field(nameCtrl, "Name"),
            _field(emailCtrl, "Email"),
            _field(passCtrl, "Password", obscure: true),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final ok = await auth.register(
                  nameCtrl.text,
                  emailCtrl.text,
                  passCtrl.text,
                  selectedImage,
                );

                if (ok) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Email already exists")),
                  );
                }
              },
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
        obscureText: obscure,
        decoration: InputDecoration(labelText: hint),
      ),
    );
  }
}
