-- Дельта-метод для ratio-метрики «успехи / попытки» с дисперсией по клиентам.
-- Итог: diff = conversion(B) - conversion(A); se = sqrt(var_ratio(A) + var_ratio(B));
-- 95% ДИ = diff ± 1.96 * se.
WITH per_user AS (            -- одна строка = один клиент
  SELECT user_id, "group",
         COUNT(*)             AS n,   -- попыток
         COUNT(step4_success) AS s    -- успешных оплат
  FROM payments_clean
  GROUP BY user_id, "group"
),
g AS (
  SELECT "group",
         COUNT(*) AS k,
         AVG(n)   AS mn,
         AVG(s)   AS ms,
         (SUM(n * n) - COUNT(*) * AVG(n) * AVG(n)) / (COUNT(*) - 1) AS var_n,
         (SUM(s * s) - COUNT(*) * AVG(s) * AVG(s)) / (COUNT(*) - 1) AS var_s,
         (SUM(n * s) - COUNT(*) * AVG(n) * AVG(s)) / (COUNT(*) - 1) AS cov_ns
  FROM per_user
  GROUP BY "group"
)
SELECT "group",
       k AS users,
       ms / mn AS conversion,
       (var_s / (mn * mn)
        - 2 * ms * cov_ns / (mn * mn * mn)
        + ms * ms * var_n / (mn * mn * mn * mn)) / k AS var_ratio
FROM g
ORDER BY "group";
