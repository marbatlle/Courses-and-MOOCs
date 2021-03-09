-- SQLite
SELECT gene_symbol, COUNT(*) AS 'total_ins_del'
FROM variant
WHERE assembly = 'GRCh37'
AND type LIKE '%nsertion' OR type LIKE '%eletion'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;