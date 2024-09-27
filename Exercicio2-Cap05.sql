-- 1:
SELECT COUNT(*), estado
FROM cap05.clientes
GROUP BY estado;

-- 2:
WITH avg_birth_year_cte AS (
    SELECT TO_TIMESTAMP(AVG(EXTRACT(EPOCH FROM data_nascimento)))::date AS avg_birth_date
    FROM cap05.clientes
)
SELECT ROUND((NOW()::date - (SELECT avg_birth_date FROM avg_birth_year_cte)) / 365.25, 2);

-- 3:
SELECT nome
FROM cap05.clientes
WHERE (NOW()::date - data_nascimento) > (365.25 * 30);

-- 4:
SELECT COUNT(*), cidade
FROM cap05.clientes
GROUP BY cidade
ORDER BY 1 DESC
LIMIT 3;

-- 5:
SELECT COUNT(*)
FROM cap05.clientes
WHERE email IS NOT NULL
    AND email <> '';
