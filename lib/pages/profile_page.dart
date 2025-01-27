import 'package:feedback/cubits/auth_cubit.dart';
import 'package:feedback/cubits/user_feedback_cubit.dart';
import 'package:feedback/models/feedback_model.dart';
import 'package:feedback/pages/feedback_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'feedback_widget.dart';

class Profile extends StatefulWidget {
  String id;
  Profile({super.key, required this.id});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    super.initState();
    context.read<UserFeedbackCubit>().getFeedbacks(widget.id);
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
                if (state is LoginSuccess) {
                  return Container(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.3,
                      right: MediaQuery.of(context).size.width * 0.3,
                      top: 50,
                      bottom: 50,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.account_circle, size: 90,),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.user.name, style: Theme.of(context).textTheme.titleLarge),
                                Text('level: 0', style: Theme.of(context).textTheme.labelMedium),
                                Text(state.user.profession, style: Theme.of(context).textTheme.labelMedium),
                              ],
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                              },
                              child: const Text('Edit Profile', style: TextStyle(color: Colors.red)),
                            )
                          ],
                        ),
                        const SizedBox(height: 40),
                        Text('Feedbacks', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 24)),
                        BlocBuilder<UserFeedbackCubit, List<Feedbacks>>(
                          builder: (context, feedbacks) {
                            if (feedbacks.isNotEmpty) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: feedbacks.length,
                                itemBuilder: (context, index) {
                                  final feedback = feedbacks[index];
                                  return Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Theme.of(context).colorScheme.primary,
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
                                        const SizedBox(height: 25),
                                        Text(feedback.description, style: Theme.of(context).textTheme.labelMedium),
                                        const SizedBox(height: 25),
                                        BlocBuilder<AuthCubit, LoginState>(
                                            builder: (context, state) {
                                              return Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                    },
                                                    icon:  Icon(Icons.thumb_up_alt_outlined, color: Theme.of(context).colorScheme.secondary),
                                                  ),
                                                  Text(feedback.upvotes.toString(), style: Theme.of(context).textTheme.labelSmall),
                                                  const SizedBox(width: 25),
                                                  IconButton(
                                                    onPressed: () {
                                                    },
                                                    icon: Icon(Icons.thumb_down_alt_outlined, color: Theme.of(context).colorScheme.secondary),
                                                  ),
                                                  Text(feedback.downvotes.toString(), style: Theme.of(context).textTheme.labelSmall),
                                                  const SizedBox(width: 25),
                                                  IconButton(
                                                    onPressed: () async {
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
                                  );
                                },
                              );
                            } else {
                              return const Text('No feedbacks yet');
                            }
                          },
                        )
                      ],
                    ),
                  );
                } else {
                  return const Text('Not Logged In');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
