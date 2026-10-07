import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/audio/audio_controller.dart';
import 'core/storage/progress_repository.dart';
import 'core/theme/app_colors.dart';
import 'features/book_engine/data/repositories/book_repository.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  final audioController = AudioController.live();
  final bookRepository = BookRepository();
  final progressRepository = ProgressRepository();

  runApp(BarkaBookApp(
    audioController: audioController,
    bookRepository: bookRepository,
    progressRepository: progressRepository,
  ));
}

class BarkaBookApp extends StatelessWidget {
  final AudioController audioController;
  final BookRepository bookRepository;
  final ProgressRepository progressRepository;

  const BarkaBookApp({
    super.key,
    required this.audioController,
    required this.bookRepository,
    required this.progressRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Barka's Book",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.softBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryYellow,
          primary: AppColors.primaryYellow,
          secondary: AppColors.deepNavy,
        ),
      ),
      home: HomeScreen(
        bookRepository: bookRepository,
        audioController: audioController,
        progressRepository: progressRepository,
      ),
    );
  }
}
