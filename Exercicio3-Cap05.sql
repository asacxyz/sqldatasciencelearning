-- 1:
SELECT SUM(preco * quantidade), categoria
FROM playground.produto
GROUP BY categoria;

-- 2:
SELECT AVG(quantidade), categoria
FROM playground.produto
GROUP BY categoria;

-- 3:
SELECT AVG(preco), categoria
FROM playground.produto
GROUP BY categoria;

-- 4:
SELECT COUNT(DISTINCT categoria)
FROM playground.produto;

-- 5:
SELECT SUM(quantidade) AS quantidade, categoria
FROM playground.produto
GROUP BY categoria
ORDER BY quantidade DESC
LIMIT 1;
