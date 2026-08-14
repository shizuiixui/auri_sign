import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/widgets/button.dart';
import '/core/widgets/text_input_field.dart';
import '/core/utils/validators.dart';
import '/core/utils/legal_texts.dart';
import '/features/auth/presentation/viewmodels/signup_view_models.dart';
import 'package:auri_sign/features/auth/presentation/screens/email_verification.dart';

class SignupForm extends StatefulWidget {
  final int? learnerType;
  final int? motivation;
  final int? communicationContext;
  final int? dailyTime;

  const SignupForm({
    super.key,
    this.learnerType,
    this.motivation,
    this.communicationContext,
    this.dailyTime,
  });

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

  late final TapGestureRecognizer _legalTapRecognizer;

  Widget _buildPasswordVisibilityIcon({
    required bool isVisible,
    required VoidCallback onPressed,
  }) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final iconSize = screenWidth < 600 ? 20.sp : 18.sp;
    final buttonSize = screenWidth < 600 ? 32.w : 28.w;

    return Padding(
      padding: EdgeInsets.only(right: 2.w),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          minWidth: buttonSize,
          minHeight: buttonSize,
        ),
        splashRadius: 18.r,
        iconSize: iconSize,
        icon: Icon(
          isVisible ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
          size: iconSize,
        ),
        onPressed: onPressed,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _legalTapRecognizer = TapGestureRecognizer()..onTap = _showLegalPopup;
  }

  // Dispose Controllers and Tap recognizer
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _legalTapRecognizer.dispose();
    super.dispose();
  }

  //  Popup Dialog
  Future<void> _showLegalPopup() async {
    bool hasScrolledToBottom = false;

    final agreed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Text(
                "Legal Agreements",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Scrollbar(
                  thumbVisibility: true,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!hasScrolledToBottom &&
                          scrollInfo.metrics.pixels >=
                              (scrollInfo.metrics.maxScrollExtent - 20)) {
                        setStateDialog(() {
                          hasScrolledToBottom = true;
                        });
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TERMS OF SERVICE
                          Text(
                            "Terms & Conditions",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE9B63B),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            LegalTexts.termsOfService,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
                          ),
                          Divider(
                            height: 40.h,
                            thickness: 1,
                            color: Colors.grey.shade300,
                          ),

                          // PRIVACY POLICY
                          Text(
                            "Privacy Policy",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE9B63B),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            LegalTexts.privacyPolicy,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, false), // User declined
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasScrolledToBottom
                        ? const Color(0xFFE9B63B)
                        : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: hasScrolledToBottom ? 2 : 0,
                  ),
                  onPressed: hasScrolledToBottom
                      ? () => Navigator.pop(context, true)
                      : null,
                  child: Text(
                    "I Agree",
                    style: TextStyle(
                      color: hasScrolledToBottom
                          ? Colors.white
                          : Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (agreed == true) {
      setState(() {
        _legalDisclaimer = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0XFFF8F8F8),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 48.h),
          child: Form(
            key: _signupFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Sign Up and Start Learning",
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        "Create an account to save your daily goal and start your first lesson.",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'PlusJakartaSans',
                        ),
                      ),
                      SizedBox(height: 20.h),

                      TextFormField(
                        controller: firstNameController,
                        textInputAction: TextInputAction.next,
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
                      SizedBox(height: 14.h),

                      TextFormField(
                        controller: lastNameController,
                        textInputAction: TextInputAction.next,
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
                      SizedBox(height: 14.h),

                      TextFormField(
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        validator: (value) => Validators.validateEmail(value),
                        keyboardType: TextInputType.emailAddress,
                        decoration: textInputField(
                          "name@example.com",
                          prefixIcon: Icons.email_outlined,
                        ),
                      ),
                      SizedBox(height: 14.h),

                      TextFormField(
                        controller: passwordController,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            Validators.validatePassword(value),
                        obscureText: inputPassword,
                        decoration:
                            textInputField(
                              "Create a password",
                              prefixIcon: Icons.lock_outlined,
                            ).copyWith(
                              errorMaxLines: 3,
                              suffixIcon: _buildPasswordVisibilityIcon(
                                isVisible: inputPassword,
                                onPressed: () => setState(
                                  () => inputPassword = !inputPassword,
                                ),
                              ),
                            ),
                      ),
                      SizedBox(height: 14.h),

                      TextFormField(
                        controller: confirmPasswordController,
                        textInputAction: TextInputAction.done,
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
                              suffixIcon: _buildPasswordVisibilityIcon(
                                isVisible: confirmInputPassword,
                                onPressed: () => setState(
                                  () => confirmInputPassword =
                                      !confirmInputPassword,
                                ),
                              ),
                            ),
                      ),
                      SizedBox(height: 8.h),

                      // Checkbox List Tile for Legal Disclaimer
                      CheckboxListTile(
                        value: _legalDisclaimer,
                        onChanged: (value) {
                          if (value == true) {
                            _showLegalPopup();
                          } else {
                            setState(() {
                              _legalDisclaimer = false;
                            });
                          }
                        },
                        title: Text.rich(
                          TextSpan(
                            text: 'By signing up, you agree to our ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Service ',
                                recognizer: _legalTapRecognizer,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFE9B63B),
                                ),
                              ),
                              TextSpan(
                                text: 'and ',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                recognizer: _legalTapRecognizer,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFE9B63B),
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
                      SizedBox(height: 15.h),

                      ListenableBuilder(
                        listenable: signupVM,
                        builder: (context, child) {
                          return SizedBox(
                            width: double.infinity,
                            height: 40.h,
                            child: Button(
                              text: signupVM.isLoading
                                  ? "Loading..."
                                  : "Start Learning",
                              onPressed: () async {
                                if (signupVM.isLoading) return;

                                if (!_signupFormKey.currentState!.validate())
                                  return;

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
                                  confirmPassword: confirmPasswordController
                                      .text
                                      .trim(),
                                  learnerType: widget.learnerType,
                                  motivation: widget.motivation,
                                  communicationContext:
                                      widget.communicationContext,
                                  dailyTime: widget.dailyTime,
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VerifyEmail(
                                          email: emailController.text.trim(),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFE9B63B),
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
