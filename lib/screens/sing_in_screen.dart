// lib/sign_in_sign_up_screen.dart
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:playground_2502/screens/list_art.dart';
 

class SignInSignUpScreen extends StatelessWidget {
  const SignInSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [
        EmailAuthProvider(),
        GoogleProvider(clientId: "1:169972296739:web:d671605f2b8ed82b7e9596"),
        // Add other providers like PhoneAuthProvider(), AppleProvider(), etc.
      ],
      headerBuilder: (context, constraints, shrinkOffset) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: 1,
            // Make sure you have 'assets/your_app_logo.png' or remove this
            child: Image.asset('assets/your_app_logo.png'),
          ),
        );
      },
      subtitleBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: action == AuthAction.signIn
              ? const Text('Welcome back! Please sign in.')
              : const Text('Join us! Please sign up.'),
        );
      },
      footerBuilder: (context, action) {
        return const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            'By signing in, you agree to our terms and conditions.',
            style: TextStyle(color: Colors.grey),
          ),
        );
      },
      // THIS IS THE CRUCIAL PART FOR NAVIGATION:
      // When authentication state changes (i.e., user signs in/up), this listener fires.
      // --- THE CORRECTION IS HERE ---
      actions: [
        // This action listens for a successful sign-in event.
        AuthStateChangeAction<SignedIn>((context, state) {
          // Once signed in, navigate to the HomeScreen and replace the current route.
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ListArtScreen()),
          );
        }),
        // You could also add other actions, e.g., for when an error occurs:
        // AuthStateChangeAction<AuthFailed>((context, state) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Sign-in failed: ${state.exception?.message}')),
        //   );
        // }),
      ],
    );
  }
}
