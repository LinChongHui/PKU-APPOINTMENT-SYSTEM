import 'package:flutter/material.dart';
import 'package:user_profile_management/page/Theme.dart';
import 'package:user_profile_management/page/Login.dart';
import 'package:user_profile_management/back-end/firebase_Registration.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _matricNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 120),
              const SizedBox(height: 16),
              const Text(
                'Pusat Kesihatan UTM',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'AUTOMANAGER',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_firstNameController, 'First Name'),
                    const SizedBox(height: 16),
                    _buildTextField(_lastNameController, 'Last Name'),
                    const SizedBox(height: 16),
                    _buildTextField(_matricNumberController, 'Matric Number'),
                    const SizedBox(height: 16),
                    _buildTextField(_emailController, 'Email', isEmail: true),
                    const SizedBox(height: 16),
                    _buildTextField(_mobileController, 'Mobile'),
                    const SizedBox(height: 16),
                    _buildPasswordField(_passwordController, 'Password'),
                    const SizedBox(height: 16),
                    _buildPasswordField(_confirmPasswordController, 'Confirm Password'),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _isLoading = true);
                                  // Connect to firebase
                                  String? result = await AuthService.registerUser(
                                    firstName: _firstNameController.text.trim(),
                                    lastName: _lastNameController.text.trim(),
                                    matricNumber: _matricNumberController.text.trim(),
                                    email: _emailController.text.trim(),
                                    mobile: _mobileController.text.trim(),
                                    password: _passwordController.text.trim(),
                                    context: context,
                                  );
                                  if (result == null) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LoginPage()),
                                    );
                                  }
                                  setState(() => _isLoading = false);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: firstcolour,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(fivethcolour),
                              )
                            : const Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 16, color: sixthcolour),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("If you already registered "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: firstcolour,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your $labelText';
        }
        if (isEmail &&
            !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
          return 'Enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your $labelText';
        }
        if (labelText == 'Confirm Password' &&
            value.trim() != _passwordController.text.trim()) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
