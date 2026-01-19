import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _signupFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Form(
            key: _signupFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      // Login TItle
                      const Text(
                        "Welcome back!",
                        style: TextStyle(fontSize: 32),
                      ),

                      const SizedBox(height: 8),

                      // Login Subtitle
                      const Text(
                        "Log in to continue learning sign language and building meaningful connections.",
                        style: TextStyle(fontSize: 12),
                      ),

                      // Email Input Field
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: 'Enter your email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          }
                          return null;
                        },
                      ),

                      // Password Input Field
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Enter your password',
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
                        autocorrect: false,

                        // Validation
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                      ),

                      /* Forgot Password
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPassword(),
                                ),
                              );
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                        ),
                      ),
                      ),

                      const SizedBox(height: 35),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_loginFormKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            }
                          },
                        )
                      )
                      */
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
