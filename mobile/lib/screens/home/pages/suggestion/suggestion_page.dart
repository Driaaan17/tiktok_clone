// lib/screens/home/pages/suggestion/suggestion_page.dart
import 'package:flutter/material.dart';
import '../../../../constants/app_icons.dart';
import '../../../../widgets/app_icon_widgets.dart';

class SuggestionPage extends StatelessWidget {
  const SuggestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: SizedBox(
          width: 400,
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) => SuggestionVideoCard(index: index),
          ),
        ),
      ),
    );
  }
}

class SuggestionVideoCard extends StatelessWidget {
  final int index;

  const SuggestionVideoCard({
    super.key,
    required this.index,
  });

  static const List<String> _users = [
    'nganjuk', 'didipengepulgame', 'jadenibo', 'ag.sadin', 'creativegamer'
  ];

  static const List<String> _descriptions = [
    'Game Gratis Di Steam Ada Hitman Wor... lebih banyak',
    'Tutorial dance keren! #dance #trending',
    'Moment epic hari ini #lifestyle',
    'Behind the scenes #bts #content',
    'Skill gila abis 🔥 #talent #amazing'
  ];

  static const List<String> _songs = [
    'My Boo (Hitman\'s Club Mix) - Ghost Town DJs',
    'Original Sound - TikTok Audio',
    'Trending Music 2025',
    'Popular Beat - DJ Mix',
    'Viral Sound Effect'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserHeader(),
          _buildVideoContainer(),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[600],
            child: const Icon(AppIcons.profile, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(_users[index % _users.length], 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const Spacer(),
          const Icon(AppIcons.more, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  Widget _buildVideoContainer() {
    return Container(
      height: 600,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFEC4899)],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(AppIcons.play, 
              color: Colors.white.withValues(alpha: 0.8), 
              size: AppIconSizes.xxlarge),
          ),
          _buildActionButtons(),
          _buildVideoInfo(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Positioned(
      right: 12,
      bottom: 80,
      child: Column(
        children: [
          ActionButton(
            icon: AppIcons.like, 
            count: '1643', 
            iconColor: AppIconColors.like, 
            isActive: index % 3 == 0
          ),
          const SizedBox(height: 16),
          const ActionButton(icon: AppIcons.comment, count: '41', iconColor: Colors.white),
          const SizedBox(height: 16),
          const ActionButton(icon: AppIcons.bookmark, count: '381', iconColor: Colors.white),
          const SizedBox(height: 16),
          const ActionButton(icon: AppIcons.share, count: '487', iconColor: Colors.white),
        ],
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Positioned(
      left: 16,
      right: 70,
      bottom: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('@${_users[index % _users.length]}', 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(_descriptions[index % _descriptions.length],
            style: const TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(AppIcons.music, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(_songs[index % _songs.length],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ],
      ),
    );
  }
}