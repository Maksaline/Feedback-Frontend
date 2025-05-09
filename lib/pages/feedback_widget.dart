import 'package:feedback/cubits/comment_cubit.dart';
import 'package:feedback/cubits/feedback_cubit.dart';
import 'package:feedback/cubits/reply_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubits/auth_cubit.dart';
import '../models/feedback_model.dart';

class FeedbackWidget extends StatefulWidget {
  final Feedbacks feedback;
  final double padding;
  final int level;
  final String parentId;
  const FeedbackWidget({super.key, required this.feedback, this.padding = 20, this.level = 0, required this.parentId});

  @override
  State<FeedbackWidget> createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {

  void _giveUpvote(Feedbacks feedback, LoginState state) {
    if(state is! LoginSuccess) {
      showDialog(
          context: context,
          builder: (context) {
            return buildDialog(context);
          }
      );
    }
    else {
      if(widget.level == 0) {
        context.read<FeedbackCubit>().giveVote(feedback.id, state.user.id, true, widget.parentId);
      } else {
        context.read<CommentCubit>().giveVote(feedback.id, state.user.id, true, widget.parentId);
      }
    }
  }

  void _giveDownVote(Feedbacks feedback, LoginState state) {
    if(state is! LoginSuccess) {
      showDialog(
          context: context,
          builder: (context) {
            return buildDialog(context);
          }
      );
    }
    else {
      if(widget.level == 0) {
        context.read<FeedbackCubit>().giveVote(feedback.id, state.user.id, false, widget.parentId);
      } else {
        context.read<CommentCubit>().giveVote(feedback.id, state.user.id, false, widget.parentId);
      }
    }
  }

  bool _isLiked(Feedbacks feedback, LoginState state) {
    if(state is! LoginSuccess) return false;
    return feedback.upvoters.contains(state.user.id);
  }

  bool _isDisliked(Feedbacks feedback, LoginState state) {
    if(state is! LoginSuccess) return false;
    return feedback.downvoters.contains(state.user.id);
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

  bool _showReplies = false;
  @override
  Widget build(BuildContext context) {
    final feedback = widget.feedback;
    return Container(
      decoration: BoxDecoration(
        border: (widget.level > 0) ? Border(left: BorderSide(color: Theme.of(context).colorScheme.outline, width: 2)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: (feedback.name.endsWith('b')) ? Theme.of(context).colorScheme.primary : Colors.blueGrey,
                      child: Icon(Icons.person, color: Theme.of(context).colorScheme.surface),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(feedback.name, style: Theme.of(context).textTheme.labelMedium),
                        Text(feedback.age, style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.more_vert_rounded, color: Theme.of(context).colorScheme.secondary),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Text(feedback.description, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 15),
                BlocBuilder<AuthCubit, LoginState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _giveUpvote(feedback, state);
                          },
                          icon: (_isLiked(feedback, state))
                              ? Icon(Icons.thumb_up, color: Colors.green.shade600)
                              : Icon(Icons.thumb_up_alt_outlined, color: Theme.of(context).colorScheme.secondary),
                        ),
                        Text(feedback.upvotes.toString(), style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(width: 25),
                        IconButton(
                          onPressed: () {
                            _giveDownVote(feedback, state);
                          },
                            icon: (_isDisliked(feedback, state))
                                ? Icon(Icons.thumb_down, color: Colors.red.shade600)
                                : Icon(Icons.thumb_down_alt_outlined, color: Theme.of(context).colorScheme.secondary),
                        ),
                        Text(feedback.downvotes.toString(), style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(width: 25),
                        IconButton(
                          onPressed: () async {
                            context.read<ReplyCubit>().setFeedback(feedback, widget.parentId);
                            if(feedback.comments == 0) {
                              return;
                            }
                            context.read<CommentCubit>().getComments(feedback.id);
                            setState(() {
                              _showReplies = !_showReplies;
                            });
                          },
                          icon: Icon(Icons.comment_outlined, color: Theme.of(context).colorScheme.secondary),
                        ),
                        Text(feedback.comments.toString(), style: Theme.of(context).textTheme.labelSmall),
                      ],
                    );
                  }
                ),
              ],
            ),
          ),
          if (_showReplies)
            BlocBuilder<CommentCubit, Map<String, List<Feedbacks>>>(
              builder: (context, comments) {
                final comment = comments[feedback.id];
                if (comment == null) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Column(
                    children: [
                      for (var i = 0; i < comment.length; i++)
                        FeedbackWidget(
                          feedback: comment[i],
                          padding: widget.padding,
                          level: widget.level + 1,
                          parentId: feedback.id,
                        ),
                    ],
                  ),
                );
              }
            ),
        ],
      ),
    );
  }
}
