// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_clone/screens/home/pages/new_page/new_page.dart';
import '../../widgets/bottom_navigation.dart';
import '../../constants/app_icons.dart';
import '../../providers/video_provider.dart';
import 'components/sidebar/sidebar_widget.dart';
import 'components/topbar/topbar_widget.dart';
import 'pages/suggestion/suggestion_page.dart';
import 'pages/explore/explore_page.dart';
import 'pages/following/following_page.dart';
import 'pages/friends/friends_page.dart';
import 'pages/activity/activity_page.dart';
import 'pages/messages/messages_page.dart';
import 'pages/live/live_page.dart';
import 'pages/profile/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final videoProvider = Provider.of<VideoProvider>(context, listen: false);
      videoProvider.loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // Fixed Sidebar
          SidebarWidget(
            currentIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() => _currentIndex = index);
            },
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                TopbarWidget(
                  title: _getPageTitle(),
                  showSearch: MediaQuery.of(context).size.width > 800,
                ),
                Expanded(child: _buildCurrentScreen()),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width < 800
          ? CustomBottomNavigation(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
              },
            )
          : null,
    );
  }

  String _getPageTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Saran';
      case 1:
        return 'Jelajahi';
      case 2:
        return 'Mengikuti';
      case 3:
        return 'Teman';
      case 5:
        return 'Aktivitas';
      case 6:
        return 'Pesan';
      case 7:
        return 'LIVE';
      case 8:
        return 'Profil';
      case 9:
        return 'NewPage';
      default:
        return 'TikTok';
    }
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return const SuggestionPage();
      case 1:
        return const ExplorePage();
      case 2:
        return const FollowingPage();
      case 3:
        return const FriendsPage();
      case 5:
        return const ActivityPage();
      case 6:
        return const MessagesPage();
      case 7:
        return const LivePage();
      case 8:
        return const ProfilePage();
      case 9:
        return const NewPage();
      default:
        return const SuggestionPage();
    }
  }
}
