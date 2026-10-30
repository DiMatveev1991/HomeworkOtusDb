-- Сначала выполните 01_create_tables.sql.
-- Это отдельные примеры запросов: запускайте нужный блок.
-- В примерах ProductID, UserID и OrderID равны 1.
-- Замените 1 на идентификатор нужного товара, пользователя или заказа.

-- 1. Добавление нового продукта.
INSERT INTO "Products" ("ProductName", "Description", "Price", "QuantityInStock")
VALUES ('Клавиатура', 'Проводная клавиатура USB', 2500.00, 10)
RETURNING "ProductID";

-- 2. Обновление цены продукта.
UPDATE "Products"
SET "Price" = 2700.00
WHERE "ProductID" = 1;

-- 3. Все заказы определенного пользователя.
SELECT "OrderID", "UserID", "OrderDate", "Status"
FROM "Orders"
WHERE "UserID" = 1
ORDER BY "OrderDate" DESC, "OrderID" DESC;

-- 4. Общая стоимость определенного заказа.
-- TotalCost уже содержит стоимость всей позиции: умножать на Quantity не нужно.
-- Для существующего заказа без позиций результат равен 0.
-- Если заказ не найден, запрос не вернет строку.
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
