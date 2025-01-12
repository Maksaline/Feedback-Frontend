import 'package:feedback/cubits/provider_cubit.dart';
import 'package:feedback/cubits/theme_cubit.dart';
import 'package:feedback/pages/landing_page.dart';
import 'package:feedback/pages/login_page.dart';
import 'package:feedback/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(BlocProvider(
    create: (context) =>
    ThemeCubit()
      ..updateTheme(
          Brightness.light)
    ,
    child: const MyApp(),
  ));
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingPage(),
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: '/signup',
            builder: (context, state) => const SignupPage(),
          )
        ]
    ),
    // ShellRoute(
    //   builder: (context, state, child) {
    //     return const LandingPage();
    //   },
    //   routes: [
    //     GoRoute(
    //       path: '/login',
    //       builder: (context, state) => const LoginPage(),
    //     ),
    //     GoRoute(
    //       path: '/signup',
    //       builder: (context, state) => const SignupPage(),
    //     )
    //   ]
    // )
  ]
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, theme) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ProviderCubit())
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Feedback',
            theme: theme,
            routerConfig: _router,
          ),
        );
      },
    );
  }
}