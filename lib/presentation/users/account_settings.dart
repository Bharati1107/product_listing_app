// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AccountSettingsPage extends StatelessWidget {
//   const AccountSettingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Account Settings')),
//       body: Center(
//         child: user == null
//             ? const Text('Not logged in')
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Logged in as: ${user.email}'),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () async {
//                       await FirebaseAuth.instance.signOut();
//                       Navigator.pop(context);
//                     },
//                     child: const Text('Logout'),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
