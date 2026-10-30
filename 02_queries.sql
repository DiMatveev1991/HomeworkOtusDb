-- Демонстрация задания на новой базе после 01_create_tables.sql.
-- Выполните файл целиком ОДИН РАЗ: примеры используют ID из пустой базы.
-- Для повторной проверки создайте новую пустую учебную базу.
BEGIN;

-- 1. Добавление продуктов. Данные также нужны для проверки TOP-5 и остатков.
INSERT INTO "Products" ("ProductName", "Description", "Price", "QuantityInStock")
VALUES
    ('Клавиатура', 'Проводная клавиатура USB', 2500.00, 10),
    ('Мышь', 'Оптическая мышь USB', 1200.00, 20),
    ('Монитор', 'Монитор 24 дюйма', 15000.00, 3),
    ('Принтер', 'Лазерный принтер', 8000.00, 0),
    ('Наушники', 'Наушники с микрофоном', 4000.00, 5),
    ('Веб-камера', 'Камера Full HD', 6000.00, 4)
RETURNING "ProductID", "ProductName", "Price", "QuantityInStock";

-- Подготовка пользователей, заказов и позиций для запросов 3 и 4.
INSERT INTO "Users" ("UserName", "Email")
VALUES
    ('Иван', 'ivan@example.com'),
    ('Анна', 'anna@example.com');

INSERT INTO "Orders" ("UserID", "Status")
VALUES
    (1, 'Оплачен'),
    (1, 'Новый'),
    (2, 'Доставлен');

-- TotalCost содержит стоимость ВСЕЙ позиции на момент покупки.
INSERT INTO "OrderDetails" ("OrderID", "ProductID", "Quantity", "TotalCost")
SELECT 1, "ProductID", 2, "Price" * 2
FROM "Products" WHERE "ProductID" = 1;

INSERT INTO "OrderDetails" ("OrderID", "ProductID", "Quantity", "TotalCost")
SELECT 1, "ProductID", 1, "Price"
FROM "Products" WHERE "ProductID" = 2;

INSERT INTO "OrderDetails" ("OrderID", "ProductID", "Quantity", "TotalCost")
SELECT 2, "ProductID", 1, "Price"
FROM "Products" WHERE "ProductID" = 5;

INSERT INTO "OrderDetails" ("OrderID", "ProductID", "Quantity", "TotalCost")
SELECT 3, "ProductID", 1, "Price"
FROM "Products" WHERE "ProductID" = 3;

-- 2. Обновление цены продукта.
-- Стоимость уже созданной позиции заказа остается прежней.
UPDATE "Products"
SET "Price" = 2700.00
WHERE "ProductID" = 1
RETURNING "ProductID", "ProductName", "Price";

-- 3. Все заказы определенного пользователя.
-- Замените 1 на нужный UserID при работе со своими данными.
SELECT "OrderID", "UserID", "OrderDate", "Status"
FROM "Orders"
WHERE "UserID" = 1
ORDER BY "OrderDate" DESC, "OrderID" DESC;

-- 4. Общая стоимость определенного заказа.
-- Замените 1 на нужный OrderID. TotalCost повторно на Quantity не умножаем.
-- Существующий заказ без позиций даст 0, отсутствующий заказ не даст строку.
SELECT o."OrderID", COALESCE(SUM(d."TotalCost"), 0) AS "OrderTotal"
FROM "Orders" AS o
LEFT JOIN "OrderDetails" AS d ON d."OrderID" = o."OrderID"
WHERE o."OrderID" = 1
GROUP BY o."OrderID";

-- 5. Общее количество единиц товаров на складе.
SELECT COALESCE(SUM("QuantityInStock"), 0) AS "TotalQuantityInStock"
FROM "Products";

-- 6. Пять самых дорогих товаров.
SELECT "ProductID", "ProductName", "Price", "QuantityInStock"
FROM "Products"
ORDER BY "Price" DESC, "ProductID"
LIMIT 5;

-- 7. Товары с остатком менее пяти единиц, включая отсутствующие.
SELECT "ProductID", "ProductName", "QuantityInStock"
FROM "Products"
WHERE "QuantityInStock" < 5
ORDER BY "QuantityInStock", "ProductID";

COMMIT;
