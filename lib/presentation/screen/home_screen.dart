import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofi/presentation/provider/list_story_provider.dart';
import 'package:sofi/presentation/state/list_story_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<ListStoryProvider>().fetchListStories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<ListStoryProvider>(
              builder: (context, value, child) {
                if (value.state is ListStoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (value.state is ListStoryError) {
                  return Center(
                    child: Text(
                      (value.state as ListStoryError).message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.red,
                          ),
                    ),
                  );
                } else if (value.state is ListStorySuccess) {
                  final stories = (value.state as ListStorySuccess).stories;
                  return Column(
                    children: stories
                        .map((story) => Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: StoryItem(
                                imageUrl: story.photoUrl,
                                username: story.name,
                                storyText: story.description,
                              ),
                            ))
                        .toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            )),
      ),
    );
  }
}

class StoryItem extends StatelessWidget {
  final String? imageUrl;
  final String? username;
  final String? storyText;
  const StoryItem({
    super.key,
    this.imageUrl,
    this.username,
    this.storyText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 400,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              imageUrl.toString(),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 64,
            child: Text(
              storyText.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.person, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  username.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
