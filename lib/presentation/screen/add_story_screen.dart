import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sofi/core/l10n/l10n.dart';
import 'package:sofi/presentation/navigation/page_manager.dart';
import 'package:sofi/presentation/provider/add_story_provider.dart';
import 'package:sofi/presentation/provider/list_story_provider.dart';
import 'package:sofi/presentation/state/add_story_state.dart';

class AddStoryScreen extends StatefulWidget {
  final Function() toHomeScreen;

  const AddStoryScreen({super.key, required this.toHomeScreen});

  @override
  AddStoryScreenState createState() => AddStoryScreenState();
}

class AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void checkButtonState() {
    context.read<AddStoryProvider>().isButtonActive =
        _descriptionController.text.isNotEmpty &&
            context.read<AddStoryProvider>().imageData != null;
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (!mounted) return;
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.noImageSelected),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    context.read<AddStoryProvider>().selectedImage = image;
    context.read<AddStoryProvider>().imageData = await image.readAsBytes();
    if (!mounted) return;
    context.read<AddStoryProvider>().filename = image.name;
    checkButtonState();
  }

  Future<void> _uploadStory() async {
    final AddStoryProvider provider = context.read<AddStoryProvider>();
    final XFile? image = provider.selectedImage;
    if (image == null || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)!.addImageAndDescSuggestion),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    await context.read<AddStoryProvider>().addStory();
    if (provider.state is AddStorySuccess) {
      final data = provider.state as AddStorySuccess;
      if (!mounted) return;
      context.read<AddStoryProvider>().selectedImage = null;
      context.read<AddStoryProvider>().imageData = null;
      context.read<AddStoryProvider>().description = null;
      context.read<AddStoryProvider>().filename = null;
      widget.toHomeScreen();
      context
          .read<PageManager>()
          .returnAddStoryResult(data.data.message.toString());
      await context.read<ListStoryProvider>().fetchListStories();
    } else {
      final data = provider.state as AddStoryError;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${AppLocalizations.of(context)!.failedUploadStory}: ${data.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final XFile? image = context.watch<AddStoryProvider>().selectedImage;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addNewStory),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border:
                          image == null ? Border.all(color: Colors.grey) : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: image == null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Icon(Icons.image_not_supported_outlined,
                                    size: 100, color: Colors.grey),
                                const SizedBox(height: 12),
                                Text(l10n.noImageUploaded),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _pickImage(ImageSource.camera);
                                      },
                                      icon: const Icon(Icons.camera),
                                      label: Text(l10n.capture),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _pickImage(ImageSource.gallery);
                                      },
                                      icon: const Icon(Icons.photo_library),
                                      label: Text(l10n.gallery),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Image.file(
                            File(image.path),
                            fit: BoxFit.cover,
                          ),
                  ),
                  if (context.watch<AddStoryProvider>().imageData != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton.filledTonal(
                        onPressed: () {
                          context.read<AddStoryProvider>().selectedImage = null;
                          context.read<AddStoryProvider>().imageData = null;
                        },
                        icon: Icon(Icons.close_rounded,
                            size: 20,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.description,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  context.read<AddStoryProvider>().description = value;
                  checkButtonState();
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: context.watch<AddStoryProvider>().isButtonActive
                    ? () {
                        _uploadStory();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Consumer(
                    builder: (context, AddStoryProvider provider, child) {
                  if (provider.state is AddStoryLoading) {
                    return SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                        strokeWidth: 2.0,
                      ),
                    );
                  }
                  return Text(l10n.uploadStory,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
