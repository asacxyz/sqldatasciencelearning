-- 1:
SELECT COUNT(*), id_produto
FROM playground.venda
GROUP BY id_produto;

-- 2:
SELECT COUNT(DISTINCT id_produto)
FROM playground.venda;

-- 3:
SELECT EXTRACT(DAY FROM data_venda) AS dia,
       EXTRACT(MONTH FROM data_venda) AS mes,
       EXTRACT(YEAR FROM data_venda) AS ano,
       COUNT(*)
FROM playground.venda
GROUP BY dia, mes, ano
ORDER BY mes, dia;

-- 4:
SELECT EXTRACT(DAY FROM data_venda) AS dia,
       EXTRACT(MONTH FROM data_venda) AS mes,
       EXTRACT(YEAR FROM data_venda) AS ano,
       SUM(valor)
FROM playground.venda
GROUP BY dia, mes, ano
HAVING SUM(valor) > 100;

-- 5:
SELECT id_produto
FROM playground.venda
GROUP BY id_produto
HAVING SUM(valor) > 50;
