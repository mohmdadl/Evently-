import 'package:easy_localization/easy_localization.dart';
import 'package:enevtly/core/remote/local/prefs_manager.dart';
import 'package:enevtly/core/resourses/assets_manager.dart';
import 'package:enevtly/core/resourses/strings_manager.dart';
import 'package:enevtly/core/reusable_components/custom_button.dart';
import 'package:enevtly/core/reusable_components/custom_switch.dart';
import 'package:enevtly/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:enevtly/core/constants/app_constants.dart';

class Welcome extends StatefulWidget {
  static const String routName = "welcome";
  
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  // Initialize with a default value to avoid null issues before initialization
  int _selectedLanguage = 0; // Default to English (index 0)
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // THE FIX: Schedule this code to run after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // By this point, the entire widget tree, including EasyLocalization, is ready
      // It is now safe to access context.locale
      if (mounted) { // Best-practice check to ensure the widget is still in the tree
        setState(() {
          _selectedLanguage = context.locale.languageCode == 'en' ? 0 : 1;
          _isInitialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a loader until our post-frame callback has run
    // This prevents a flicker and ensures all data is ready before painting the UI
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Image.asset(
          AssetsManager.logoBar,
          height: 50,
          fit: BoxFit.fitHeight,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * (16 / 390)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Image.asset(AssetsManager.welcome1light)),
            SizedBox(height: screenHeight * (28 / 841)),
            Text(
              StringsManager.welcome1title.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: screenHeight * (28 / 841)),
            Text(
              StringsManager.welcome1desc.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: screenHeight * (28 / 841)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringsManager.language.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                CustomSwitch(
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                    if(value == 0){
                      context.setLocale(const Locale('en'));
                      PrefsManager.saveLanguage('en');
                    }else{
                      context.setLocale(const Locale('ar'));
                      PrefsManager.saveLanguage('ar');
                    }
                  },
                  image1: SvgPicture.asset(
                    AssetsManager.us,
                    width: screenWidth * (24 / 390),
                  ),
                  image2: SvgPicture.asset(
                    AssetsManager.eg,
                    width: screenWidth * (24 / 390),
                  ),
                  current: _selectedLanguage,
                ),
              ],
            ),
            SizedBox(height: screenHeight * (16 / 841)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringsManager.theme.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                CustomSwitch(
                  onChanged: (value) {
                    themeProvider.changeTheme(
                      value == 1 ? ThemeMode.dark : ThemeMode.light
                    );
                  },
                  image1: SvgPicture.asset(
                    AssetsManager.sun,
                    width: screenWidth * (24 / 390),
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                  image2: SvgPicture.asset(
                    AssetsManager.moon,
                    width: screenWidth * (24 / 390),
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                  current: themeProvider.themeMode == ThemeMode.light ? 0 : 1,
                ),
              ],
            ),
            SizedBox(height: screenHeight * (28 / 841)),
            CustomButton(
              value: StringsManager.letsStart.tr(),
              onClick: () {
                // Navigate to login screen and replace welcome in the stack
                Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
              },
            ),
            SizedBox(height: screenHeight * (28 / 841)),
          ],
        ),
      ),
    );
  }
}
