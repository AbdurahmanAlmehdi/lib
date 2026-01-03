import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Buzzy Bee'**
  String get appTitle;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Profile tab label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Generic success title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No internet error message
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get noInternetConnection;

  /// Server error message
  ///
  /// In en, this message translates to:
  /// **'Server error occurred. Please try again later.'**
  String get serverError;

  /// Popular cleaners section title
  ///
  /// In en, this message translates to:
  /// **'Popular Cleaners'**
  String get popularCleaners;

  /// Service categories section title
  ///
  /// In en, this message translates to:
  /// **'Service Categories'**
  String get serviceCategories;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Select date label
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Previous button text
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Select cleaners count label
  ///
  /// In en, this message translates to:
  /// **'Select Number of Cleaners'**
  String get selectCleaners;

  /// Available cleaners section title
  ///
  /// In en, this message translates to:
  /// **'Available Cleaners'**
  String get availableCleaners;

  /// Select location label
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// Confirm booking button text
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// Search bar placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search services...'**
  String get search;

  /// Orders screen title
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// All filter tab
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// In Progress filter tab
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// Completed filter tab
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Cancelled filter tab
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// Empty orders list message
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get noOrders;

  /// Favorites screen title
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Empty favorites list message
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavorites;

  /// Price label
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Currency symbol
  ///
  /// In en, this message translates to:
  /// **'LYD'**
  String get currency;

  /// Confirmed status
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// Pending status
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Account screen title
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Phone label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Support menu item
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// Terms and conditions menu item
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Welcome to Buzzy Bee message
  ///
  /// In en, this message translates to:
  /// **'Welcome to Buzzy Bee'**
  String get welcomeToBuzzyBee;

  /// Your trusted cleaning service partner message
  ///
  /// In en, this message translates to:
  /// **'Your trusted cleaning service partner'**
  String get yourTrustedCleaningServicePartner;

  /// Don't have an account message
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// Please enter your phone number message
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterYourPhoneNumber;

  /// Please enter your password message
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterYourPassword;

  /// Please enter your name message
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// Please enter your email message
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// Please enter a valid email message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterAValidEmail;

  /// Please enter a valid phone number message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterAValidPhoneNumber;

  /// Registration successful message
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Please login.'**
  String get registrationSuccessful;

  /// Sign up and let us handle the mess message
  ///
  /// In en, this message translates to:
  /// **'Sign up and let us handle the mess'**
  String get signUpAndLetUsHandleTheMess;

  /// Sign in to continue message
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// Password must be at least 8 characters message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMustBeAtLeast8Characters;

  /// Name must be at least 2 characters message
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMustBeAtLeast2Characters;

  /// Already have an account message
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// Confirm password label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Please confirm your password message
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmYourPassword;

  /// Passwords do not match message
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Name label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Personal account menu item
  ///
  /// In en, this message translates to:
  /// **'Personal Account'**
  String get personalAccount;

  /// Change password menu item
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// FAQ menu item
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// Contact us menu item
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// About the app menu item
  ///
  /// In en, this message translates to:
  /// **'About the App'**
  String get aboutTheApp;

  /// Step 1 label
  ///
  /// In en, this message translates to:
  /// **'Step 1'**
  String get step1;

  /// Step 2 label
  ///
  /// In en, this message translates to:
  /// **'Step 2'**
  String get step2;

  /// Step 3 label
  ///
  /// In en, this message translates to:
  /// **'Step 3'**
  String get step3;

  /// Step 4 label
  ///
  /// In en, this message translates to:
  /// **'Step 4'**
  String get step4;

  /// Step 5 label
  ///
  /// In en, this message translates to:
  /// **'Step 5'**
  String get step5;

  /// Select service date title
  ///
  /// In en, this message translates to:
  /// **'Select the service date that suits you'**
  String get selectServiceDate;

  /// Select time title
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// Please select date and time message
  ///
  /// In en, this message translates to:
  /// **'Please select date and time'**
  String get pleaseSelectDateAndTime;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// Select cleaner count title
  ///
  /// In en, this message translates to:
  /// **'Select how many cleaners you need'**
  String get selectCleanerCount;

  /// Please select cleaner count message
  ///
  /// In en, this message translates to:
  /// **'Please select cleaner count'**
  String get pleaseSelectCleanerCount;

  /// Select cleaner title
  ///
  /// In en, this message translates to:
  /// **'Select your service provider'**
  String get selectCleaner;

  /// Please select cleaner message
  ///
  /// In en, this message translates to:
  /// **'Please select a service provider'**
  String get pleaseSelectCleaner;

  /// Share location message
  ///
  /// In en, this message translates to:
  /// **'Share your location so we can reach you on time 🚗✨'**
  String get shareLocationMessage;

  /// Share current location button
  ///
  /// In en, this message translates to:
  /// **'Share Current Location'**
  String get shareCurrentLocation;

  /// Location privacy message
  ///
  /// In en, this message translates to:
  /// **'Your location is used only to determine the service location and will not be shared with any other party.'**
  String get locationPrivacy;

  /// Please select location message
  ///
  /// In en, this message translates to:
  /// **'Please select a location first'**
  String get pleaseSelectLocation;

  /// What is your phone number title
  ///
  /// In en, this message translates to:
  /// **'What is your phone number?'**
  String get whatIsYourPhoneNumber;

  /// Phone number description
  ///
  /// In en, this message translates to:
  /// **'We need your number so we can contact you to confirm the booking.'**
  String get phoneNumberDescription;

  /// Order price label
  ///
  /// In en, this message translates to:
  /// **'Order Price'**
  String get orderPrice;

  /// Book button text
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// Booking successful message
  ///
  /// In en, this message translates to:
  /// **'Booking Successful'**
  String get bookingSuccessful;

  /// Transaction number label
  ///
  /// In en, this message translates to:
  /// **'Transaction Number'**
  String get transactionNumber;

  /// Cleaners label
  ///
  /// In en, this message translates to:
  /// **'Cleaners'**
  String get cleaners;

  /// Date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Service label
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// Time label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Location label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Cleaner count label
  ///
  /// In en, this message translates to:
  /// **'Cleaner Count'**
  String get cleanerCount;

  /// Done button text
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @needWorkers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{You need one worker} =2{You need two workers} other{You need {count} workers}}'**
  String needWorkers(num count);

  /// No description provided for @canSelectWorkers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{You can only select one worker} other{You can only select {count} workers}}'**
  String canSelectWorkers(num count);

  /// Search recommendations title
  ///
  /// In en, this message translates to:
  /// **'Search Recommendations'**
  String get searchRecommendations;

  /// Current location title
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// Error occurred while searching message
  ///
  /// In en, this message translates to:
  /// **'Error occurred while searching'**
  String get errorOccurredWhileSearching;

  /// No results found message
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @experienceMonths.
  ///
  /// In en, this message translates to:
  /// **'{months, plural, =0{Experience: Less than a month} =1{Experience: One month} other{Experience: {months} months}}'**
  String experienceMonths(num months);

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// No description provided for @selectedWorkers.
  ///
  /// In en, this message translates to:
  /// **'Selected {selected} of {total} workers'**
  String selectedWorkers(int selected, int total);

  /// No description provided for @couldNotGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Could not get your location, use the map to select a place.'**
  String get couldNotGetLocation;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @defaultServiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the type of service you need, set the time and place. Leave the rest to us.'**
  String get defaultServiceDescription;

  /// Wallet screen title
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// Add funds button text
  ///
  /// In en, this message translates to:
  /// **'Add Funds'**
  String get addFunds;

  /// Transaction history header
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No transactions message
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get noTransactions;

  /// Available balance label
  ///
  /// In en, this message translates to:
  /// **'Available Balance'**
  String get availableBalance;

  /// Funds added successfully message
  ///
  /// In en, this message translates to:
  /// **'Funds added successfully'**
  String get fundsAddedSuccessfully;

  /// Payment failed message
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get paymentFailed;

  /// Deposit transaction type
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// Withdrawal transaction type
  ///
  /// In en, this message translates to:
  /// **'Withdrawal'**
  String get withdrawal;

  /// Payment transaction type
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// Failed status
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// Moamalat payment title
  ///
  /// In en, this message translates to:
  /// **'Moamalat'**
  String get moamalat;

  /// Cancel payment confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel the payment?'**
  String get cancelPaymentConfirmation;

  /// Quick amounts section title
  ///
  /// In en, this message translates to:
  /// **'Quick Amounts'**
  String get quickAmounts;

  /// Amount label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Please enter amount validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter the amount'**
  String get pleaseEnterAmount;

  /// Please enter valid amount validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get pleaseEnterValidAmount;

  /// Error adding funds message
  ///
  /// In en, this message translates to:
  /// **'An error occurred while adding funds'**
  String get errorAddingFunds;

  /// Message shown when no cleaners are available for a date and service
  ///
  /// In en, this message translates to:
  /// **'No cleaners available on this date for this service'**
  String get noCleanersAvailableForDate;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
