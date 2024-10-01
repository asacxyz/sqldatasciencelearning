-- 1:
SELECT id_cliente,
    CASE WHEN pais_cliente = 'Brasil' THEN 1 ELSE 0 END AS Brasil,
    CASE WHEN pais_cliente = 'Canadá' THEN 1 ELSE 0 END AS Canadá,
    CASE WHEN pais_cliente = 'Inglaterra' THEN 1 ELSE 0 END AS Inglaterra,
    CASE WHEN visitas_ultimo_mes = 'sim' THEN 1 ELSE 0 END AS visitas_ultimo_mes,
    CASE WHEN compras_ultimo_mes = '0-5' THEN 1 WHEN compras_ultimo_mes = '6-10' THEN 2 WHEN compras_ultimo_mes = '11-15' THEN 3 WHEN compras_ultimo_mes = '16-20' THEN 4 ELSE 5 END AS compras_ultimo_mes,
    CASE WHEN fez_compra_mes_atual = 'true' THEN 1 ELSE 0 END AS fez_compra_mes_atual,
    total_gasto_ultimo_mes
FROM playground.venda_loja_online;
