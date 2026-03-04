import 'package:flutter/material.dart';
import '/core/widgets/button.dart';
import '/core/widgets/text_input_field.dart';
import '/core/utils/validators.dart';
import '/features/auth/presentation/viewmodels/login_view_model.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Form Key
  final _loginFormKey = GlobalKey<FormState>();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  final loginVM = LoginViewModel();

  String _formatCooldown(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    final mm = minutes.toString().padLeft(2, '0');
    final ss = remaining.toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    loginVM.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0XFFF8F8F8),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 50),
          child: Form(
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Login Title
                const Text(
                  "Welcome \nBack!",
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // Login Subtitle
                const Text(
                  "Log in to continue learning sign language and building meaningful connections.",
                  style: TextStyle(fontSize: 16, fontFamily: 'PlusJakartaSans'),
                ),

                const SizedBox(height: 20),

                // Email Text Field
                TextFormField(
                  controller: emailController,
                  validator: (value) => Validators.validateEmail(value),
                  keyboardType: TextInputType.emailAddress,
                  decoration: textInputField(
                    "name@example.com",
                    prefixIcon: Icons.email_outlined,
                  ),
                ),

                const SizedBox(height: 14),

                // Password Field
                TextFormField(
                  controller: passwordController,
                  validator: (value) => Validators.validatePassword(value),
                  obscureText: obscurePassword,
                  decoration:
                      textInputField(
                        "Create a password",
                        prefixIcon: Icons.lock_outlined,
                      ).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                ),

                const SizedBox(height: 14),

                // Forgot Password
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/forgot_password');
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Login Button
                ListenableBuilder(
                  listenable: loginVM,
                  builder: (context, child) {
                    final isLocked = loginVM.isCooldown;
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Button(
                        text: loginVM.isLoading
                            ? "Loading..."
                            : isLocked
                            ? "Try again in ${_formatCooldown(loginVM.cooldownSeconds)}"
                            : "Get Started",
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (loginVM.isLoading || isLocked) return;
                          if (_loginFormKey.currentState!.validate()) {
                            await loginVM.login(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                            if (loginVM.errorMessage != null) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(loginVM.errorMessage!),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } else if (loginVM.token != null) {
                              // Handle successful login, e.g., save token and navigate
                              if (context.mounted) {
                                Navigator.pushNamed(context, '/home');
                              }
                            }
                          }
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Don't have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(width: 6),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE9B63B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
