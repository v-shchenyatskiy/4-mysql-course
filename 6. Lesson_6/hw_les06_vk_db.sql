# Домашняя работа - урок 6

# -------------- Операторы, фильтрация, сортировка и ограничение --------------

/*
	Задание 1:
    Пусть задан некоторый пользователь.
    Из всех пользователей соцсети найдите человека, который больше всех общался
    с выбранным пользователем (написал ему сообщений).
*/

-- Решение:

SELECT firstname, lastname 
FROM users 
WHERE id = (
	SELECT from_user_id
	FROM (
		SELECT to_user_id, from_user_id, count(*) as total_msgs FROM messages WHERE to_user_id = 1 GROUP BY from_user_id ORDER BY total_msgs DESC LIMIT 1
	) as tbl
);

-- Объяснение:

-- 1) Пусть заданный пользователь to_user_id = 1

-- 2) Таблица с пользователем, отправившим для to_user_id больше всего сообщений:
SELECT to_user_id, from_user_id, count(*) as total_msgs FROM messages WHERE to_user_id = 1 GROUP BY from_user_id ORDER BY total_msgs DESC LIMIT 1;

-- 3) Из получившейся таблицы выберем поле from_user_id:
SELECT from_user_id
FROM (
	SELECT to_user_id, from_user_id, count(*) as total_msgs FROM messages WHERE to_user_id = 1 GROUP BY from_user_id ORDER BY total_msgs DESC LIMIT 1
) as tbl;

-- 4) Сохраним его значение в @user_sender_id:
SET @user_sender_id = (
	SELECT from_user_id
	FROM (
		SELECT to_user_id, from_user_id, count(*) as total_msgs FROM messages WHERE to_user_id = 1 GROUP BY from_user_id ORDER BY total_msgs DESC LIMIT 1
	) as tbl
);

-- 5) Найдем человека, который больше всех общался с to_user_id:
SELECT firstname, lastname
FROM users 
WHERE id = @user_sender_id;




/*
	Задание 2:
    Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.
*/

-- Решение:
SELECT
	count(*) AS total_likes
FROM `likes`
LEFT JOIN `profiles`
ON `likes`.user_id = `profiles`.user_id
WHERE TIMESTAMPDIFF(YEAR, birthday, now()) < 10;




/*
	Задание 3:
    Определить кто больше поставил лайков (всего): мужчины или женщины.
*/

-- Решение:
-- 1 Вариант: вернет 2 строки - мужчины и женщины со значениями
SELECT
    CASE
		WHEN gender = 'f' THEN "Женщины"
		ELSE "Мужчины"
	END AS 'Пол',
    count(*) AS total_likes
FROM `likes`
LEFT JOIN `profiles`
ON `likes`.user_id = `profiles`.user_id
GROUP BY gender;

-- 2 Вариант: вернет только 1 слово - мужчины или женщины - в зависимости от того, у кого больше лайков
SELECT IF(
	(
		SELECT
			count(*) AS total_likes
		FROM `likes`
		LEFT JOIN `profiles`
		ON `likes`.user_id = `profiles`.user_id
		GROUP BY gender
		HAVING gender = 'm'
	) > (
		SELECT
			count(*) AS total_likes
		FROM `likes`
		LEFT JOIN `profiles`
		ON `likes`.user_id = `profiles`.user_id
		GROUP BY gender
		HAVING gender = 'f'
    ),
	'Мужчины',
	'Женщины'
) AS 'Больше лайков собрали:';
