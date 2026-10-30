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

COMMIT;
