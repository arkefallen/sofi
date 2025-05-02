import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sofi/core/l10n/l10n.dart';
import 'package:sofi/presentation/provider/detail_story_provider.dart';
import 'package:sofi/presentation/state/detail_story_state.dart';

class DetailStoryScreen extends StatefulWidget {
  final String storyId;

  const DetailStoryScreen({super.key, required this.storyId});

  @override
  DetailStoryScreenState createState() => DetailStoryScreenState();
}

class DetailStoryScreenState extends State<DetailStoryScreen> {
  late GoogleMapController mapController;

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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<DetailStoryProvider>(
            builder: (context, value, child) {
              if (value.state is DetailStoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (value.state is DetailStoryError) {
                return Center(
                  child: Text(
                    "${l10n.getDetailStoryFailed}. \n${(value.state as DetailStoryError).message}",
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
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.account_circle,
                                size: 36.0,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 16),
                              Flexible(
                                child: Text(
                                  story.name.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
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
                    if (story.lat != null && story.lon != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        l10n.location,
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(story.lat!, story.lon!),
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId('storyLocation'),
                              position: LatLng(story.lat!, story.lon!),
                              infoWindow: InfoWindow(
                                title: l10n.address,
                                snippet: story.address!,
                              ),
                            ),
                          },
                          onMapCreated: (controller) {
                            mapController = controller;
                          },
                        ),
                      ),
                    ],
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
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
