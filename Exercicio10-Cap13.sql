WITH LancamentosOrdenados AS (
    SELECT
        data_lancamento,
        centro_custo,
        conta_credito,
        valor,
        ROW_NUMBER() OVER (PARTITION BY centro_custo ORDER BY data_lancamento) AS ordem
    FROM
        pg.lancamentocontabil
),
MediaMovel AS (
    SELECT
        L1.centro_custo,
        L1.data_lancamento,
        L1.conta_credito,
        L1.valor,
        ROUND(AVG(L1.valor) OVER (PARTITION BY L1.centro_custo ORDER BY L1.ordem RANGE BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS media_movel_3dias
    FROM
        LancamentosOrdenados L1
)
SELECT
    M.centro_custo,
    M.conta_credito,
    M.data_lancamento,
    M.valor,
    M.media_movel_3dias,
    DENSE_RANK() OVER (PARTITION BY M.data_lancamento ORDER BY M.media_movel_3dias DESC) AS rank_media_movel
FROM
    MediaMovel M
ORDER BY
    M.data_lancamento, rank_media_movel;