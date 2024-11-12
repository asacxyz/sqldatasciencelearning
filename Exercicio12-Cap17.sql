-- 1
SELECT 
    COUNT(id_vendas), 
    ROUND(AVG(quantidade), 2) 
FROM 
    pg.venda;

-- 2
SELECT
    DISTINCT id_produto
FROM 
    pg.venda;

-- 3
SELECT 
    COUNT(*) AS qtd, 
    id_produto 
FROM 
    pg.venda 
GROUP BY 
    id_produto 
ORDER BY 
    qtd DESC;

-- 4
SELECT 
    COUNT(*) AS qtd, 
    id_produto 
FROM 
    pg.venda 
GROUP BY 
    id_produto 
ORDER BY 
    qtd DESC 
LIMIT 5;

-- 5
SELECT 
    id_cliente, 
    COUNT(*) 
FROM 
    pg.venda 
GROUP BY 
    id_cliente 
HAVING 
    COUNT(*) >= 6;

-- 6
SELECT 
    CASE 
        WHEN EXTRACT(MONTH FROM data_venda) = 1 THEN 'Janeiro'
        WHEN EXTRACT(MONTH FROM data_venda) = 2 THEN 'Fevereiro'
        WHEN EXTRACT(MONTH FROM data_venda) = 3 THEN 'Março'
        WHEN EXTRACT(MONTH FROM data_venda) = 4 THEN 'Abril'
        WHEN EXTRACT(MONTH FROM data_venda) = 5 THEN 'Maio'
        WHEN EXTRACT(MONTH FROM data_venda) = 6 THEN 'Junho'
        WHEN EXTRACT(MONTH FROM data_venda) = 7 THEN 'Julho'
        WHEN EXTRACT(MONTH FROM data_venda) = 8 THEN 'Agosto'
        WHEN EXTRACT(MONTH FROM data_venda) = 9 THEN 'Setembro'
        WHEN EXTRACT(MONTH FROM data_venda) = 10 THEN 'Outubro'
        WHEN EXTRACT(MONTH FROM data_venda) = 11 THEN 'Novembro'
        WHEN EXTRACT(MONTH FROM data_venda) = 12 THEN 'Dezembro'
    END AS mes,
    SUM(venda.quantidade * produto.preco)
FROM 
    pg.venda
JOIN 
    pg.produto ON venda.id_produto = produto.id_produto
WHERE 
    EXTRACT(YEAR FROM data_venda) = 2024 
GROUP BY 
    EXTRACT(MONTH FROM data_venda)
ORDER BY 
    EXTRACT(MONTH FROM data_venda);

-- 7
SELECT 
    COUNT(*), 
    EXTRACT(MONTH FROM data_venda) 
FROM 
    pg.venda 
WHERE 
    EXTRACT(MONTH FROM data_venda) IN (6, 7) 
    AND EXTRACT(YEAR FROM data_venda) = 2023 
GROUP BY 
    EXTRACT(MONTH FROM data_venda);

-- 8
SELECT
    SUM(pg.produto.preco * pg.venda.quantidade) AS total,
    COALESCE(CAST(EXTRACT(YEAR FROM pg.venda.data_venda) AS VARCHAR), 'Total') AS ano,
    COALESCE(CAST(EXTRACT(MONTH FROM pg.venda.data_venda) AS VARCHAR), 'Total') AS mes
FROM 
    pg.venda
JOIN 
    pg.produto ON pg.venda.id_produto = pg.produto.id_produto
GROUP BY 
    ROLLUP(EXTRACT(YEAR FROM pg.venda.data_venda), EXTRACT(MONTH FROM pg.venda.data_venda))
ORDER BY 
    GROUPING(EXTRACT(YEAR FROM pg.venda.data_venda), EXTRACT(MONTH FROM pg.venda.data_venda)), 
    mes;

-- 9
SELECT 
    COUNT(*), 
    id_produto 
FROM 
    pg.venda 
GROUP BY 
    id_produto
HAVING
    COUNT(*) < 100
ORDER BY 
    1 DESC;

-- Considerando que cada venda é composta por um registro * quantidade:
SELECT 
    SUM(quantidade) AS qtd, 
    id_produto 
FROM 
    pg.venda 
GROUP BY 
    id_produto 
HAVING 
    SUM(quantidade) < 100;

-- 10
WITH cte AS (
    SELECT * 
    FROM 
        pg.venda 
    JOIN 
        pg.produto ON pg.venda.id_produto = pg.produto.id_produto 
    WHERE 
        pg.produto.nome IN ('Smartwatch', 'Smartphone', 'Notebook')
)
SELECT 
    id_cliente 
FROM 
    cte 
GROUP BY 
    id_cliente 
HAVING 
    COUNT(DISTINCT nome) > 1;

-- 11
WITH cte AS (
    SELECT * 
    FROM 
        pg.venda 
    JOIN 
        pg.produto ON pg.venda.id_produto = pg.produto.id_produto 
    WHERE 
        pg.produto.nome IN ('Smartwatch', 'Smartphone')
)
SELECT 
    id_cliente 
FROM 
    cte 
GROUP BY 
    id_cliente 
HAVING 
    COUNT(DISTINCT nome) = 2;

-- 12
WITH 
    smartwatch AS (
        SELECT id_cliente 
        FROM 
            pg.venda 
        JOIN 
            pg.produto ON venda.id_produto = produto.id_produto 
        WHERE 
            produto.nome = 'Smartwatch'
    ),
    smartphone AS (
        SELECT id_cliente 
        FROM 
            pg.venda 
        JOIN 
            pg.produto ON venda.id_produto = produto.id_produto 
        WHERE 
            produto.nome = 'Smartphone'
    ),
    wrong_buyers AS (
        SELECT id_cliente 
        FROM 
            pg.venda 
        JOIN 
            pg.produto ON venda.id_produto = produto.id_produto 
        WHERE 
            produto.nome = 'Notebook' 
            AND EXTRACT(YEAR FROM venda.data_venda) = 2024 
            AND EXTRACT(MONTH FROM venda.data_venda) = 5
    )
SELECT 
    smartwatch.* 
FROM 
    smartwatch 
JOIN 
    smartphone ON smartwatch.id_cliente = smartphone.id_cliente 
WHERE 
    smartphone.id_cliente NOT IN (SELECT id_cliente FROM wrong_buyers);

-- 13
SELECT 
    data_venda, 
    ROUND(AVG(quantidade) OVER (ORDER BY data_venda ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING), 2) 
FROM 
    pg.venda;

-- 14
SELECT
    AVG(quantidade) OVER (ORDER BY data_venda ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING) AS media,
    STDDEV(quantidade) OVER (ORDER BY data_venda ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING) AS desvio_padrao
FROM 
    pg.venda;

-- 15
SELECT 
    nome 
FROM 
    pg.cliente 
LEFT JOIN 
    pg.venda ON cliente.id_cliente = venda.id_cliente 
WHERE 
    venda.id_cliente IS NULL;
