class Validations {
  static String? emailValidation(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'من فضلك أدخل البريد الالكتروني';
    }
    if (!regex.hasMatch(value)) {
      return 'من فضلك أدخل بريد الكتروني صحيح';
    } else {
      return null;
    }
  }

  static bool isEmailValid(String? email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email ?? '');
  }

  static bool isPhoneValid(String? input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input ?? '');

  static String? passwordValidation(String? value) {
    // RegExp regex =
    // RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    RegExp regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (value == null || value.isEmpty) {
      return 'من فضلك ادخل كلمة السر';
    }
    if (value.length < 8) {
      return 'من فضلك ادخل كلمة سر صحيحة';
    } else {
      if (!regex.hasMatch(value)) {
        return 'من فضلك ادخل كلمة مرور تحتوي علي ٨ حروف وارقام';
      } else {
        return null;
      }
    }
  }

  static String? userNameValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'من فضلك ادخل اسم المسخدم';
    }
    if (value.length < 4) {
      return 'اسم المستخدم لا يقل عن ٤ خروف';
    } else {
      return null;
    }
  }

  static String? mobileValidation(String? value) {
    if (value == null || value.isEmpty) return 'من فضلك ادخل رقم الهاتف';
    if (value.length < 10) {
      return 'رقم الهاتف غير صحيح';
    } else {
      return null;
    }
  }

  static String? confirmValidation(String? value, String input) {
    if (value == null || value.isEmpty) return 'من فض اكتب كلمة السر مرة أخري';
    if (value != input) {
      return 'يجب أن تتطابق كلمتا المرور';
    } else {
      return null;
    }
  }
}
