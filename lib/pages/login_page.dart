import 'package:feedback/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../responsive/responsive_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController pass = TextEditingController();
  final FocusNode _focus1 = FocusNode();
  final FocusNode _focus2 = FocusNode();
  bool isPassVisible = true;
  bool _isChecked = false;
  bool isLoading = false;
  
  void _logIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      await context.read<AuthCubit>().login(username.text, pass.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, LoginState>(
  listener: (context, state) {
    if(state is LoginSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Log in Successful'),
            ],
          ),
        ),
      );
      Future.delayed(const Duration(seconds: 1), () => context.pop());
    } else if(state is LoginFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.red),
              const SizedBox(width: 10),
              Text(state.error),
            ],
          ),
        ),
      );
    }
  },
  builder: (context, state) {
    return SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              height: MediaQuery.of(context).size.height,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Responsive.isMobile(context)
                      ? const SizedBox()
                      : SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: MediaQuery.of(context).size.width / 4,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  Container(
                    width: Responsive.isDesktop(context)
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.width,
                    color:
                    Theme.of(context).colorScheme.surface,
                    child: Center(
                      child: Container(
                        width: Responsive.isDesktop(context)
                            ? MediaQuery.of(context).size.width / 3
                            : MediaQuery.of(context).size.width / 1.25,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Responsive.isDesktop(context)
                                  ? const SizedBox()
                                  : Image.asset(
                                'assets/images/logo_text.png',
                                width: MediaQuery.of(context).size.width / 1.8,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Login',
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      fontSize: 28,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Please enter your Feedback credentials to log in.',
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    'Username',
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Container(
                                    height: 45,
                                    padding: const EdgeInsets.only(top: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                                    ),
                                    child: TextFormField(
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context).requestFocus(_focus2);
                                      },
                                      focusNode: _focus1,
                                      controller: username,
                                      style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: 'Username',
                                        hintStyle:
                                        const TextStyle(color: Colors.black54, fontSize: 15),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Password',
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                                    ),
                                    child: TextFormField(
                                      onFieldSubmitted: (value) {
                                        _logIn();
                                      },
                                      controller: pass,
                                      focusNode: _focus2,
                                      obscureText: isPassVisible,
                                      style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                        hintStyle:
                                        const TextStyle(color: Colors.black54, fontSize: 15),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isPassVisible = !isPassVisible;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.visibility,
                                            color:
                                            Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Checkbox(
                                        value: _isChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _isChecked = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Remember me',
                                        style: Theme.of(context).textTheme.labelSmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ElevatedButton(
                                    onPressed: () {
                                      _logIn();
                                    },
                                    style: ButtonStyle(
                                      fixedSize: WidgetStateProperty.all<Size>(
                                          const Size(800, 48)),
                                      backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Theme.of(context).colorScheme.primary),
                                      padding: WidgetStateProperty.all<
                                          EdgeInsetsGeometry>(
                                          const EdgeInsets.symmetric(
                                              horizontal: 50, vertical: 10)),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const FittedBox(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                        : FittedBox(
                                      child: Text(
                                        'Login',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Don\'t have an account?',
                                        style: Theme.of(context).textTheme.labelSmall,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.go('/signup');
                                        },
                                        child: Text(
                                          'Sign up',
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
      );
  },
),
    );
  }
}
