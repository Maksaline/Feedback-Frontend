import 'package:feedback/cubits/auth_cubit.dart';
import 'package:feedback/cubits/provider_cubit.dart';
import 'package:feedback/main.dart';
import 'package:feedback/models/provider_model.dart';
import 'package:feedback/pages/feedback_appbar.dart';
import 'package:feedback/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'login_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderCubit>().getProviders();
  }

  void _posFeedback(Provider provider, LoginState state) {
    if(state is! LoginSuccess) {
      showDialog(
        context: context,
        builder: (context) {
          return buildDialog(context);
        }
      );
    }
    else {
      context.read<ProviderCubit>().updateVotes(provider.id, state.user.id, true);
    }
  }

  void _negFeedback(Provider provider, LoginState state) {
    if(state is! LoginSuccess) {
      showDialog(
        context: context,
        builder: (context) {
          return buildDialog(context);
        }
      );
    }
    else {
      context.read<ProviderCubit>().updateVotes(provider.id, state.user.id, false);
    }
  }

  Dialog buildDialog(BuildContext context) {
    return Dialog(
          child: Container(
            height: 500,
            width: 500,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text('Oops!', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 25),
                Text('Looks like you haven\'t logged in. You need to be logged in to provide feedback', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 25),
                const Text('By continuing, you agree to our User Agreement and acknowledge that you understand the Privacy Policy. '),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    context.pop();
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    fixedSize: const Size(330, 50),
                  ),
                  child: Text(
                    'Log In',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.surface),
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    fixedSize: const Size(330, 50),
                  ),
                  onPressed: () {
                    context.pop();
                    context.go('/signup');
                  },
                  child: Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ],
            ),
          ),
        );
  }

  bool _isLiked(Provider provider, LoginState state) {
    if(state is! LoginSuccess) return false;
    return provider.posFeedbacks.contains(state.user.id);
  }

  bool _isDisliked(Provider provider, LoginState state) {
    if(state is! LoginSuccess) return false;
    return provider.negFeedbacks.contains(state.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const FeedbackAppbar(),
          SliverToBoxAdapter(
            child: BlocBuilder<AuthCubit, LoginState>(
              builder: (context, state) {
                if(state is! LoginSuccess) {
                  return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: Text('Your feedback\nmatters', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 64)),
                          ),
                          Icon(
                            Icons.feedback,
                            size: MediaQuery.of(context).size.width / 8,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                }
                else {
                  return const SizedBox();
                }
              }
            )
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: const EdgeInsets.only(left: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 8.0,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search for providers',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.search, color: Theme.of(context).colorScheme.secondary),
                            onPressed: () {
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: MediaQuery.of(context).size.width * 0.15,
                right: MediaQuery.of(context).size.width * 0.15,
                bottom: 20,
              ),
              child: BlocBuilder<ProviderCubit, List<Provider>>(
                builder: (context, providers) {
                  return ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: providers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            context.go('/provider', extra: providers[index]);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
                                  blurRadius: 9.0,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(providers[index].name, style: Theme.of(context).textTheme.titleLarge),
                                    const SizedBox(width: 20,),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        border: Border.all(color: Theme.of(context).colorScheme.outline),
                                      ),
                                      child: Text(
                                          providers[index].type.toString(),
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: Theme.of(context).colorScheme.outline,
                                          )
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.more_vert_rounded, color: Theme.of(context).colorScheme.secondary),
                                    )
                                  ],
                                ),
                                Text('${providers[index].total} feedbacks', style: Theme.of(context).textTheme.labelSmall),
                                const SizedBox(height: 25),
                                Text(providers[index].description, style: Theme.of(context).textTheme.labelMedium),
                                const SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            flex: (providers[index].positive * 10).round(),
                                            child: Container(
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade600,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft: Radius.circular(10),
                                                  topRight: providers[index].negative == 0 ? const Radius.circular(10) : Radius.zero,
                                                  bottomRight: providers[index].negative == 0 ? const Radius.circular(10) : Radius.zero,
                                                ),
                                              ),
                                            ),
                                          ),

                                          Flexible(
                                            flex: (providers[index].negative * 10).round(),
                                            child: Container(
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade600,
                                                borderRadius: BorderRadius.only(
                                                  topRight: const Radius.circular(10),
                                                  bottomRight: const Radius.circular(10),
                                                  topLeft: providers[index].positive == 0 ? const Radius.circular(10) : Radius.zero,
                                                  bottomLeft: providers[index].positive == 0 ? const Radius.circular(10) : Radius.zero,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Divider(
                                  color: Theme.of(context).colorScheme.outline,
                                  thickness: 1,
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  children: [
                                    Text(providers[index].age, style: Theme.of(context).textTheme.labelSmall),
                                    const Spacer(),
                                    BlocBuilder<AuthCubit, LoginState>(
                                      builder: (context, state) {
                                        return Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                _posFeedback(providers[index], state);
                                              },
                                              icon: (_isLiked(providers[index], state))
                                                  ? Icon(Icons.thumb_up, color: Colors.green.shade600)
                                                  : Icon(Icons.thumb_up_alt_outlined, color: Theme.of(context).colorScheme.secondary),
                                            ),
                                            Text(providers[index].positive.toString(), style: Theme.of(context).textTheme.labelSmall),
                                            const SizedBox(width: 25),
                                            IconButton(
                                              onPressed: () {
                                                _negFeedback(providers[index], state);
                                              },
                                              icon: (_isDisliked(providers[index], state))
                                                  ? Icon(Icons.thumb_down, color: Colors.red.shade600)
                                                  : Icon(Icons.thumb_down_alt_outlined, color: Theme.of(context).colorScheme.secondary),
                                            ),
                                            Text(providers[index].negative.toString(), style: Theme.of(context).textTheme.labelSmall),
                                            const SizedBox(width: 25),
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.feedback_outlined, color: Theme.of(context).colorScheme.secondary),
                                            ),
                                            const SizedBox(width: 25),
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.share, color: Theme.of(context).colorScheme.secondary),
                                            ),
                                          ],
                                        );
                                      }
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              ),
            ),
          )
        ],
      ),
    );
  }
}
