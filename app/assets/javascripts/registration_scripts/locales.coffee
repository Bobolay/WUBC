window.locales = {
  uk: {
    add_office: "Додати ще офіс"
    save_office: "Зберегти"
    remove_office: "Видалити"
    add_personal_helper: "Додати ще помічника"
    save_personal_helper: "Зберегти"
    remove_personal_helper: "Видалити"
    add_phone: "Додати ще телефон"
    remove_phone: "Видалити телефон"
    add_company: "Додати компанію"
    remove_company: "Видалити компанію"
    save_company: "Підтвердити зміни"
    save_profile: "Підтвердити зміни"
    attributes: {
      premium: "Тільки для членів клубу"
      first_name: "Ім'я"
      last_name: "Прізвище"
      middle_name: "По батькові"
      birth_date: "Дата народження"
      phone: "Телефон"
      email: "Логін e-mail"
      password: "Пароль"
      new_password: "Новий пароль"
      password_confirmation: "Підтвердження паролю"
      phones: "Телефони"

      industry: "Сфера здійснення діяльності"
      region: "Місце здійснення діяльності"
      regions: "Місце здійснення діяльності"
      position: "Посада"
      employees_count: "Кількість працівників"
      company_site: "Сайт компанії"
      offices: "Контакти офісів"
      social_networks: "Соц. мережі компанії"
      user_social_networks: "Особисті соц. мережі"
      description: "Опис діяльності"

      city: "Місто"
      address: "Адреса"
      hobby: "Хоббі"
      name: "Назва компанії"

      personal_helpers: "Особисті помічники"

    }
    placeholders: {
      first_name: "Петро"
      middle_name: "Петрович"
      last_name: "Петренко"
      birth_date: "01.12.1991"
      email: "user@server.com"
      password: "Пароль"
      password_confirmation: "Повторіть пароль"

      description: "Напишіть щось про свою компанію"
      industry: "Розваги"
      region: "Львів"
      position: "директор"
      employees_count: "24"
      company_site: "site.com"

      city: "Львів"
      address: "вул. Наукова, 21"
      hobby: "Читаю книжки, слухаю музику, ходжу в театр"
      name: "Моя компанія"
      phone: "Телефон"

      social_facebook: "https://www.facebook.com/YOUR_ACCOUNT"
      social_google_plus: "https://plus.google.com/YOUR_ACCOUNT"

    }
    summary_labels: {
      social_facebook: "Сторінка Facebook"
      social_google_plus: "Сторінка Google+"
      personal_helpers: "Особисті<br/>помічники"
    }
    help: {
      password: "Мінімум 8 символів"

    }
  }
}



window.current_locale = "uk"
window.t = (key)->
  translation = locales[current_locale]
  key_parts = key.split(".")
  i = 0
  for key_part in key_parts
#console.log "key_part: ", key_part
    translation = translation[key_part]
    if translation == undefined || translation == null
      return null
    else if i == key_parts - 1
      return translation
    i++

  translation