import 'dart:async';

import 'package:balancika_demo/screens/main_shell.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

class RestaurantLoginScreen extends StatefulWidget {
  const RestaurantLoginScreen({super.key});

  @override
  State<RestaurantLoginScreen> createState() => _RestaurantLoginScreenState();
}

class _RestaurantLoginScreenState extends State<RestaurantLoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final String staticOtp = "123456";

  bool rememberMe = false;
  int countdown = 0;
  Timer? timer;

  static const Color primaryColor = Color(0xFF344256);
  static const Color backgroundColor = Color(0xFFFAF8FF);
  static const Color inputColor = Color(0xFFF1F2FF);

  void startCountdown() {
    timer?.cancel();

    setState(() {
      countdown = 60;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void getOtp() {
    if (phoneController.text.trim().isEmpty) {
      showMessage('Please enter your phone number');
      return;
    }

    startCountdown();
    showMessage('Your OTP code is 123456');
  }

  void verifyLogin() {
    if (phoneController.text.trim().isEmpty) {
      showMessage('Please enter your phone number');
      return;
    }

    if (otpController.text.trim().isEmpty) {
      showMessage('Please enter OTP');
      return;
    }

    if (otpController.text.trim() == staticOtp) {
      showMessage('Login successful!');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainShell()),
      );
    } else {
      showMessage('Invalid OTP. Please try again.');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    timer?.cancel();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildLoginForm(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Divider(
                        color: Colors.deepPurple.shade50,
                        thickness: 1.5,
                      ),
                    ),
                    _buildSignup(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: primaryColor, size: 26),
          ),
          const Text(
            'Restaurant',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          Container(
            width: 48,
            height: 48,
            color: Colors.white,
            child: Image.asset(
              'assets/images/balancika_logo.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.restaurant,
                  color: Colors.red,
                  size: 30,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFECEBFF), Color(0xFFF5EEFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        children: [
          Text(
            'Balancika Demo',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Sign in to continue to your account',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, color: Color(0xFF686879)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phone Number',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555567),
            ),
          ),
          const SizedBox(height: 7),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: '+1(555) 000-0000',
              hintStyle: const TextStyle(
                color: Color(0xFF85859A),
                fontSize: 15,
              ),
              prefixIcon: const Icon(
                Icons.phone_in_talk_outlined,
                size: 19,
                color: Color(0xFF85859A),
              ),
              filled: true,
              fillColor: inputColor,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 17,
                horizontal: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFB8BDF5),
                  width: 1.3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 17),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Verification Code',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555567),
                ),
              ),
              Text(
                countdown > 0
                    ? 'Resend OTP (${(countdown ~/ 60).toString().padLeft(2, '0')}:${(countdown % 60).toString().padLeft(2, '0')})'
                    : 'Resend OTP',
                style: const TextStyle(fontSize: 12, color: Color(0xFF85859A)),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Enter 6-digit code',
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF85859A),
                    ),
                    prefixIcon: const Icon(
                      Icons.pin_outlined,
                      size: 20,
                      color: Color(0xFF85859A),
                    ),
                    filled: true,
                    fillColor: inputColor,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFB8BDF5)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              SizedBox(
                height: 43,
                child: ElevatedButton(
                  onPressed: countdown > 0 ? null : getOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE2E5FF),
                    disabledBackgroundColor: const Color(0xFFE2E5FF),
                    foregroundColor: const Color(0xFF66718A),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Text(
                    'Get Code',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value ?? false;
                        });
                      },
                      activeColor: primaryColor,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Remember me',
                    style: TextStyle(fontSize: 14, color: Color(0xFF686879)),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  showMessage('Help signing in');
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Need help signing in?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: verifyLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Verify & Sign In',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, size: 21),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignup() {
    return Padding(
      padding: const EdgeInsets.only(top: 48, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account? ",
            style: TextStyle(fontSize: 15, color: Color(0xFF686879)),
          ),
          GestureDetector(
            onTap: () {
              showMessage('Navigate to Signup');
            },
            child: const Text(
              'Signup',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
