import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies1/core/app_colors.dart';
import 'package:movies1/core/app_assets.dart';
import 'package:movies1/screens/profile/update_profile_screen.dart';
import 'package:movies1/screens/profile/wishlist_screen.dart';
import 'package:movies1/api/profile_service.dart';
import 'package:movies1/api/wishlist_service.dart';
import 'package:movies1/api/history_service.dart';
import 'package:movies1/screens/home/widgets/wishlist_content.dart';
import 'package:movies1/screens/home/widgets/history_content.dart';
import 'package:dio/dio.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  int selectedTab = 0;
  String userName = 'Loading...';
  String? userAvatar;
  bool isLoading = true;
  int wishListCount = 0;
  int historyCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadWishListCount();
    _loadHistoryCount();
  }

  Future<void> _loadWishListCount() async {
    final count = await WishListService.getWishListCount();
    setState(() {
      wishListCount = count;
    });
  }

  Future<void> _loadHistoryCount() async {
    final count = await HistoryService.getHistoryCount();
    setState(() {
      historyCount = count;
    });
  }

  Future<void> _loadUserProfile() async {
    try {
      final User? firebaseUser = FirebaseAuth.instance.currentUser;
      
      if (firebaseUser != null) {
        String? firebaseName = firebaseUser.displayName;
        
        setState(() {
          if (firebaseName != null && firebaseName.isNotEmpty) {
            userName = firebaseName;
            isLoading = false;
          } else {
            _loadUserProfileFromAPI();
            return;
          }
        });
      } else {
        _loadUserProfileFromAPI();
      }
    } catch (e) {
      _loadUserProfileFromAPI();
    }
  }

  Future<void> _loadUserProfileFromAPI() async {
    try {
      final response = await ProfileService.getUser();
      if (response.statusCode == 200 && response.data != null) {
        final userData = response.data['data'] ?? response.data;
        setState(() {
          userName = userData['name'] ?? 'User';
          if (userData['avaterId'] != null) {
            userAvatar = userData['avaterId'].toString();
          } else if (userData['avatar'] != null) {
            userAvatar = userData['avatar'].toString();
          } else if (userData['avatarId'] != null) {
            userAvatar = userData['avatarId'].toString();
          }
          isLoading = false;
        });
      } else {
        setState(() {
          userName = 'User';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = 'User';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray,
      body: ProfileBody(
        selectedTab: selectedTab,
        userName: userName,
        userAvatar: userAvatar,
        isLoading: isLoading,
        onTabChanged: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        onRefresh: () async {
          await _loadUserProfile();
          await _loadWishListCount();
          await _loadHistoryCount();
        },
        wishListCount: wishListCount,
        historyCount: historyCount,
      ),
    );
  }
}

class ProfileBody extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;
  final String userName;
  final String? userAvatar;
  final bool isLoading;
  final VoidCallback onRefresh;
  final int wishListCount;
  final int historyCount;

  const ProfileBody({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    required this.userName,
    this.userAvatar,
    this.isLoading = false,
    required this.onRefresh,
    this.wishListCount = 0,
    this.historyCount = 0,
  });

  ImageProvider _getAvatarImage(String? avatarId) {
    if (avatarId == null || avatarId.isEmpty) {
      return const AssetImage('assets/edit/gamer.png');
    }
    
    final avatarMap = {
      '1': 'assets/edit/1.png',
      '2': 'assets/edit/2.png',
      '3': 'assets/edit/3.png',
      '4': 'assets/edit/4.png',
      '5': 'assets/edit/5.png',
      '6': 'assets/edit/6.png',
      '7': 'assets/edit/7.png',
      '8': 'assets/edit/8.png',
      '9': 'assets/edit/9.png',
    };
    
    final avatarPath = avatarMap[avatarId] ?? 'assets/edit/gamer.png';
    return AssetImage(avatarPath);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _getAvatarImage(userAvatar),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isLoading ? 'Loading...' : userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WishListScreen(),
                                ),
                              ).then((_) => onRefresh());
                            },
                            child: Column(
                              children: [
                                Text(
                                  wishListCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Wish List',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                historyCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'History',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfilePage(),
                              ),
                            );
                            if (result == true) {
                              onRefresh();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Exit',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.logout, size: 20, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.all(1),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onTabChanged(0),
                          child: Column(
                            children: [
                              Image.asset(
                                AppAssets.edit,
                                width: 42,
                                height: 42,
                                color: AppColors.primary,
                              ),
                              Text(
                                'Watch List',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                height: 3,
                                color: selectedTab == 0
                                    ? Colors.amber
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        child: GestureDetector(
                          onTap: () => onTabChanged(1),
                          child: Column(
                            children: [
                              Image.asset(
                                AppAssets.folder,
                                width: 42,
                                height: 42,
                                color: AppColors.primary,
                              ),
                              Text(
                                'History',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                height: 3,
                                color: selectedTab == 1
                                    ? Colors.amber
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  color: AppColors.black,
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    minHeight: 400,
                    maxHeight: 600,
                  ),
                  child: selectedTab == 0
                      ? WishListContent(onRefresh: onRefresh)
                      : HistoryContent(onRefresh: onRefresh),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
