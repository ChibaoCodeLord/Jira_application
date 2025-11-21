import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jira/features/dash_board/presentation/tab/chat_tab/avatar_widget.dart';
import 'package:jira/features/dash_board/presentation/tab/chat_tab/chat_detail/chat_detail_cubit.dart';
import 'package:jira/features/dash_board/presentation/tab/chat_tab/chat_detail/chat_detail_page.dart';
import 'package:jira/features/dash_board/presentation/tab/chat_tab/chat_tab/chat_tab_cubit.dart';
import 'package:jira/features/dash_board/presentation/tab/chat_tab/chat_tab/chat_tab_state.dart';
import 'chat_item_model.dart';

class ChatListView extends StatelessWidget {
  final String selectedTab;
  final String searchQuery;

  const ChatListView({
    super.key,
    this.selectedTab = 'All',
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    return BlocBuilder<ChatTabCubit, ChatTabState>(
      builder: (context, state) {
        final friends = state.allFriends;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .orderBy('lastMessageTime', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Lỗi tải tin nhắn'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final chatDocs = snapshot.data!.docs;
            final List<ChatItemModel> items = [];

            // 1. Thêm bạn bè chưa từng nhắn (hiển thị dưới cùng)
            for (final friend in friends) {
              final hasChat = chatDocs.any((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final members = List<String>.from(data['members'] ?? []);
                return members.length == 2 &&
                    members.contains(currentUid) &&
                    members.contains(friend.id);
              });

              if (!hasChat) {
                items.add(
                  friend.copyWith(
                    lastMessage: 'Chưa có tin nhắn',
                    lastMessageTime: DateTime(2000),
                  ),
                );
              }
            }

            // 2. Thêm tất cả cuộc trò chuyện (1-1 + nhóm)
            for (final doc in chatDocs) {
              final data = doc.data() as Map<String, dynamic>;
              final members = List<String>.from(data['members'] ?? []);
              if (!members.contains(currentUid)) continue;

              final isGroup = data['isGroup'] == true;
              if (selectedTab == 'Groups' && !isGroup) continue;

              String name = data['name']?.toString() ?? '';
              String? photoURL = data['groupPhotoURL'] ?? data['photoURL'];

              // Nếu là chat 1-1 và chưa có tên → lấy tên bạn bè
              if (!isGroup && name.isEmpty) {
                final otherId = members.firstWhere(
                  (id) => id != currentUid,
                  orElse: () => '',
                );
                if (otherId.isNotEmpty) {
                  final friend = friends.firstWhere(
                    (f) => f.id == otherId,
                    orElse: () => ChatItemModel(
                      id: otherId,
                      name: 'Người dùng',
                      email: null,
                      photoURL: null,
                      isGroup: false,
                      members: [],
                      isOnline: false,
                    ),
                  );
                  name = friend.name;
                  photoURL = friend.photoURL;
                }
              }

              final lastMessage =
                  data['lastMessage']?.toString() ?? 'Không có tin nhắn';
              final lastTime = (data['lastMessageTime'] as Timestamp?)
                  ?.toDate();

              // Xác định trạng thái online (chỉ cho chat cá nhân)
              final otherUserId = isGroup
                  ? null
                  : members.firstWhere(
                      (id) => id != currentUid,
                      orElse: () => '',
                    );
              final isOnline =
                  !isGroup &&
                  otherUserId!.isNotEmpty &&
                  friends.any((f) => f.id == otherUserId && f.isOnline);

              items.add(
                ChatItemModel(
                  id: doc.id,
                  name: name.isEmpty
                      ? (isGroup ? 'Nhóm chat' : 'Người dùng')
                      : name,
                  photoURL: photoURL,
                  isGroup: isGroup,
                  members: members,
                  isOnline: isOnline,
                  lastMessage: lastMessage,
                  lastMessageTime: lastTime,
                ),
              );
            }

            // Lọc theo từ khóa tìm kiếm
            final filtered = items.where((item) {
              if (searchQuery.trim().isEmpty) return true;
              return item.name.toLowerCase().contains(
                searchQuery.toLowerCase(),
              );
            }).toList();

            // Sắp xếp theo tin nhắn mới nhất
            filtered.sort((a, b) {
              final timeA = a.lastMessageTime ?? DateTime(2000);
              final timeB = b.lastMessageTime ?? DateTime(2000);
              return timeB.compareTo(timeA);
            });

            if (filtered.isEmpty) {
              return const Center(
                child: Text(
                  'Chưa có tin nhắn nào',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<ChatTabCubit>().refreshFriends(),
              child: ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 72),
                itemBuilder: (context, index) {
                  final item = filtered[index];

                  return ListTile(
                    leading: SizedBox(
                      width: 56,
                      height: 56,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: AvatarWidget(
                              url: item.photoURL,
                              initials: item.name,
                              radius: 28,
                            ),
                          ),
                          if (!item.isGroup && item.isOnline)
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      item.isGroup
                          ? '${item.members.length} thành viên'
                          : (item.lastMessage ?? 'Chưa có tin nhắn'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    trailing: item.isGroup
                        ? null
                        : Text(
                            item.isOnline ? 'Online' : 'Offline',
                            style: TextStyle(
                              color: item.isOnline
                                  ? Colors.green
                                  : Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    onTap: () {
                      final String targetChatId;
                      final bool isGroupChat = item.isGroup;

                      if (isGroupChat) {
                        targetChatId = item.id; // nhóm: dùng document ID
                      } else {
                        targetChatId = item.members.firstWhere(
                          (id) => id != currentUid,
                          orElse: () => item.id,
                        );
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => ChatDetailCubit(
                              targetChatId,
                              isGroupChat,
                              initialIsChatId: isGroupChat,
                            ),
                            child: ChatDetailPage(
                              chatId: targetChatId,
                              chatName: item.name,
                              isGroup: isGroupChat,
                              members: item.members,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

// Extension copyWith chuẩn như bạn đang dùng
extension on ChatItemModel {
  ChatItemModel copyWith({String? lastMessage, DateTime? lastMessageTime}) {
    return ChatItemModel(
      id: id,
      name: name,
      email: email,
      photoURL: photoURL,
      isGroup: isGroup,
      members: members,
      isOnline: isOnline,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageFrom: lastMessageFrom,
    );
  }
}
