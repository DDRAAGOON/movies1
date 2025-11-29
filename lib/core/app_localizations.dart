class AppLocalizations {
  final String locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(String locale) {
    return AppLocalizations(locale);
  }

  String get email => locale == 'ar' ? 'البريد الإلكتروني' : 'Email';
  String get password => locale == 'ar' ? 'كلمة المرور' : 'Password';
  String get forgetPassword => locale == 'ar' ? 'نسيت كلمة المرور؟' : 'Forget Password?';
  String get login => locale == 'ar' ? 'تسجيل الدخول' : 'Login';
  String get dontHaveAccount => locale == 'ar' ? 'ليس لديك حساب؟' : "Don't Have Account?";
  String get createOne => locale == 'ar' ? 'إنشاء حساب' : 'Create One';
  String get or => locale == 'ar' ? 'أو' : 'OR';
  String get loginWithGoogle => locale == 'ar' ? 'تسجيل الدخول بجوجل' : 'Login With Google';

  String get register => locale == 'ar' ? 'إنشاء حساب' : 'Register';
  String get name => locale == 'ar' ? 'الاسم' : 'Name';
  String get confirmPassword => locale == 'ar' ? 'تأكيد كلمة المرور' : 'Confirm Password';
  String get phone => locale == 'ar' ? 'رقم الهاتف' : 'Phone';
  String get createAccount => locale == 'ar' ? 'إنشاء حساب' : 'Create Account';
  String get alreadyHaveAccount => locale == 'ar' ? 'لديك حساب بالفعل؟' : 'Already Have Account?';

  String get pleaseEnterEmail => locale == 'ar' ? 'يرجى إدخال الإيميل' : 'Please enter your email';
  String get pleaseEnterValidEmail => locale == 'ar' ? 'يرجى إدخال إيميل صحيح (يجب أن يحتوي على @)' : 'Please enter a valid email (must contain @)';
  String get pleaseEnterValidEmailDot => locale == 'ar' ? 'يرجى إدخال إيميل صحيح (يجب أن يحتوي على .)' : 'Please enter a valid email (must contain .)';
  String get pleaseEnterValidEmailFormat => locale == 'ar' ? 'يرجى إدخال إيميل صحيح' : 'Please enter a valid email';
  String get pleaseEnterPassword => locale == 'ar' ? 'يرجى إدخال كلمة المرور' : 'Please enter your password';
  String get passwordTooShort => locale == 'ar' ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل' : 'Password must be at least 6 characters';
  String get pleaseEnterName => locale == 'ar' ? 'يرجى إدخال الاسم' : 'Please enter your name';
  String get pleaseConfirmPassword => locale == 'ar' ? 'يرجى تأكيد كلمة المرور' : 'Please confirm your password';
  String get passwordsDoNotMatch => locale == 'ar' ? 'كلمة المرور غير متطابقة' : 'Passwords do not match';
  String get pleaseEnterPhone => locale == 'ar' ? 'يرجى إدخال رقم الهاتف' : 'Please enter your phone number';

  String get loginSuccess => locale == 'ar' ? 'تم تسجيل الدخول بنجاح' : 'Login successful';
  String get registerSuccess => locale == 'ar' ? 'تم إنشاء الحساب بنجاح' : 'Account created successfully';

  String get userNotFound => locale == 'ar' ? 'لا يوجد حساب بهذا الإيميل. يرجى إنشاء حساب جديد' : 'No account found with this email. Please create a new account';
  String get wrongPassword => locale == 'ar' ? 'كلمة المرور خاطئة' : 'Wrong password';
  String get invalidEmail => locale == 'ar' ? 'الإيميل غير صحيح. يرجى إدخال إيميل صحيح' : 'Invalid email. Please enter a valid email';
  String get userDisabled => locale == 'ar' ? 'هذا الحساب معطل' : 'This account is disabled';
  String get tooManyRequests => locale == 'ar' ? 'محاولات كثيرة جداً، حاول لاحقاً' : 'Too many attempts, please try again later';
  String get operationNotAllowed => locale == 'ar' ? 'هذه العملية غير مسموحة' : 'This operation is not allowed';
  String get networkError => locale == 'ar' ? 'مشكلة في الاتصال بالإنترنت' : 'Network connection error';
  String get unexpectedError => locale == 'ar' ? 'حدث خطأ غير متوقع' : 'An unexpected error occurred';
  String get weakPassword => locale == 'ar' ? 'كلمة المرور ضعيفة جداً. يرجى استخدام كلمة مرور أقوى' : 'Password is too weak. Please use a stronger password';
  String get emailAlreadyInUse => locale == 'ar' ? 'هذا الإيميل مستخدم بالفعل. يرجى استخدام إيميل آخر أو تسجيل الدخول' : 'This email is already in use. Please use another email or login';
  String get registerError => locale == 'ar' ? 'حدث خطأ في التسجيل' : 'Registration error occurred';
  String get loginError => locale == 'ar' ? 'حدث خطأ في تسجيل الدخول' : 'Login error occurred';
  String get googleLoginError => locale == 'ar' ? 'حدث خطأ في تسجيل الدخول بجوجل' : 'Google login error occurred';
  String get accountExistsWithDifferentCredential => locale == 'ar' ? 'يوجد حساب آخر بنفس الإيميل' : 'An account already exists with the same email';
  String get invalidCredential => locale == 'ar' ? 'خطأ في بيانات جوجل' : 'Invalid Google credentials';
  String get googleLoginNotEnabled => locale == 'ar' ? 'تسجيل الدخول بجوجل غير مفعّل' : 'Google login is not enabled';
  String get passwordMismatch => locale == 'ar' ? 'كلمة المرور وتأكيد كلمة المرور غير متطابقين' : 'Password and confirm password do not match';
}

