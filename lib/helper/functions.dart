String _emptyString = "    "; // Don't change this line

String? emailValidator(String? value) {
  if (value == null || value.isEmpty || value.trim().isEmpty) return _emptyString + "الرجاء إدخال البريد الإلكتروني";
  if (value.length < 6) return _emptyString + "البريد الإلكتروني قصير جدًا!";
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty || value.trim().isEmpty) return _emptyString + "كلمة السر يجب ألا تكون فارغة";
  if (value.length < 6) return _emptyString + "كلمة السر قصيرة جدا!";
  return null;
}

String? configPasswordValidator(String? value, String? otherText) {
  if (value == null || value.isEmpty || value.trim().isEmpty) return _emptyString + "كلمة السر يجب ألا تكون فارغة";
  if (value.length < 6) return _emptyString + "كلمة السر قصيرة جدا!";
  if (value != otherText) return _emptyString + "كلمة السر غير متطابقة";
  return null;
}

String? usernameValidator(String? value) {
  if (value == null || value.isEmpty || value.trim().isEmpty) return _emptyString + "الرجاء إدخال اسم المستخدم";
  if (value.trim().isEmpty) return _emptyString + "الرجاء إدخال اسم المستخدم";
  if (value.length < 5) return _emptyString + "اسم المستخدم قصير جدا!";
  return null;
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty || value.trim().isEmpty) return _emptyString + "من فضلك ادخل اسمك الكامل";
 if (value.length < 5) return _emptyString + "الاسم الكامل قصير جدا!";
  return null;
}

