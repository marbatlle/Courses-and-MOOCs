-- SQLite
WITH temp_signif AS (
SELECT *
FROM variant,clinical_sig
WHERE variant.ventry_id = clinical_sig.ventry_id
)
SELECT dbSNP_id, chro_start,chro_stop,ref_allele,alt_allele
FROM temp_signif
WHERE assembly = 'GRCh37'
AND (significance = 'Pathogenic' OR significance = 'Likely pathogenic')
AND gene_symbol LIKE '%HBB%'
AND dbSNP_id != -1
LIMIT 10;

WITH temp_signif AS (
SELECT *
FROM variant,clinical_sig
WHERE variant.ventry_id = clinical_sig.ventry_id
)
SELECT COUNT(*)
FROM temp_signif
WHERE assembly = 'GRCh37'
AND (significance = 'Pathogenic' OR significance = 'Likely pathogenic')
AND gene_symbol LIKE '%HBB%'
AND dbSNP_id != -1;




