import 'package:flutter/material.dart';
import '/core/widgets/button.dart';
import '/core/widgets/text_input_field.dart';
import '/core/utils/validators.dart';
import '/features/auth/presentation/viewmodels/signup_view_models.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  // Form Key
  final _signupFormKey = GlobalKey<FormState>();

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final signupVM = SignupViewModel();

  bool inputPassword = true;
  bool confirmInputPassword = true;
  bool _legalDisclaimer = false;

  @override
  void dispose() {
    // Dispose controllers
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0XFFF8F8F8),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 48),
          child: Form(
            key: _signupFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      // Sign Up Title
                      const Text(
                        "Sign Up and Start Learning",
                        style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Sign Up Subtitle
                      const Text(
                        "Create an account to save your daily goal and start your first lesson.",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'PlusJakartaSans',
                        ),
                      ),

                      const SizedBox(height: 20),

                      // First Name Text Field
                      TextFormField(
                        controller: firstNameController,
                        validator: (value) => Validators.validateName(
                          value,
                          fieldName: "First Name",
                        ),
                        keyboardType: TextInputType.name,
                        decoration: textInputField(
                          "Enter your first name",
                          prefixIcon: Icons.person,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Last Name Text Field
                      TextFormField(
                        controller: lastNameController,
                        validator: (value) => Validators.validateName(
                          value,
                          fieldName: "Last Name",
                        ),
                        keyboardType: TextInputType.name,
                        decoration: textInputField(
                          "Enter your last name",
                          prefixIcon: Icons.person,
                        ),
                      ),

                      const SizedBox(height: 14),

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
                        validator: (value) =>
                            Validators.validatePassword(value),
                        obscureText: inputPassword,
                        decoration:
                            textInputField(
                              "Create a password",
                              prefixIcon: Icons.lock_outlined,
                            ).copyWith(
                              // Toggle Password Visibility Icon
                              suffixIcon: IconButton(
                                icon: Icon(
                                  inputPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    inputPassword = !inputPassword;
                                  });
                                },
                              ),
                            ),
                      ),

                      const SizedBox(height: 14),

                      // Confirm Password Field
                      TextFormField(
                        controller: confirmPasswordController,
                        validator: (value) =>
                            Validators.validateConfirmPassword(
                              value,
                              passwordController.text,
                            ),
                        obscureText: confirmInputPassword,
                        decoration:
                            textInputField(
                              "Re-type your password",
                              prefixIcon: Icons.lock_outlined,
                            ).copyWith(
                              // Toggle Password Visibility Icon
                              suffixIcon: IconButton(
                                icon: Icon(
                                  confirmInputPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    confirmInputPassword = !confirmInputPassword;
                                  });
                                },
                              ),
                            ),
                      ),

                      const SizedBox(height: 8),

                      // Legal Disclaimer Checkbox
                      CheckboxListTile(
                        value: _legalDisclaimer,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _legalDisclaimer = value;
                          });
                        },
                        title: const Text.rich(
                          TextSpan(
                            text: 'By signing up, you agree to our ',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Service ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: 'and ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        activeColor: const Color(0xFFE9B63B),
                      ),

                      const SizedBox(height: 15),

                      // Sign Up Button
                      ListenableBuilder(
                        listenable: signupVM,
                        builder: (context, child) {
                          return SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Button(
                              text: signupVM.isLoading
                                  ? "Loading..."
                                  : "Start Learning",
                              onPressed: () async {
                                // Prevent Multiple Submissions
                                if (signupVM.isLoading) return;
                                // Validate Form
                                if (!_signupFormKey.currentState!.validate()) {
                                  return;
                                }
                                // Validate Checkbox
                                if (!_legalDisclaimer) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "You must agree to the Terms of Service.",
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                await signupVM.signup(
                                  firstName: firstNameController.text.trim(),
                                  lastName: lastNameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  confirmPassword: confirmPasswordController.text.trim(),
                                );
                                if (signupVM.errorMessage != null) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(signupVM.errorMessage!),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    Navigator.pushNamed(context, '/');
                                  }
                                }
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // Already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          const SizedBox(width: 6),

                          // Login Text Button
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text(
                              "Login",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
