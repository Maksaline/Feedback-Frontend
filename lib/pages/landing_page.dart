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
  final TextEditingController _searchController = TextEditingController();
  bool searched = false;
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
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Your feedback\nmatters', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 64)),
                                const SizedBox(height: 25),
                                Text('Here, users are the source of all information...', style: Theme.of(context).textTheme.labelMedium),
                              ],
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
            child: Container(
              color: Color(0xFFF4F5F6),
              height: 140,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: const EdgeInsets.only(left: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                      border: Border.all(color: Theme.of(context).colorScheme.outline, width: 0.4),
                    ),
                    child: Row(
                      children: [
                        (!searched) ? Icon(Icons.search, color: Colors.grey)
                            : IconButton(
                          icon: Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            context.read<ProviderCubit>().getProviders();
                            setState(() {
                              searched = false;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
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
                              context.read<ProviderCubit>().searchProviders(_searchController.text);
                              setState(() {
                                searched = true;
                              });
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
            child: Container(
              color: const Color(0xFFF4F5F6),
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.15,
                  right: MediaQuery.of(context).size.width * 0.15,
                  bottom: 20,
                ),
                child: BlocBuilder<ProviderCubit, List<Provider>>(
                  builder: (context, providers) {
                    return GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: providers.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 2.32,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            context.go('/provider', extra: providers[index]);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(color: Theme.of(context).colorScheme.outline, width: 0.4),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
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
                                SizedBox(
                                  height: 50,
                                    child: Text(providers[index].description, style: Theme.of(context).textTheme.labelMedium)
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 350,
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
                                const SizedBox(height: 20),
                                Divider(
                                  color: Theme.of(context).colorScheme.outline,
                                  thickness: 1,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
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
                        );
                      },
                    );
                  }
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: BlocBuilder<AuthCubit, LoginState>(
        builder: (context, state) {
          if(state is LoginSuccess) {
            return FloatingActionButton.extended(
            onPressed: () {
              context.go('/add-provider');
            },
            label: Text('Create New Provider', style: TextStyle(color: Theme.of(context).colorScheme.surface),),
            icon: const Icon(Icons.create_rounded, color: Colors.white),
            backgroundColor: Theme.of(context).colorScheme.primary,
          );
          } else {
            return const SizedBox();
          }
        }
      ),
    );
  }
}
