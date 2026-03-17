abstract final class Validators {
  static String? required(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'E-mail é obrigatório';
    final regex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value.trim())) return 'E-mail inválido';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Senha é obrigatória';
    if (value.length < 6) return 'Senha deve ter pelo menos 6 caracteres';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value != password) return 'As senhas não conferem';
    return null;
  }

  static String? nota(String? value) {
    if (value == null || value.isEmpty) return 'Nota é obrigatória';
    final nota = double.tryParse(value);
    if (nota == null) return 'Nota inválida';
    if (nota < 0 || nota > 10) return 'Nota deve ser entre 0 e 10';
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nome é obrigatório';
    if (value.trim().length < 3) return 'Nome deve ter pelo menos 3 caracteres';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return null; // Opcional
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 11) return 'Telefone inválido';
    return null;
  }
}
