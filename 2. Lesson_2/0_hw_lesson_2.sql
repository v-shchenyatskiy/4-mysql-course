/*
Задание 1
Установите СУБД MySQL.
Создайте в домашней директории файл .my.cnf, задав в нем логин и пароль, который указывался при установке.
*/

-- Решение - См. скриншоты

---------------------------------------------------------------------------


/*
Задание 2
Создайте БД example.
Разместите в ней таблицу users, состоящую из двух столбцов: 1) числового id и 2) строкового name.
*/

-- 1 Посмотреть установленные БД:
SHOW DATABASES;

-- 2 Создать БД example:
CREATE DATABASE example;

-- 3 Выбрать БД по умолчанию:
USE example

-- 4 Разместить в БД таблицу users:
CREATE TABLE users (id INT, name VARCHAR(45));

-- 5 Посмотреть список таблиц:
SHOW TABLES;

-- 6 Посмотреть описание таблицы users:
DESCRIBE users;


---------------------------------------------------------------------------


/*
Задание 3
Создайте дамп базы данных example из предыдущего задания.
Разверните содержимое дампа в новую базу данных sample.
*/

-- 1 Посмотреть установленные БД:
SHOW DATABASES;

-- 2 Посмотреть и скопировать путь, где лежат БД:
SHOW VARIABLES LIKE 'datadir';

/*
    1) Выйти из БД:
    exit

    2) Перейти в папку:
    cd C:\ProgramData\MySQL\MySQL Server 8.0\Data\

    3) Посмотреть содержимое папки:
    dir

    4) Посмотреть структуру папок:
    tree
*/

-- 3 Создать дамп (резервную копию) БД example:
/* mysqldump { DB_name } > { DB_dump_file_name } */
mysqldump example > example_db_dump.sql

/*
    Посмотреть содержимое папки. Убедиться, что дамп создан:
    dir
*/

-- 4 Создать БД sample:
CREATE DATABASE db_sample;

-- 5 Развернуть содержимое дампа в новую БД sample:
/* mysql { DB_name } < { DB_dump_file } */
mysql db_sample < example_db_dump.sql

-- 6 Выбрать БД по умолчанию:
USE db_sample;

-- 7 Посмотреть список таблиц:
SHOW TABLES;

-- 8 Посмотреть описание таблицы users:
DESCRIBE users;


---------------------------------------------------------------------------


/*
Задание 4
Создайте дамп единственной таблицы help_keyword базы данных mysql.
Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.
*/

-- 1 Выбрать БД по умолчанию:
USE mysql;

-- 2 Посмотреть список таблиц:
SHOW TABLES;

-- 3 Посмотреть описание таблицы help_keyword:
DESCRIBE help_keyword;

-- 4 Создать дамп таблицы help_keyword из первых 100 строк:

/*
    1) Команда ниже создает дамп из первых строк в диапазоне от 1 до 100:
    mysqldump --opt --where="1 limit 100" { DB_name } { table_name } > { DB_dump_file_name }

    2) Для данной задачи команда могла бы выглядеть так:
    mysqldump --opt --where="1 limit 100" mysql help_keyword > hundred_rows_dump.sql

    3) НО! После создания дампа, не получается его выгрузить в другую БД, т.к. он содержит системные файлы.
    опция --opt --skip-lock-tables для решения данной задачи не помогает

    4) В итоге:
    - команду выше с опцией --opt --where="1 limit 100" можно использовать для дампа других (не-системных) БД
    - для решения данной задачи можно использовать другой подход: (см. ниже)

*/


-- 5 Создать БД:
CREATE DATABASE db_hundred_rows;
-- 6 Выбрать БД по умолчанию:
USE db_hundred_rows;
-- 7 Создать одноименную таблицу копированием 100 строк:
CREATE TABLE help_keyword 
    SELECT *
    FROM  mysql.help_keyword
    LIMIT 100;

-- 8 Создать дамп из этой копии БД:
mysqldump db_hundred_rows > hundred_rows_dump.sql

-- ДАЛЕЕ ПРОВЕРКА:

-- 9 Очистить БД db_hundred_rows:
DROP DATABASE db_hundred_rows;
CREATE DATABASE db_hundred_rows;


-- 10 Развернуть содержимое дампа в БД db_hundred_rows:
/* mysql { DB_name } < { DB_dump_file } */
mysql db_hundred_rows < hundred_rows_dump.sql

-- 11 Выбрать БД по умолчанию:
USE db_hundred_rows;

-- 12 Посмотреть список таблиц:
SHOW TABLES;

-- 13 Посмотреть описание таблицы users:
DESCRIBE help_keyword;

-- 14 Посчитать количество строк:
SELECT count(*) FROM help_keyword;