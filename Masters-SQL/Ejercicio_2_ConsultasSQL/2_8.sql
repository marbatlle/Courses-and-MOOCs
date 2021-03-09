-- SQLite
WITH temp_signif AS (
SELECT *
FROM variant,clinical_sig
WHERE variant.ventry_id = clinical_sig.ventry_id
)
SELECT COUNT(*)
FROM temp_signif
WHERE assembly = 'GRCh37'
AND significance != 'Uncertain significance'
AND gene_symbol LIKE '%BRCA2%';
