import 'package:feedback/cubits/comment_cubit.dart';
import 'package:feedback/cubits/feedback_cubit.dart';
import 'package:feedback/cubits/reply_cubit.dart';
import 'package:feedback/models/provider_model.dart';
import 'package:feedback/pages/feedback_appbar.dart';
import 'package:flutter/material.dart';
import 'package:feedback/models/feedback_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubits/auth_cubit.dart';
import '../cubits/provider_cubit.dart';
import 'feedback_widget.dart';

class ProviderPage extends StatefulWidget {
  final Provider provider;
  const ProviderPage({super.key, required this.provider});

  @override
  State<ProviderPage> createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {

  final TextEditingController _feedbackController = TextEditingController();

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

  bool _isLiked(Provider provider, LoginState state) {
    if(state is! LoginSuccess) return false;
    return provider.posFeedbacks.contains(state.user.id);
  }

  bool _isDisliked(Provider provider, LoginState state) {
    if(state is! LoginSuccess) return false;
    return provider.negFeedbacks.contains(state.user.id);
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

  @override
  void initState() {
    super.initState();
    context.read<FeedbackCubit>().getFeedbacks(widget.provider.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const FeedbackAppbar(),
              SliverToBoxAdapter(
                child: BlocSelector<ProviderCubit, List<Provider>, Provider>(
                  selector: (state) => state.firstWhere(
                      (element) => element.id == widget.provider.id,
                  ),
                  builder: (context, provider) {
                    return Container(
                      padding: EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                          right: MediaQuery.of(context).size.width * 0.18,
                          left: MediaQuery.of(context).size.width * 0.18
                        ),
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
                              Text(provider.name, style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(width: 20,),
                              Container(
                                padding: const EdgeInsets.all(5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                                ),
                                child: Text(
                                    provider.type.toString(),
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
                          Text('${provider.total} feedbacks', style: Theme.of(context).textTheme.labelSmall),
                          const SizedBox(height: 25),
                          Text(provider.description, style: Theme.of(context).textTheme.labelMedium),
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
                                      flex: (provider.positive * 10).round(),
                                      child: Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade600,
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(10),
                                            bottomLeft: const Radius.circular(10),
                                            topRight: provider.negative == 0 ? const Radius.circular(10) : Radius.zero,
                                            bottomRight: provider.negative == 0 ? const Radius.circular(10) : Radius.zero,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Flexible(
                                      flex: (provider.negative * 10).round(),
                                      child: Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade600,
                                          borderRadius: BorderRadius.only(
                                            topRight: const Radius.circular(10),
                                            bottomRight: const Radius.circular(10),
                                            topLeft: provider.positive == 0 ? const Radius.circular(10) : Radius.zero,
                                            bottomLeft: provider.positive == 0 ? const Radius.circular(10) : Radius.zero,
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
                              Text(provider.age, style: Theme.of(context).textTheme.labelSmall),
                              const Spacer(),
                              BlocBuilder<AuthCubit, LoginState>(
                                  builder: (context, state) {
                                    return Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            _posFeedback(provider, state);
                                          },
                                          icon: (_isLiked(provider, state))
                                              ? Icon(Icons.thumb_up, color: Colors.green.shade600)
                                              : Icon(Icons.thumb_up_alt_outlined, color: Theme.of(context).colorScheme.secondary),
                                        ),
                                        Text(provider.positive.toString(), style: Theme.of(context).textTheme.labelSmall),
                                        const SizedBox(width: 25),
                                        IconButton(
                                          onPressed: () {
                                            _negFeedback(provider, state);
                                          },
                                          icon: (_isDisliked(provider, state))
                                              ? Icon(Icons.thumb_down, color: Colors.red.shade600)
                                              : Icon(Icons.thumb_down_alt_outlined, color: Theme.of(context).colorScheme.secondary),
                                        ),
                                        Text(provider.negative.toString(), style: Theme.of(context).textTheme.labelSmall),
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
                    );
                  }
                ),
              ),
              SliverToBoxAdapter(
                child: BlocBuilder<FeedbackCubit, List<Feedbacks>>(
                  builder: (context, feedbacks) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
                      child: ListView(
                        primary: false,
                        shrinkWrap: true,
                        children: feedbacks.map(
                            (feedback) => FeedbackWidget(feedback: feedback, parentId: widget.provider.id,)
                        ).toList(),
                      ),
                    );
                  },
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                ),
              )
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            child: Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.2,
                right: MediaQuery.of(context).size.width * 0.2,
                top: 8,
                bottom: 8,
              ),
              child: BlocBuilder<ReplyCubit, ReplyState>(
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Wrap(
                      children: [
                        if(state is ReplySet)
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Replying to ${state.feedback.name}', style: Theme.of(context).textTheme.labelMedium),
                                const SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {
                                    context.read<ReplyCubit>().clearFeedback();
                                  },
                                  icon: Icon(Icons.close, color: Theme.of(context).colorScheme.secondary),
                                ),
                              ],
                            ),
                          ),
                        BlocBuilder<AuthCubit, LoginState>(
                          builder: (context, userState) {
                            return TextField(
                              controller: _feedbackController,
                              decoration: InputDecoration(
                                hintText: 'Write a feedback',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    if(_feedbackController.text.isEmpty) return;
                                    if(state is ReplyInitial) {
                                      if(userState is LoginSuccess) {
                                        context.read<FeedbackCubit>().giveFeedback(widget.provider.id, userState.user.id, _feedbackController.text);
                                      }
                                      else {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return buildDialog(context);
                                            }
                                        );
                                      }
                                    } else if(state is ReplySet) {
                                      if(userState is LoginSuccess) {
                                        context.read<CommentCubit>().addComment(state.feedback.id, userState.user.id, _feedbackController.text);
                                        context.read<FeedbackCubit>().getFeedbacks(widget.provider.id);
                                      }
                                      else {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return buildDialog(context);
                                            }
                                        );
                                      }
                                    }
                                    _feedbackController.clear();
                                    context.read<ReplyCubit>().clearFeedback();
                                  },
                                  icon: Icon(Icons.send, color: Theme.of(context).colorScheme.secondary),
                                ),
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
          )
        ],
      )
    );
  }
}
