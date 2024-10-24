import 'package:meilinflutterproject/screens/ideas/draft.dart';
import 'package:meilinflutterproject/screens/learning_center/document.dart';
import 'package:meilinflutterproject/screens/published/discussion.dart';
import 'package:meilinflutterproject/services/navbar.dart';
import 'package:meilinflutterproject/screens/profile.dart';
import 'package:meilinflutterproject/screens/published/feedbacksurvey.dart';
import 'package:meilinflutterproject/screens/published/feedbackview.dart';
import 'package:meilinflutterproject/screens/published/publishedworks.dart';
import 'package:meilinflutterproject/screens/splash.dart';

var screenRoutes = {
  '/': (context) => const SplashScreen(),
  '/navbar': (context) => const Navbar(),
  '/draft': (context) => const DraftScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/publishedWork': (context) => const PublishedWork(),
  '/feedbackView': (context) => const FeedbackView(),
  '/feedbackSurvey': (context) => const Survey(),
  '/discussion': (context) => const DiscussionScreen(),
  '/document': (context) => const Document()
};
