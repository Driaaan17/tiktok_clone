// lib/screens/home/pages/explore/explore_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/video_provider.dart';
import '../../../../constants/app_icons.dart';
import 'category_tabs.dart';
import 'video_grid.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Consumer<VideoProvider>(
            builder: (context, videoProvider, child) {
              return CategoryTabs(
                categories: videoProvider.categories,
                selectedCategory: videoProvider.selectedCategory,
                onCategorySelected: (slug) => videoProvider.selectCategory(slug),
              );
            },
          ),
          const Expanded(child: VideoGrid()),
        ],
      ),
    );
  }
}