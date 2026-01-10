class Hatalar {
  static String hataGoster(String hataKodu) {
    switch (hataKodu) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
        return "Bu email başka bir kullanıcı tarafından alınmış, lütfen başka bir email seçiniz";
        break;
      case "email-already-in-use":
        return "Bu email başka bir kullanıcı tarafından alınmış, lütfen başka bir email seçiniz";
        break;
      case "invalid-credential":
        return "Bu email yanlış veya kullanılmıyor";
        break;
      default:
        return "Bir hata oluştu";
        break;
    }
  }
}
