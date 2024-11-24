import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppLinks _appLinks = AppLinks();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Deep Links',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DeepLinkingPage(),
    );
  }
}

class DeepLinkingPage extends StatefulWidget {
  @override
  _DeepLinkingPageState createState() => _DeepLinkingPageState();
}

class _DeepLinkingPageState extends State<DeepLinkingPage> {
  final AppLinks _appLinks = AppLinks();
  String _deepLink = 'No deep link received yet';

  @override
  void initState() {
    super.initState();

    // Handle initial deep link if the app was opened via a deep link
    _handleDeepLink();

    // Listen for deep link changes (when app is in the foreground)
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        setState(() {
          _deepLink = uri.toString();
        });
        _navigateBasedOnDeepLink(uri);
      }
    });
  }

  // Handle the initial deep link (when the app is launched)
  Future<void> _handleDeepLink() async {
    final Uri? initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      setState(() {
        _deepLink = initialUri.toString();
      });
      _navigateBasedOnDeepLink(initialUri);
    }
  }

  // Route navigation based on the deep link
  void _navigateBasedOnDeepLink(Uri uri) {
    if (uri.pathSegments.isNotEmpty) {
      final path = uri.pathSegments[0];
      switch (path) {
        case 'details':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailsPage()),
          );
          break;
      // Add more routes as needed
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home page')),
      body: Center(
        child: Text('Current deep link: $_deepLink'),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details Page')),
      body: Center(
        child: Text('Welcome to the Details Page!'),
      ),
    );
  }
}
