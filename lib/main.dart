import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:healthy_lifestyle_app/providers/all_user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/providers/user_chat.dart';
import 'package:healthy_lifestyle_app/providers/user_exerise_program.dart';
import 'package:healthy_lifestyle_app/providers/user_food_intake.dart';
import 'package:healthy_lifestyle_app/providers/user_post.dart';
import 'package:healthy_lifestyle_app/providers/user_sleep.dart';
import 'package:healthy_lifestyle_app/providers/user_water_intake.dart';
import 'package:healthy_lifestyle_app/views/screens/sharing/comment_screen.dart';
import 'package:healthy_lifestyle_app/views/screens/sharing/covid_screen.dart';
import 'package:healthy_lifestyle_app/views/screens/sharing/covid_country_screen.dart';
import 'package:healthy_lifestyle_app/views/screens/login/login_screen.dart';
import 'package:healthy_lifestyle_app/views/screens/login/register_screen.dart';
import 'package:healthy_lifestyle_app/views/screens/sharing/introductionary_screen.dart';
import 'package:healthy_lifestyle_app/views/screens/sharing/messenger_screen.dart';
import 'package:healthy_lifestyle_app/views/screens/sharing/post_info_screen.dart';
import 'package:healthy_lifestyle_app/views/widgets/main/bottom_navigation.dart';
import 'package:healthy_lifestyle_app/views/widgets/message/message_processing.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid = AndroidInitializationSettings("music");
  var initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });
  runApp(MyApp()); //Inherited
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentUser()),
        ChangeNotifierProvider(create: (_) => UserFoodIntake()),
        ChangeNotifierProvider(create: (_) => UserExerciseProgram()),
        ChangeNotifierProvider(create: (_) => UserPost()),
        ChangeNotifierProvider(create: (_) => AllUser()),
        ChangeNotifierProvider(create: (_) => UserChat()),
        ChangeNotifierProvider(create: (_) => UserSleep()),
        ChangeNotifierProvider(create: (_) => UserWaterIntake()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.light, primaryColor: kGreenColor),
        title: 'Healthy Lifestyle App',
        home: LoginScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return PageTransition(
                duration: Duration(milliseconds: 300),
                child: LoginScreen(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            case '/register':
              return PageTransition(
                duration: Duration(milliseconds: 300),
                child: RegisterScreen(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            case '/sharing':
              return PageTransition(
                duration: Duration(milliseconds: 300),
                child: BottomNavigation(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            case '/covid':
              return PageTransition(
                duration: Duration(milliseconds: 300),
                child: CovidScreen(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            case "/country":
              return PageTransition(
                duration: Duration(milliseconds: 300),
                child: CovidCountryScreen(), 
                type: PageTransitionType.fade,
                settings: settings,
              );
            case '/info':
              return PageTransition(
                duration: Duration(milliseconds: 300),
                child: PostInfoScreen(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            case '/msg':
              return PageTransition(
                duration: Duration(milliseconds: 300),
                child: MessengerScreen(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            case '/chat':
              return PageTransition(
                duration: Duration(milliseconds: 300),
                child: MessageProcessing(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            case '/intro':
              return PageTransition(
                duration: Duration(milliseconds: 300),
                child: IntroductionaryScreen(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            case '/comment':
              return PageTransition(
                duration: Duration(milliseconds: 300),
                child: CommentScreen(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}


