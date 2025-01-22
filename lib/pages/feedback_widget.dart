import 'package:flutter/material.dart';

import '../models/feedback_model.dart';

class FeedbackWidget extends StatefulWidget {
  final Feedbacks feedback;
  final double padding;
  final int level;
  const FeedbackWidget({super.key, required this.feedback, this.padding = 20, this.level = 0});

  @override
  State<FeedbackWidget> createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  bool _showReplies = false;
  @override
  Widget build(BuildContext context) {
    final feedback = widget.feedback;
    return Container(
      decoration: BoxDecoration(
        border: (widget.level > 0) ? Border(left: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 20),
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
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.thumb_up_alt_outlined, color: Theme.of(context).colorScheme.secondary),
                    ),
                    Text(feedback.upvotes.toString(), style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(width: 25),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.thumb_down_alt_outlined, color: Theme.of(context).colorScheme.secondary),
                    ),
                    Text(feedback.downvotes.toString(), style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(width: 25),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showReplies = !_showReplies;
                        });
                      },
                      icon: Icon(Icons.comment_outlined, color: Theme.of(context).colorScheme.secondary),
                    ),
                    Text(feedback.comments.toString(), style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ],
            ),
          ),
          if (_showReplies)
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Column(
                children: [
                  for (var i = 0; i < feedback.comments; i++)
                    FeedbackWidget(
                      feedback: feedback,
                      padding: widget.padding,
                      level: widget.level + 1,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}