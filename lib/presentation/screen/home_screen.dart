import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofi/core/l10n/l10n.dart';
import 'package:sofi/presentation/provider/list_story_provider.dart';
import 'package:sofi/presentation/screen/add_story_screen.dart';
import 'package:sofi/presentation/screen/settings_screen.dart';
import 'package:sofi/presentation/state/list_story_state.dart';
import 'package:sofi/presentation/widget/story_item.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String? message =
          ModalRoute.of(context)?.settings.arguments as String?;
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 2),
          ),
        );
      }
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SettingsScreen();
              }));
            },
            icon: const Icon(Icons.settings),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
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
                                id: story.id,
                              ),
                            ))
                        .toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddStoryScreen();
          }));
        },
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.addStory),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
