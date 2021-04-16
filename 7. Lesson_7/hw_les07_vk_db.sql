# Домашняя работа - урок 7

# -------------- Сложные запросы --------------

/*
	Задание 1:
    Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
*/

-- Решение:
SELECT
	user_id,
	(SELECT `name` FROM users WHERE id = user_id) AS 'user_name'
FROM orders
GROUP BY user_id;


/*
	Задание 2:
    Выведите список товаров products и разделов catalogs, который соответствует товару.
*/

-- Решение:
SELECT
	id, `name`, `description`, price,
    (SELECT `name` FROM catalogs WHERE id = catalog_id) AS 'catalog_id'
FROM products;


/*
	Задание 3: (по желанию)
    Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
    Поля from, to и label содержат английские названия городов, поле name — русское.
    Выведите список рейсов flights с русскими названиями городов.
*/

-- Решение:
SELECT
	id,
    (SELECT `name` FROM cities WHERE label = `from`) AS 'from',
    (SELECT `name` FROM cities WHERE label = `to`) AS 'to'
FROM flights;
