import 'package:flutter/material.dart';
import 'package:sofi/presentation/screen/detail_story_screen.dart';

class StoryItem extends StatelessWidget {
  final String? id;
  final String? imageUrl;
  final String? username;
  final String? storyText;
  const StoryItem(
      {super.key, this.imageUrl, this.username, this.storyText, this.id});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailStoryScreen(storyId: id.toString());
        }));
      },
      borderRadius: BorderRadius.circular(20),
      child: Stack(
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
                color: Theme.of(context).colorScheme.primaryContainer,
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
                  Icon(Icons.person,
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                  const SizedBox(width: 8),
                  Text(
                    username.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
