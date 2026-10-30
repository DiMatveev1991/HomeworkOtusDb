-- Выполнить в заранее созданной базе данных магазина.
BEGIN;

CREATE TABLE "Products" (
    "ProductID" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "ProductName" VARCHAR(200) NOT NULL,
    "Description" TEXT,
    "Price" NUMERIC(12, 2) NOT NULL CHECK ("Price" >= 0),
    "QuantityInStock" INTEGER NOT NULL DEFAULT 0 CHECK ("QuantityInStock" >= 0)
);

CREATE TABLE "Users" (
    "UserID" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "UserName" VARCHAR(100) NOT NULL,
    "Email" VARCHAR(254) NOT NULL UNIQUE,
    "RegistrationDate" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "Orders" (
    "OrderID" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "UserID" INTEGER NOT NULL REFERENCES "Users" ("UserID"),
    "OrderDate" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "Status" VARCHAR(50) NOT NULL DEFAULT 'Новый'
);

CREATE TABLE "OrderDetails" (
    "OrderDetailID" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "OrderID" INTEGER NOT NULL REFERENCES "Orders" ("OrderID"),
    "ProductID" INTEGER NOT NULL REFERENCES "Products" ("ProductID"),
    "Quantity" INTEGER NOT NULL CHECK ("Quantity" > 0),
    -- Стоимость всей позиции на момент покупки, а не текущая цена товара.
    "TotalCost" NUMERIC(14, 2) NOT NULL CHECK ("TotalCost" >= 0)
);

CREATE INDEX "IX_Orders_UserID" ON "Orders" ("UserID");
CREATE INDEX "IX_OrderDetails_OrderID" ON "OrderDetails" ("OrderID");
CREATE INDEX "IX_OrderDetails_ProductID" ON "OrderDetails" ("ProductID");

-- Описания сохраняются в метаданных PostgreSQL и видны в свойствах объектов.
COMMENT ON TABLE "Products" IS 'Товары виртуального магазина.';
COMMENT ON COLUMN "Products"."ProductID" IS 'Уникальный идентификатор товара. Генерируется автоматически.';
COMMENT ON COLUMN "Products"."ProductName" IS 'Название товара.';
COMMENT ON COLUMN "Products"."Description" IS 'Описание товара.';
COMMENT ON COLUMN "Products"."Price" IS 'Текущая цена одной единицы товара. Не может быть отрицательной.';
COMMENT ON COLUMN "Products"."QuantityInStock" IS 'Количество единиц товара на складе. Не может быть отрицательным.';

COMMENT ON TABLE "Users" IS 'Пользователи виртуального магазина.';
COMMENT ON COLUMN "Users"."UserID" IS 'Уникальный идентификатор пользователя. Генерируется автоматически.';
COMMENT ON COLUMN "Users"."UserName" IS 'Имя пользователя.';
COMMENT ON COLUMN "Users"."Email" IS 'Электронная почта пользователя. Уникальна.';
COMMENT ON COLUMN "Users"."RegistrationDate" IS 'Дата и время регистрации пользователя с учетом часового пояса.';

COMMENT ON TABLE "Orders" IS 'Заказы пользователей виртуального магазина.';
COMMENT ON COLUMN "Orders"."OrderID" IS 'Уникальный идентификатор заказа. Генерируется автоматически.';
COMMENT ON COLUMN "Orders"."UserID" IS 'Идентификатор пользователя, оформившего заказ. Ссылка на Users.UserID.';
COMMENT ON COLUMN "Orders"."OrderDate" IS 'Дата и время оформления заказа с учетом часового пояса.';
COMMENT ON COLUMN "Orders"."Status" IS 'Статус заказа. По умолчанию: Новый.';

COMMENT ON TABLE "OrderDetails" IS 'Позиции заказов с количеством и сохраненной стоимостью товаров.';
COMMENT ON COLUMN "OrderDetails"."OrderDetailID" IS 'Уникальный идентификатор позиции заказа. Генерируется автоматически.';
COMMENT ON COLUMN "OrderDetails"."OrderID" IS 'Идентификатор заказа. Ссылка на Orders.OrderID.';
COMMENT ON COLUMN "OrderDetails"."ProductID" IS 'Идентификатор товара. Ссылка на Products.ProductID.';
COMMENT ON COLUMN "OrderDetails"."Quantity" IS 'Количество единиц товара в позиции заказа. Должно быть больше нуля.';
COMMENT ON COLUMN "OrderDetails"."TotalCost" IS 'Общая стоимость всей позиции на момент покупки: цена единицы, умноженная на количество. Не пересчитывается при изменении текущей цены товара.';

COMMENT ON INDEX "IX_Orders_UserID" IS 'Индекс для поиска заказов пользователя.';
COMMENT ON INDEX "IX_OrderDetails_OrderID" IS 'Индекс для поиска позиций заказа.';
COMMENT ON INDEX "IX_OrderDetails_ProductID" IS 'Индекс для поиска позиций заказов по товару.';

COMMIT;
