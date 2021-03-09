-- SQLite
SELECT COUNT(variation_id) AS 'Num_Variations'
FROM variant
WHERE assembly = 'GRCh38' AND gene_symbol = 'TP53';