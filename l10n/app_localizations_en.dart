// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Buzzy Bee';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get loading => 'Loading...';

  @override
  String get noInternetConnection =>
      'No internet connection. Please check your network.';

  @override
  String get serverError => 'Server error occurred. Please try again later.';

  @override
  String get popularCleaners => 'Popular Cleaners';

  @override
  String get serviceCategories => 'Service Categories';

  @override
  String get retry => 'Retry';

  @override
  String get selectDate => 'Select Date';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get selectCleaners => 'Select Number of Cleaners';

  @override
  String get availableCleaners => 'Available Cleaners';

  @override
  String get selectLocation => 'Select Location';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get search => 'Search services...';

  @override
  String get orders => 'Orders';

  @override
  String get all => 'All';

  @override
  String get inProgress => 'In Progress';

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get noOrders => 'No orders found';

  @override
  String get favorites => 'Favorites';

  @override
  String get noFavorites => 'No favorites yet';

  @override
  String get price => 'Price';

  @override
  String get currency => 'LYD';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get pending => 'Pending';

  @override
  String get account => 'Account';

  @override
  String get phone => 'Phone';

  @override
  String get support => 'Support';

  @override
  String get termsAndConditions => 'Terms & Conditions';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get welcomeToBuzzyBee => 'Welcome to Buzzy Bee';

  @override
  String get yourTrustedCleaningServicePartner =>
      'Your trusted cleaning service partner';

  @override
  String get dontHaveAnAccount => 'Don\'t have an account?';

  @override
  String get pleaseEnterYourPhoneNumber => 'Please enter your phone number';

  @override
  String get pleaseEnterYourPassword => 'Please enter your password';

  @override
  String get pleaseEnterYourName => 'Please enter your name';

  @override
  String get pleaseEnterYourEmail => 'Please enter your email';

  @override
  String get pleaseEnterAValidEmail => 'Please enter a valid email';

  @override
  String get pleaseEnterAValidPhoneNumber =>
      'Please enter a valid phone number';

  @override
  String get registrationSuccessful => 'Registration successful! Please login.';

  @override
  String get signUpAndLetUsHandleTheMess =>
      'Sign up and let us handle the mess';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get passwordMustBeAtLeast8Characters =>
      'Password must be at least 8 characters';

  @override
  String get nameMustBeAtLeast2Characters =>
      'Name must be at least 2 characters';

  @override
  String get alreadyHaveAnAccount => 'Already have an account?';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get pleaseConfirmYourPassword => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get name => 'Name';

  @override
  String get personalAccount => 'Personal Account';

  @override
  String get changePassword => 'Change Password';

  @override
  String get frequentlyAskedQuestions => 'Frequently Asked Questions';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get aboutTheApp => 'About the App';

  @override
  String get step1 => 'Step 1';

  @override
  String get step2 => 'Step 2';

  @override
  String get step3 => 'Step 3';

  @override
  String get step4 => 'Step 4';

  @override
  String get step5 => 'Step 5';

  @override
  String get selectServiceDate => 'Select the service date that suits you';

  @override
  String get selectTime => 'Select Time';

  @override
  String get pleaseSelectDateAndTime => 'Please select date and time';

  @override
  String get continueText => 'Continue';

  @override
  String get selectCleanerCount => 'Select how many cleaners you need';

  @override
  String get pleaseSelectCleanerCount => 'Please select cleaner count';

  @override
  String get selectCleaner => 'Select your service provider';

  @override
  String get pleaseSelectCleaner => 'Please select a service provider';

  @override
  String get shareLocationMessage =>
      'Share your location so we can reach you on time 🚗✨';

  @override
  String get shareCurrentLocation => 'Share Current Location';

  @override
  String get locationPrivacy =>
      'Your location is used only to determine the service location and will not be shared with any other party.';

  @override
  String get pleaseSelectLocation => 'Please select a location first';

  @override
  String get whatIsYourPhoneNumber => 'What is your phone number?';

  @override
  String get phoneNumberDescription =>
      'We need your number so we can contact you to confirm the booking.';

  @override
  String get orderPrice => 'Order Price';

  @override
  String get book => 'Book';

  @override
  String get bookingSuccessful => 'Booking Successful';

  @override
  String get transactionNumber => 'Transaction Number';

  @override
  String get cleaners => 'Cleaners';

  @override
  String get date => 'Date';

  @override
  String get service => 'Service';

  @override
  String get time => 'Time';

  @override
  String get location => 'Location';

  @override
  String get cleanerCount => 'Cleaner Count';

  @override
  String get done => 'Done';

  @override
  String needWorkers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You need $count workers',
      two: 'You need two workers',
      one: 'You need one worker',
    );
    return '$_temp0';
  }

  @override
  String canSelectWorkers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You can only select $count workers',
      one: 'You can only select one worker',
    );
    return '$_temp0';
  }

  @override
  String get searchRecommendations => 'Search Recommendations';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get errorOccurredWhileSearching => 'Error occurred while searching';

  @override
  String get noResultsFound => 'No results found';

  @override
  String experienceMonths(num months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Experience: $months months',
      one: 'Experience: One month',
      zero: 'Experience: Less than a month',
    );
    return '$_temp0';
  }

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String selectedWorkers(int selected, int total) {
    return 'Selected $selected of $total workers';
  }

  @override
  String get couldNotGetLocation =>
      'Could not get your location, use the map to select a place.';

  @override
  String get bookNow => 'Book Now';

  @override
  String get defaultServiceDescription =>
      'Choose the type of service you need, set the time and place. Leave the rest to us.';

  @override
  String get wallet => 'Wallet';

  @override
  String get addFunds => 'Add Funds';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get noTransactions => 'No transactions';

  @override
  String get availableBalance => 'Available Balance';

  @override
  String get fundsAddedSuccessfully => 'Funds added successfully';

  @override
  String get paymentFailed => 'Payment failed';

  @override
  String get deposit => 'Deposit';

  @override
  String get withdrawal => 'Withdrawal';

  @override
  String get payment => 'Payment';

  @override
  String get failed => 'Failed';

  @override
  String get moamalat => 'Moamalat';

  @override
  String get cancelPaymentConfirmation =>
      'Are you sure you want to cancel the payment?';

  @override
  String get quickAmounts => 'Quick Amounts';

  @override
  String get amount => 'Amount';

  @override
  String get pleaseEnterAmount => 'Please enter the amount';

  @override
  String get pleaseEnterValidAmount => 'Please enter a valid amount';

  @override
  String get errorAddingFunds => 'An error occurred while adding funds';

  @override
  String get noCleanersAvailableForDate =>
      'No cleaners available on this date for this service';
}
