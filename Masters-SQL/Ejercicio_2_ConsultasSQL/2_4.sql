-- SQLite
SELECT dbSNP_id, COUNT(*) AS 'Total_Occurrencies',assembly,ref_allele, alt_allele
FROM variant
WHERE type LIKE '%eletion' AND dbSNP_id != -1 AND phenotype_list LIKE '%_reast%'
GROUP BY 1,3
ORDER BY 2 DESC
LIMIT 10;
