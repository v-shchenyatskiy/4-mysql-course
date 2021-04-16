# Домашняя работа - урок 5

# -------------- Операторы, фильтрация, сортировка и ограничение --------------

/*
	Задание 1:
    Пусть в таблице users поля created_at и updated_at оказались незаполненными.
    Заполните их текущими датой и временем.
*/

-- Решение:
UPDATE `vk`.`users` SET `created_at` = NOW(), `updated_at` = NOW();
-- Комментарий:
-- В клиенте стоит "Safe update mode", поэтому вылетает ошибка 1175. Надо отключать в настройках.
-- Зато через консоль работает отлично.


/*
	Задание 2:
    Таблица users была неудачно спроектирована.
    Записи created_at и updated_at были заданы типом VARCHAR.
    В них долгое время помещались значения в формате "20.10.2017 8:10".
	Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
*/

-- Решение:
-- 1) Преобразовать все данные из "20.10.2017 8:10" --> "2017-10-20 8:10":
UPDATE `vk`.`users` SET
	`created_at` = REGEXP_REPLACE(`created_at`, "^([0-9]{1,2}).([0-9]{2}).([0-9]{4})" , "$3-$2-$1"),
    `updated_at` = REGEXP_REPLACE(`updated_at`, "^([0-9]{1,2}).([0-9]{2}).([0-9]{4})" , "$3-$2-$1");

-- 2) Преобразовать все данные из "2017-10-20 8:10" --> "2017-10-20 08:10:00":
UPDATE `vk`.`users` SET
	`created_at` = CONCAT(DATE(`created_at`), " ", TIME_FORMAT(`created_at`, "%T")),
	`updated_at` = CONCAT(DATE(`updated_at`), " ", TIME_FORMAT(`updated_at`, "%T"));

-- 3) Преобразовать поля к типу DATETIME:
ALTER TABLE `vk`.`users`
CHANGE COLUMN `created_at` `created_at` DATETIME NULL DEFAULT NOW(),
CHANGE COLUMN `updated_at` `updated_at` DATETIME ON UPDATE NOW();


/*
	Задание 3:
    В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры:
     - 0, если товар закончился и
     - выше нуля, если на складе имеются запасы.
	Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
    Однако, нулевые запасы должны выводиться в конце, после всех записей.
*/

-- Решение:
SELECT * FROM `storehouses_products` ORDER BY IF (value > 0, 0, 1), value;
-- Это сокращенное написание от строки ниже:
-- SELECT *, IF (value > 0, 0, 1) AS order_helper FROM `storehouses_products` ORDER BY order_helper, value;
-- Но в этом случае в конце будет дополнительное поле --> order_helper.


/*
	Задание 4: (по желанию)
    Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
    Месяцы заданы в виде списка английских названий ('may', 'august').
*/

-- Решение:
-- Предположим, в поле birthday данные хранятся в формате --> '1994-05-17', тогда:
SELECT * FROM `users` WHERE DATE_FORMAT(birthday, "%M") IN ("May", "August");


/*
	Задание 5: (по желанию)
    Из таблицы catalogs извлекаются записи при помощи запроса:
	  SELECT * FROM catalogs WHERE id IN (5, 1, 2);
    Отсортируйте записи в порядке, заданном в списке IN.
*/

-- Решение:
SELECT * FROM `users` WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2);


# -------------- Агрегация данных --------------


/*
	Задание 1:
    Подсчитайте средний возраст пользователей в таблице users.
*/

-- Решение:
-- средний возраст:
SELECT AVG(FLOOR(DATEDIFF(NOW(), birthday)/365.25)) as avg_age FROM `users`;


/*
	Задание 2:
    Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели текущего года.
*/

-- Решение:
SELECT DAYNAME(birthday) AS day_name, count(*) AS total_Bdays FROM `users` GROUP BY day_name;


/*
    Задание 3: (по желанию)
    Подсчитайте произведение чисел в столбце таблицы value=[1,2,3,4,5].
*/

-- Решение:
SELECT ROUND(EXP(SUM(LN(`value`)))) as multiple FROM `users`;
