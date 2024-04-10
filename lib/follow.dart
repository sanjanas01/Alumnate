// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FollowPage extends StatefulWidget {
//   @override
//   _FollowPageState createState() => _FollowPageState();
// }

// class _FollowPageState extends State<FollowPage> {
//   late TextEditingController _searchController;
//   late User? _currentUser;
//   late List<DocumentSnapshot> _alumnis = [];
//   late List<String> _followingIds = [];

//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController();
//     _currentUser = FirebaseAuth.instance.currentUser;
//     _fetchFollowingIds();
//     _fetchAlumnis();
//   }

//   Future<void> _fetchFollowingIds() async {
//     if (_currentUser != null) {
//       final snapshot = await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).get();
//       final data = snapshot.data();
//       if (data != null && data.containsKey('following')) {
//         setState(() {
//           _followingIds = List<String>.from(data['following']);
//         });
//       }
//     }
//   }

//   Future<void> _fetchAlumnis() async {
//     final snapshot = await FirebaseFirestore.instance.collection('users').get();
//     setState(() {
//       _alumnis = snapshot.docs;
//     });
//   }

//   Future<void> _sendFollowRequest(String userId) async {
//     if (_currentUser != null) {
//       try {
//         await FirebaseFirestore.instance.collection('follow_requests').doc(userId).collection('requests').doc(_currentUser!.uid).set({
//           'senderId': _currentUser!.uid,
//           'timestamp': Timestamp.now(),
//         });
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Follow request sent successfully'),
//         ));
//       } catch (e) {
//         print('Error sending follow request: $e');
//       }
//     }
//   }

//   Future<void> _acceptFollowRequest(String senderId) async {
//     if (_currentUser != null) {
//       try {
//         await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).update({
//           'following': FieldValue.arrayUnion([senderId]),
//         });
//         await FirebaseFirestore.instance.collection('users').doc(senderId).update({
//           'followers': FieldValue.arrayUnion([_currentUser!.uid]),
//         });
//         await FirebaseFirestore.instance.collection('follow_requests').doc(_currentUser!.uid).collection('requests').doc(senderId).delete();
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('You are now following this alumni'),
//         ));
//         setState(() {
//           _followingIds.add(senderId);
//         });
//       } catch (e) {
//         print('Error accepting follow request: $e');
//       }
//     }
//   }

//   Future<void> _declineFollowRequest(String senderId) async {
//     if (_currentUser != null) {
//       try {
//         await FirebaseFirestore.instance.collection('follow_requests').doc(_currentUser!.uid).collection('requests').doc(senderId).delete();
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Follow request declined'),
//         ));
//       } catch (e) {
//         print('Error declining follow request: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Alumnis'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search alumni...',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: () {
//                     // Implement search functionality
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _alumnis.length,
//               itemBuilder: (context, index) {
//                 final alumni = _alumnis[index];
//                 final alumniId = alumni.id;
//                 final alumniData = alumni.data() as Map<String, dynamic>;
//                 final isFollowing = _followingIds.contains(alumniId);
//                 return ListTile(
//                   title: Text(alumniData['name']),
//                   subtitle: Text(alumniData['email']),
//                   trailing: isFollowing
//                       ? Text('Following')
//                       : ElevatedButton(
//                           onPressed: () => _sendFollowRequest(alumniId),
//                           child: Text('Follow'),
//                         ),
//                   onTap: () {
//                     // Navigate to alumni profile page
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }