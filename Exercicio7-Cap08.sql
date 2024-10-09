-- 1:
SELECT l.titulo, a.nome 
FROM playground.livro_vendido lv
JOIN playground.autor a USING (id_autor)
JOIN playground.livro l USING (id_livro);

-- 2:
SELECT a.nome, CASE WHEN l.titulo IS NULL THEN 'Não têm livros cadastrados' ELSE l.titulo END 
FROM playground.autor a
LEFT JOIN playground.livro_vendido lv ON a.id_autor = lv.id_autor
LEFT JOIN playground.livro l ON lv.id_livro = l.id_livro;

-- 3:
SELECT l.titulo, CASE WHEN a.nome IS NULL THEN 'Não têm autores cadastrados' ELSE a.nome END 
FROM playground.livro l
LEFT JOIN playground.livro_vendido lv ON l.id_livro = lv.id_livro
LEFT JOIN playground.autor a ON lv.id_autor = a.id_autor;

-- 4:
SELECT a.nome, l.titulo 
FROM playground.autor a
JOIN playground.livro_vendido lv ON a.id_autor = lv.id_autor
JOIN playground.livro l ON l.id_livro = lv.id_livro
WHERE data_nascimento < '1970-01-01';

-- 5:
SELECT * 
FROM playground.livro 
WHERE ano_publicacao > 2017;