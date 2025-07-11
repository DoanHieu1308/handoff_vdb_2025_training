import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';

// Demo để test logic accept friend
class AcceptFriendDemo extends StatelessWidget {
  final FriendsStore store = FriendsStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accept Friend Demo'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Reset trạng thái để test lại
              store.resetAcceptedFriends();
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          return Column(
            children: [
              // Hiển thị trạng thái accepted friends
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Accepted Friends Status:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ...store.acceptedFriends.entries.map((entry) => 
                      Text('Friend ID: ${entry.key} - Accepted: ${entry.value}')
                    ),
                  ],
                ),
              ),
              
              // Demo buttons
              Expanded(
                child: ListView.builder(
                  itemCount: 5, // Demo 5 friends
                  itemBuilder: (context, index) {
                    final friendId = 'friend_$index';
                    final isAccepted = store.acceptedFriends[friendId] == true;
                    
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('F$index'),
                      ),
                      title: Text('Friend $index'),
                      subtitle: Text(isAccepted ? 'Accepted' : 'Pending'),
                      trailing: IconButton(
                        icon: Icon(
                          isAccepted ? Icons.message : Icons.person_add,
                          color: isAccepted ? Colors.green : Colors.blue,
                        ),
                        onPressed: () {
                          // Simulate accept friend request
                          store.acceptedFriends[friendId] = true;
                          
                          // Simulate API call
                          Future.delayed(Duration(seconds: 1), () {
                            // Simulate success
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Friend $index accepted!'))
                            );
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 