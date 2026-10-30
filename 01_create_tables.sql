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

COMMIT;
