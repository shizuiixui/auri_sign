import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/core/widgets/text_input_field.dart';
import '/core/utils/validators.dart';
import '/core/widgets/button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final List<GlobalKey<FormState>> _formKeys = List.generate(
    4,
    (_) => GlobalKey<FormState>(),
  );

  int currentPage = 0;
  final PageController _controller = PageController();
  final emailController = TextEditingController();
  bool obscurePassword = true;

  // Data for each page
  final List<Map<String, dynamic>> _forgotPassword = [
    {
      "title": "Forgot Password",
      "description":
          "Please enter the email address associated with your account.",
    },
    {
      "title": "OTP Verification",
      "description": "Please enter the 4 digit code sent to your email.",
    },
    {
      "title": "Create Your New Password",
      "description":
          "Your new password must be different from previous password.",
    },
    {
      "title": "Password Reset",
      "description":
          "Your password has been successfully reset. You can now log in with your new password.",
    },
  ];

  Widget _buildInputForPage(int index) {
    switch (index) {
      // Email Page
      case 0:
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: TextFormField(
            controller: emailController,
            validator: (value) => Validators.validateEmail(value),
            keyboardType: TextInputType.emailAddress,
            decoration: textInputField(
              "Enter your email",
              prefixIcon: Icons.email_outlined,
            ),
          ),
        );

      // OTP Page
      case 1:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (i) {
              return SizedBox(
                width: 50,
                height: 60,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    if (value.length == 1 && i < 3) {
                      FocusScope.of(context).nextFocus();
                    } else if (value.isEmpty && i > 0) {
                      FocusScope.of(context).previousFocus();
                    }
                  },
                  decoration: textInputField(
                    "",
                  ).copyWith(errorStyle: const TextStyle(height: 0)),
                ),
              );
            }),
          ),
        );

      // New Password Page
      case 2:
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              TextFormField(
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => Validators.validatePassword(value),
                decoration:
                    textInputField(
                      "New Password",
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
              TextFormField(
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => Validators.validatePassword(value),
                decoration:
                    textInputField(
                      "Confirm Password",
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
            ],
          ),
        );

      // Success Page
      case 3:
        return Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Center(
            child: Column(
              children: [
                Center(
                  child: const Text(
                    "Password Updated Successfully",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _forgotPassword[index]['description'] ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      appBar: AppBar(
        title: const Text(
          "Forgot Password",
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'KantumruyPro-Regular',
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: PageView.builder(
          itemCount: _forgotPassword.length,
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final pageData = _forgotPassword[index];

            return Form(
              key: _formKeys[index],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index != 3) ...[
                      Text(
                        pageData['title'],
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        pageData['description'] ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'KantumruyPro-Regular',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],

                    _buildInputForPage(index),

                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Button(
                        text: index == 2
                            ? "Reset Password"
                            : (index == 3 ? "Back to Login" : "Next"),
                        onPressed: () {
                          if (_formKeys[index].currentState!.validate()) {
                            if (index < _forgotPassword.length - 1) {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              setState(() {
                                currentPage = index + 1;
                              });
                            } else {
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
