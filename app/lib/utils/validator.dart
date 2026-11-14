class Validators {
  Validators._();
  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w\.\-+]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (!regex.hasMatch(v)) return 'Enter a valid email';
    return null;
  }
  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Name is required';
    if (v.length < 2) return 'Name must be at least 2 characters';
    if (v.length > 30) return 'Name must be under 30 characters';
    final regex = RegExp(r"^[a-zA-Z\u0900-\u097F]+([ '\-][a-zA-Z\u0900-\u097F]+)*$");
    if (!regex.hasMatch(v)) return 'Only letters and spaces allowed';
    return null;
  }
  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Minimum 8 characters required';
    if (v.length > 64) return 'Maximum 64 characters allowed';
    if (v.contains(' ')) return 'Spaces are not allowed';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Add at least 1 uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Add at least 1 lowercase letter';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Add at least 1 number';

    const weak = ['12345678', 'password', 'password1', 'qwerty123'];
    if (weak.contains(v.toLowerCase())) return 'Password is too common';
    return null;
  }
  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return null;
  }

  static String? Function(String?) confirmPassword(String original) {
    return (String? value) {
      if (value == null || value.isEmpty) return 'Please confirm your password';
      if (value != original) return 'Passwords do not match';
      return null;
    };
  }
}