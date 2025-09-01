import 'package:astro_iztro/app/routes/app_routes.dart';
import 'package:astro_iztro/core/services/storage_service.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [OnboardingController] - Manages onboarding flow state and navigation
/// Handles page transitions, completion tracking, and user preferences
class OnboardingController extends GetxController {
  // Observable variables for reactive UI updates
  final RxInt currentPage = 0.obs;
  final RxBool isLastPage = false.obs;
  final RxBool isLoading = false.obs;

  // Page controller for smooth transitions
  late final PageController pageController;

  // Storage service for persisting onboarding completion
  late final StorageService _storageService;

  @override
  void onInit() {
    super.onInit();
    // Initialize storage service
    _storageService = Get.find<StorageService>();
    // Initialize page controller
    pageController = PageController();
    // Update last page status based on current page
    _updateLastPageStatus();
  }

  /// [nextPage] - Navigate to the next onboarding page
  /// Handles smooth transitions and completion logic
  void nextPage() {
    if (currentPage.value < 3) {
      // 4 pages total (0-3)
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateLastPageStatus();
    } else {
      _completeOnboarding();
    }
  }

  /// [previousPage] - Navigate to the previous onboarding page
  /// Provides backward navigation with smooth transitions
  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateLastPageStatus();
    }
  }

  /// [skipOnboarding] - Skip the entire onboarding process
  /// Marks onboarding as complete and navigates to home
  void skipOnboarding() {
    _completeOnboarding();
  }

  /// [updateLastPageStatus] - Update the last page indicator
  /// Used for showing different UI elements on the final page
  void _updateLastPageStatus() {
    isLastPage.value = currentPage.value == 3;
  }

  /// [completeOnboarding] - Mark onboarding as complete and navigate to home
  /// Saves completion status and transitions to main app
  Future<void> _completeOnboarding() async {
    try {
      isLoading.value = true;

      // Save onboarding completion status using storage service
      await _storageService.markOnboardingCompleted();

      // Navigate to home screen with smooth transition
      await Get.offAllNamed<void>(AppRoutes.home);
    } on Exception catch (e) {
      // Handle error gracefully
      if (kDebugMode) {
        print('[OnboardingController] Error completing onboarding: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// [getPageIndicator] - Get current page indicator for UI
  /// Returns a list of boolean values for page dots
  List<bool> getPageIndicator() {
    return List.generate(4, (index) => index == currentPage.value);
  }

  /// [getProgressPercentage] - Get onboarding progress as percentage
  /// Used for progress bar animations
  double getProgressPercentage() {
    return (currentPage.value + 1) / 4;
  }

  /// [onPageChanged] - Handle page changes from swipe gestures
  void onPageChanged(int page) {
    currentPage.value = page;
    _updateLastPageStatus();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
