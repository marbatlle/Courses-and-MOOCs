-- SQLite
SELECT COUNT(*)
FROM variant
WHERE assembly = 'GRCh38' 
AND chro = 13
AND chro_start BETWEEN 10000000 AND 20000000
AND chro_stop BETWEEN 10000000 AND 20000000;

