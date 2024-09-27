-- 1:
SELECT COUNT(DISTINCT nome), estado
FROM playground.fornecedor
GROUP BY estado;

-- 2:
SELECT COUNT(DISTINCT nome) AS quantidade, estado
FROM playground.fornecedor
GROUP BY estado
ORDER BY quantidade DESC
LIMIT 1;

-- 3:
SELECT COUNT(*)
FROM playground.fornecedor
WHERE EXTRACT(YEAR FROM data_registro) = 2023
    AND EXTRACT(MONTH FROM data_registro) = 9;

-- 4:
SELECT AVG(quantidade)
FROM (
    SELECT EXTRACT(YEAR FROM data_registro) AS ano,
           EXTRACT(MONTH FROM data_registro) AS mes,
           COUNT(*) AS quantidade
    FROM playground.fornecedor
    GROUP BY ano, mes
);

-- 5:
SELECT nome
FROM playground.fornecedor
ORDER BY data_registro DESC
LIMIT 1;
