-- SQLite
SELECT gene_id, gene_symbol, chro_start, chro_stop
FROM variant
WHERE phenotype_list = 'Acute infantile liver failure due to synthesis defect of mtDNA-encoded proteins' AND assembly = 'GRCh38'
LIMIT 10;

SELECT gene_id, gene_symbol, COUNT(*)
FROM variant
WHERE phenotype_list = 'Acute infantile liver failure due to synthesis defect of mtDNA-encoded proteins' AND assembly = 'GRCh38'
GROUP BY 1
ORDER BY 3 DESC;

