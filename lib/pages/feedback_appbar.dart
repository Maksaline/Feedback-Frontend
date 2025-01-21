import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubits/auth_cubit.dart';

class FeedbackAppbar extends StatefulWidget {
  const FeedbackAppbar({super.key});

  @override
  State<FeedbackAppbar> createState() => _FeedbackAppbarState();
}

class _FeedbackAppbarState extends State<FeedbackAppbar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      expandedHeight: 80,
      collapsedHeight: 80,
      pinned: true,
      automaticallyImplyLeading: false,
      shadowColor: Theme.of(context).colorScheme.secondary,
      flexibleSpace: FlexibleSpaceBar(
          background: Container(
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.go('/');
                    },
                    child: SizedBox(
                      height: 50,
                      width: 200,
                      child: Image.asset(
                        'assets/images/logo_text.png',
                        fit: BoxFit.contain,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Providers',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(width: 25),
                      Text(
                        'Top Rated',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(width: 25),
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  BlocBuilder<AuthCubit, LoginState>(
                      builder: (context, state) {
                        if(state is LoginSuccess){
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Log Out'),
                                  content: const Text('Are you sure you want to log out?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        context.read<AuthCubit>().logout();
                                        context.go('/');
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Log Out'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  state.user.name,
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.account_circle,
                                  color: Theme.of(context).colorScheme.secondary,
                                  size: 40,
                                ),
                              ],
                            ),
                          );
                        }
                        else {
                          return Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: BorderSide(
                                    color: Theme.of(context).colorScheme.secondary,
                                    width: 1,
                                  ),
                                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                                  fixedSize: const Size(130, 50),
                                ),
                                onPressed: () {
                                  context.go('/login');
                                },
                                child: Text(
                                  'Log In',
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  context.go('/signup');
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                                  fixedSize: const Size(130, 50),
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.surface),
                                ),
                              ),
                            ],
                          );
                        }
                      }
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}
