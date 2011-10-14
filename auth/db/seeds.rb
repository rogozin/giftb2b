#encoding:utf-8;
    Role.find_or_create_by_name_and_group("Менеджер продаж", 0)
    Role.find_or_create_by_name_and_group("Редактор каталга", 0)
    Role.find_or_create_by_name_and_group("Редактор контента", 0)
    Role.find_or_create_by_name_and_group("Учет образцов", 2)
    Role.find_or_create_by_name_and_group("Пользователь", 1)
    Role.find_or_create_by_name_and_group("Менеджер фирмы", 2)
    Role.find_or_create_by_name_and_group("Пользователь фирмы", 2)
    Role.find_or_create_by_name_and_group("Интернет магазин", 3)
