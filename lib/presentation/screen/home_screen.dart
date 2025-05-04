import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofi/core/l10n/l10n.dart';
import 'package:sofi/core/navigation/page_manager.dart';
import 'package:sofi/presentation/provider/list_story_provider.dart';
import 'package:sofi/presentation/state/list_story_state.dart';
import 'package:sofi/presentation/widget/story_item.dart';

class HomeScreen extends StatefulWidget {
  final Function() toAddStoryScreen;
  final Function() toSettingsScreen;
  final Function() toLoginScreen;
  final Function(String) toDetailStoryScreen;

  const HomeScreen(
      {super.key,
      required this.toAddStoryScreen,
      required this.toSettingsScreen,
      required this.title,
      required this.toLoginScreen,
      required this.toDetailStoryScreen});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        if (context.watch<ListStoryProvider>().pageItems != null) {
          context.read<ListStoryProvider>().fetchListStories();
        }
      }
    });

    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<ListStoryProvider>().fetchListStories();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              widget.toSettingsScreen();
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
                if (value.state is ListStoryLoading && value.pageItems == 1) {
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
                  return ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        if (value.pageItems != null &&
                            index == stories.length) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: StoryItem(
                            imageUrl: stories[index].photoUrl,
                            username: stories[index].name,
                            storyText: stories[index].description,
                            id: stories[index].id,
                            toDetailStoryScreen: (String storyId) {
                              widget.toDetailStoryScreen(storyId);
                            },
                          ),
                        );
                      },
                      itemCount:
                          stories.length + (value.pageItems != null ? 1 : 0),
                      shrinkWrap: true);
                }
                return const SizedBox.shrink();
              },
            )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          widget.toAddStoryScreen();
          final resultFromAddStoryScreen =
              await context.read<PageManager>().waitForAddStoryResult();
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(resultFromAddStoryScreen),
              duration: const Duration(seconds: 2),
            ),
          );
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
