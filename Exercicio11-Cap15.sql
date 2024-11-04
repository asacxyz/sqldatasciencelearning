-- 1:
SELECT *
FROM pg.tbl
WHERE orcamento IS NULL;

-- 2:
DELETE FROM pg.tbl
WHERE orcamento IS NULL
  AND publico_alvo = 'Outros';

-- 3:
WITH cte AS (
    SELECT AVG(orcamento) AS media, canais_divulgacao
    FROM pg.tbl
    GROUP BY canais_divulgacao
)
UPDATE pg.tbl
SET orcamento = cte.media
FROM cte
WHERE pg.tbl.canais_divulgacao = cte.canais_divulgacao
  AND pg.tbl.orcamento IS NULL;

-- 4:
ALTER TABLE pg.tbl ADD COLUMN outlier VARCHAR(5);

WITH cte AS (
    SELECT 
        percentile_cont(0.25) WITHIN GROUP (ORDER BY orcamento) - 1.5 * (percentile_cont(0.75) WITHIN GROUP (ORDER BY orcamento) - percentile_cont(0.25) WITHIN GROUP (ORDER BY orcamento)) AS limite_inferior,
        percentile_cont(0.75) WITHIN GROUP (ORDER BY orcamento) + 1.5 * (percentile_cont(0.75) WITHIN GROUP (ORDER BY orcamento) - percentile_cont(0.25) WITHIN GROUP (ORDER BY orcamento)) AS limite_superior
    FROM pg.tbl
)
UPDATE pg.tbl
SET outlier = CASE
                  WHEN orcamento < cte.limite_inferior OR orcamento > cte.limite_superior THEN 'True'
                  ELSE 'False'
              END
FROM cte;

-- 5:
ALTER TABLE pg.tbl ADD COLUMN publico_alvo_encoded INT;

UPDATE pg.tbl
SET publico_alvo_encoded = CASE publico_alvo
                               WHEN 'Publico Alvo 1' THEN 1
                               WHEN 'Publico Alvo 2' THEN 2
                               WHEN 'Publico Alvo 3' THEN 3
                               WHEN 'Publico Alvo 4' THEN 4
                               WHEN 'Publico Alvo 5' THEN 5
                               WHEN 'Outros' THEN 6
                           END;

-- 6:
ALTER TABLE pg.tbl ADD COLUMN canais_divulgacao_encoded INT;

UPDATE pg.tbl
SET canais_divulgacao_encoded = CASE canais_divulgacao
                                    WHEN 'Sites de Notícias' THEN 1
                                    WHEN 'Google' THEN 2
                                    WHEN 'Redes Sociais' THEN 3
                                END;

-- 7:
ALTER TABLE pg.tbl ADD COLUMN tipo_campanha_encoded INT;

UPDATE pg.tbl
SET tipo_campanha_encoded = CASE tipo_campanha
                                WHEN 'Mais Seguidores' THEN 1
                                WHEN 'Promocional' THEN 2
                                WHEN 'Divulgação' THEN 3
                            END;

-- 8:
ALTER TABLE pg.tbl DROP COLUMN publico_alvo;
ALTER TABLE pg.tbl DROP COLUMN canais_divulgacao;
ALTER TABLE pg.tbl DROP COLUMN tipo_campanha;