-- Воронка по группам. COUNT(колонка) считает только заполненные значения = пройденные шаги.
SELECT "group",
       COUNT(step1_opened)    AS opened,
       COUNT(step2_entered)   AS entered,
       COUNT(step3_confirmed) AS confirmed,
       COUNT(step4_success)   AS success,
       ROUND(100.0 * COUNT(step4_success) / COUNT(step1_opened), 2) AS conv_1_4_pct
FROM payments_clean
GROUP BY "group"
ORDER BY "group";
