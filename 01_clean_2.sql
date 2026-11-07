-- Очистка: те же решения, что в журнале решений в ноутбуке.
-- Колонка "group" в кавычках: GROUP — служебное слово SQL.

DROP VIEW IF EXISTS payments_clean;
DROP VIEW IF EXISTS users_clean;

-- Клиенты: есть группа, правдоподобный возраст, без тестового аккаунта 9004
-- (пропуск города сам по себе не причина исключать клиента)
CREATE VIEW users_clean AS
SELECT *
FROM users
WHERE "group" IN ('A', 'B')
  AND age BETWEEN 14 AND 100
  AND user_id NOT IN (9004);

-- Попытки: клиент есть в чистой таблице, группа платежа = группе клиента,
-- без технических платежей из журнала решений
CREATE VIEW payments_clean AS
SELECT p.*
FROM payments AS p
JOIN users_clean AS u
  ON u.user_id = p.user_id
 AND u."group" = p."group"
WHERE p.payment_id NOT IN (99001, 99002, 99003);
