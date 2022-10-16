import 'package:camera/camera.dart';
import 'package:face_logic/constants.dart';
import 'package:face_logic/screens/login_screen.dart';
import 'package:face_logic/screens/logout.dart';
import 'package:face_logic/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'FaceLogic',
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      // home: FirebaseAuth.instance.currentUser == null
      //     ? SignInScreen()
      //     : HomeScreen(),
      // //make flutter aware of app routes using router generator in router.dart file
      //onGenerateRoute: generateRoute,
      //initialRoute: loginScreenRoute,
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong!'),
              );
            } else if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return SignInScreen();
            }
          }),
        ),
      );
}

// class Splash extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SplashScreen(
//       seconds: 2,
//       navigateAfterSeconds: new LoginScreen(),
//       title: new Text(
//         'FaceLogic',
//         textScaleFactor: 2,
//       ),
//       image: new Image.network('https://picsum.photos/seed/picsum/200/300'),
//       loadingText: Text("Loading"),
//       photoSize: 100.0,
//       loaderColor: Colors.blue,
//     );
//   }
// }

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
