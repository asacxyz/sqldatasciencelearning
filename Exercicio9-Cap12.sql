-- 1:
SELECT
    *
    , ROUND(AVG(valor_venda) OVER (ORDER BY data_venda ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING), 4) AS media_movel
FROM pg.venda_temporal;

-- 2:
SELECT
    *
    , ROUND(AVG(valor_venda) OVER (ORDER BY data_venda ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING), 4) AS media_movel
FROM pg.venda_temporal;

-- 3:
SELECT
    *
    , CASE
        WHEN LAG(valor_venda) OVER () IS NULL THEN 'Nenhuma venda no dia anterior'
        ELSE CAST(valor_venda - LAG(valor_venda) OVER () AS VARCHAR)
    END AS diferenca
FROM pg.venda_temporal;

-- 4:
SELECT
    *
    , SUM(valor_venda) OVER (ORDER BY data_venda) AS soma_acumulada
FROM pg.venda_temporal;

-- 5:
SELECT
    *
    , DENSE_RANK() OVER (PARTITION BY funcionario_id ORDER BY soma DESC) AS rank
FROM (
    SELECT 
        SUM(valor_venda) AS soma, 
        funcionario_id, 
        data_venda 
    FROM pg.venda_temporal 
    GROUP BY funcionario_id, data_venda
) AS vendas_agrupadas;
