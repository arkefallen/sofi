import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sofi/presentation/provider/detail_story_provider.dart';
import 'package:sofi/presentation/state/detail_story_state.dart';

class DetailStoryScreen extends StatefulWidget {
  final String storyId;

  const DetailStoryScreen({super.key, required this.storyId});

  @override
  DetailStoryScreenState createState() => DetailStoryScreenState();
}

class DetailStoryScreenState extends State<DetailStoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<DetailStoryProvider>().fetchDetailStory(widget.storyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<DetailStoryProvider>(
          builder: (context, value, child) {
            if (value.state is DetailStoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (value.state is DetailStoryError) {
              return Center(
                child: Text(
                  "Get story data failed. \n${(value.state as DetailStoryError).message}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.red,
                      ),
                ),
              );
            } else if (value.state is DetailStorySuccess) {
              final story = (value.state as DetailStorySuccess).data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_circle,
                            size: 36.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            story.name.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      Text(
                        formatDate(story.createdAt.toString()),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          story.photoUrl.toString(),
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.error,
                              size: 48.0,
                              color: Theme.of(context).colorScheme.error,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    story.description.toString(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  String formatDate(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime);
    final DateFormat formatter = DateFormat('EEE, dd MMM yyyy');
    return formatter.format(parsedDate);
  }
}
