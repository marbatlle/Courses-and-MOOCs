-- SQLite

ALTER TABLE variant ADD length INTEGER NULL;

UPDATE variant SET length = 249.250621 WHERE chro = '1' AND assembly = 'GRCh37';
UPDATE variant SET length = 51.304566 WHERE chro = '22' AND assembly = 'GRCh37';
UPDATE variant SET length = 155.270560 WHERE chro = 'X' AND assembly = 'GRCh37';
UPDATE variant SET length = 248.956422 WHERE chro = '1' AND assembly = 'GRCh38';
UPDATE variant SET length = 50.818468 WHERE chro = '22' AND assembly = 'GRCh38';
UPDATE variant SET length = 156.040895 WHERE chro = 'X' AND assembly = 'GRCh38';

SELECT chro, assembly, COUNT(variation_id) AS 'Total Variations', length, ((COUNT(variation_id) * 1.00) / length) as 'Frequency'
FROM variant
WHERE (assembly = 'GRCh37' OR assembly = 'GRCh38')
AND (chro = '1' OR chro = '22' OR chro = 'X')
GROUP BY 1,2;

