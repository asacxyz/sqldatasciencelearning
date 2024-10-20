-- 1:
SELECT SUM(valorunitario * quantidade), produto FROM pg.venda GROUP BY produto;

-- 2:
SELECT SUM(valorunitario * quantidade), vendedor FROM pg.venda GROUP BY vendedor;

-- 3:
SELECT SUM(valorunitario * quantidade), datavenda FROM pg.venda GROUP BY datavenda;

-- 4:
SELECT 
    CASE WHEN datavenda IS NULL THEN 'Total' ELSE CAST(datavenda AS VARCHAR) END,
    CASE WHEN produto IS NULL THEN 'Total' ELSE produto END,
    SUM(valorunitario * quantidade) as qtd
FROM pg.venda 
GROUP BY ROLLUP(datavenda, produto) 
ORDER BY GROUPING(datavenda, produto), qtd;

-- 5:
SELECT 
    SUM(valorunitario * quantidade) AS qtd,
    COALESCE(vendedor, 'Total') AS vendedor, 
    COALESCE(produto, 'Total') AS produto
FROM pg.venda
GROUP BY CUBE(vendedor, produto)
ORDER BY GROUPING(vendedor, produto), qtd DESC;

-- Desafio I:
SELECT SUM(valorunitario * quantidade) AS qtd,
       COALESCE(vendedor, 'Total') AS vendedor,
       COALESCE(produto, 'Total') AS produto
FROM pg.venda
GROUP BY GROUPING SETS ((produto), (vendedor), ())
ORDER BY GROUPING(produto, vendedor), qtd;
-- Ou
WITH CTE AS (
    SELECT SUM(valorunitario * quantidade) AS qtd, 'Total' AS vendedor, produto, 0 AS ord FROM pg.venda GROUP BY produto UNION
    SELECT SUM(valorunitario * quantidade) AS qtd, vendedor, 'Total', 1 FROM pg.venda GROUP BY vendedor UNION
    SELECT SUM(valorunitario * quantidade) AS qtd, 'Total', 'Total', 2
    FROM pg.venda
)
SELECT qtd, vendedor, produto FROM CTE ORDER BY ord, qtd;

-- Desafio II:
SELECT
    COALESCE(CAST(EXTRACT(MONTH FROM datavenda) AS VARCHAR), 'Total') AS mes,
    COALESCE(produto, 'Total') AS produto,
    SUM(valorunitario * quantidade) AS qtd
FROM pg.venda
GROUP BY ROLLUP(EXTRACT(MONTH FROM datavenda), produto)
ORDER BY GROUPING(EXTRACT(MONTH FROM datavenda), produto), qtd;