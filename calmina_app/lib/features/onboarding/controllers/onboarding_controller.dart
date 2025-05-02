import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/onboarding_item.dart';

class OnboardingController extends GetxController {
  final RxInt currentPage = 0.obs;
  final RxBool isLastPage = false.obs;

  final List<OnboardingItem> items = [
    const OnboardingItem(
      title: 'Bienvenue sur Calmina',
      description: 'Votre compagnon de bien-être mental au quotidien. Ensemble, prenons soin de votre santé mentale.',
      imagePath: 'assets/images/onboarding_1.png',
    ),
    const OnboardingItem(
      title: 'Suivez vos émotions',
      description: 'Enregistrez votre humeur quotidienne, identifiez vos déclencheurs et suivez votre progression vers un meilleur équilibre émotionnel.',
      imagePath: 'assets/images/onboarding_2.png',
    ),
    const OnboardingItem(
      title: 'Exercices personnalisés',
      description: 'Découvrez des exercices de respiration, méditation et relaxation adaptés à votre état d\'esprit du moment.',
      imagePath: 'assets/images/onboarding_3.png',
    ),
    const OnboardingItem(
      title: 'Journal de gratitude',
      description: 'Cultivez la positivité en notant chaque jour les moments qui vous rendent heureux et reconnaissant.',
      imagePath: 'assets/images/onboarding_4.png',
    ),
    const OnboardingItem(
      title: 'Soutien professionnel',
      description: 'Connectez-vous avec des professionnels de la santé mentale pour un accompagnement personnalisé.',
      imagePath: 'assets/images/onboarding_5.png',
    ),
  ];

  void nextPage() {
    if (currentPage.value < items.length - 1) {
      currentPage.value++;
      isLastPage.value = currentPage.value == items.length - 1;
    } else {
      completeOnboarding();
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    Get.offAllNamed('/auth');
  }

  @override
  void onInit() {
    super.onInit();
    isLastPage.value = currentPage.value == items.length - 1;
  }
} 