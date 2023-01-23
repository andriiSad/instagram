import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  final AssetImage _defaultImage =
      const AssetImage("assets/default_avatar.png");

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();

    super.dispose();
  }

  void _selectImage() async {
    Uint8List? im = await tryToPickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void _signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    _image ??= await imageToUint8list("assets/default_avatar.png");
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });
    if (res != 'success' && mounted) {
      showSnackBar(res, context);
    } else {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: deviceSize.height * 0.04,
                  ),
                  SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    color: primaryColor,
                    height: deviceSize.height * 0.07,
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.02,
                  ),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: deviceSize.height * 0.07,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : CircleAvatar(
                              radius: deviceSize.height * 0.07,
                              backgroundImage: _defaultImage,
                            ),
                      Positioned(
                          bottom: -10,
                          left: 50,
                          child: IconButton(
                            onPressed: _selectImage,
                            icon: const Icon(
                              Icons.add_a_photo,
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                    textEditingController: _usernameController,
                    hintText: 'Enter your username',
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                    textEditingController: _emailController,
                    hintText: 'Enter your email',
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                    textEditingController: _passwordController,
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                    textEditingController: _bioController,
                    hintText: 'Enter your bio',
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    onTap: _signUpUser,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        color: blueColor,
                      ),
                      child: SizedBox(
                        height: 32,
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: primaryColor,
                                )
                              : const Text('Sign Up'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text("Already have an account?"),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        GestureDetector(
                          onTap: navigateToLogin,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Text(
                              "Log in.",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
