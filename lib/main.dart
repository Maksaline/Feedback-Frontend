import 'package:feedback/cubits/add_provider_cubit.dart';
import 'package:feedback/cubits/auth_cubit.dart';
import 'package:feedback/cubits/comment_cubit.dart';
import 'package:feedback/cubits/provider_cubit.dart';
import 'package:feedback/cubits/sign_up_cubit.dart';
import 'package:feedback/cubits/theme_cubit.dart';
import 'package:feedback/cubits/user_feedback_cubit.dart';
import 'package:feedback/models/provider_model.dart';
import 'package:feedback/pages/add_provider_page.dart';
import 'package:feedback/pages/landing_page.dart';
import 'package:feedback/pages/login_page.dart';
import 'package:feedback/pages/profile_page.dart';
import 'package:feedback/pages/provider_page.dart';
import 'package:feedback/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'cubits/feedback_cubit.dart';
import 'cubits/reply_cubit.dart';

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
          ),
          GoRoute(
            path: '/provider',
            builder: (context, state) {
              final provider = state.extra as Provider;
              return ProviderPage(provider: provider);
            }
          ),
          GoRoute(
            path: '/add-provider',
            builder: (context, state) => const AddProvider(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) {
              final id = state.extra as String;
              return Profile(id: id);
            }
          )
        ]
    ),
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
            BlocProvider(create: (context) => ProviderCubit()),
            BlocProvider(create: (context) => AuthCubit()),
            BlocProvider(create: (context) => SignUpCubit()),
            BlocProvider(create: (context) => FeedbackCubit()),
            BlocProvider(create: (context) => CommentCubit()),
            BlocProvider(create: (context) => ReplyCubit()),
            BlocProvider(create: (context) => AddProviderCubit()),
            BlocProvider(create: (context) => UserFeedbackCubit()),
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